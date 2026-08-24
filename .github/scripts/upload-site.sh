#!/usr/bin/env bash
#
# Upload the built zensical site (./site) to the AMWA web server.
#
# Modelled on nmos-render-scripts' upload-site.sh (tarball + atomic swap via
# mktemp on the remote host), adapted for the zensical build output directory
# (./site) and staged under a "new/" prefix so we don't touch production while
# we're evaluating zensical:
#
#     /var/www/$SPEC_SERVER/new/$SITE_NAME
#
# Required environment (SSH_* come from repo/org secrets, SPEC_SERVER and
# SITE_NAME are set by the calling workflow):
#   SSH_USER, SSH_HOST, SSH_PRIVATE_KEY, SSH_KNOWN_HOSTS
#   SPEC_SERVER  e.g. specs.amwa.tv
#   SITE_NAME    e.g. in-template

set -o errexit

for var in SSH_USER SSH_HOST SSH_PRIVATE_KEY SSH_KNOWN_HOSTS SPEC_SERVER SITE_NAME; do
    if [[ -z "${!var:-}" ]]; then
        echo "$var not set" >&2
        exit 1
    fi
done

if [[ ! -d site ]]; then
    echo "error: ./site not found (run zensical build first)" >&2
    exit 1
fi

dest="/var/www/$SPEC_SERVER/new/$SITE_NAME"

if [[ -e .ssh ]]; then
    echo "Temp .ssh already exists: exiting for safety (check where you are running this from)" >&2
    exit 1
fi

echo "Setting up .ssh"
mkdir .ssh
chmod 700 .ssh
echo "$SSH_PRIVATE_KEY" > .ssh/id_rsa && chmod 600 .ssh/id_rsa
echo "$SSH_KNOWN_HOSTS" > .ssh/known_hosts && chmod 600 .ssh/known_hosts

tar_file="$SITE_NAME.tar.gz"
echo "Making local tar file $tar_file"
tar -czf "$tar_file" site

function do_ssh {
    # shellcheck disable=SC2029
    ssh -i .ssh/id_rsa -o UserKnownHostsFile=.ssh/known_hosts "$SSH_USER@$SSH_HOST" "$@" || exit 1
}

echo "Ensuring parent directory exists on remote:"
do_ssh "mkdir -p /var/www/$SPEC_SERVER/new"

echo "Making destination directory:"
dest_new=$(do_ssh "mktemp -d $dest.XXXXXX")
echo "$dest_new"

echo "Uploading"
if ! scp -i .ssh/id_rsa -o UserKnownHostsFile=.ssh/known_hosts "$tar_file" "$SSH_USER@$SSH_HOST:$dest_new/"; then
    do_ssh rm -rf "$dest_new"
    exit 1
fi

echo "Extracting"
do_ssh "cd $dest_new && tar --strip-components=1 -xf $tar_file"

echo "Replacing old site"
do_ssh "if [ -e $dest ]; then mv $dest $dest.old; fi; mv $dest_new $dest; chmod 775 $dest; rm -rf $dest.old"

echo "Deleting local tar file"
rm "$tar_file"

echo "Deleting .ssh"
rm -rf .ssh

echo "Site is https://$SPEC_SERVER/new/$SITE_NAME"
