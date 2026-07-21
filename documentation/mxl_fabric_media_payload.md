# MXL Fabric: Media Payload Calculation

## Goal
Estimate wire bandwidth for MXL media streams over RDMA/RoCE fabrics.

## Constants
- `WIRE_OVERHEAD_BYTES = 82`
- `ROCE_OVERHEAD_BYTES = 44`
- `effective_payload_per_packet = mtu - ROCE_OVERHEAD_BYTES`

## Assumptions
- Ethernet + IPv4 + UDP + RoCEv2 BTH framing.
- No VLAN tag, no IPv4 options, no InfiniBand extension headers.
- `82` bytes are counted as on-wire overhead per packet:
	- `8` preamble/SFD + `12` IFG + `14` Ethernet + `20` IPv4 + `8` UDP + `12` BTH + `4` ICRC + `4` FCS.
- `44` bytes are counted inside MTU (payload-reducing transport overhead):
	- `20` IPv4 + `8` UDP + `12` BTH + `4` ICRC.
- `mtu` is the L3 packet budget used in the transport calculation, so media payload capacity per packet is `mtu - 44`.
- Rates are presented in decimal units (`MB/s = 10^6 B/s`, `GB/s = 10^9 B/s`).

Wire bandwidth model:

$$
\text{wire\_bytes\_per\_second} = \text{media\_bytes\_per\_second} + \text{packets\_per\_second} \times 82
$$

---

## Video (v210)

$$
\text{bytes\_per\_frame}(w,h) = \lceil w/48 \rceil \times 128 \times h
$$

$$
\text{packets\_per\_second} = \left\lceil \frac{\text{bytes\_per\_frame}}{\text{mtu}-44} \right\rceil \times fps
$$

$$
\text{media\_bytes\_per\_second} = \text{bytes\_per\_frame} \times fps
$$

Example (`1920x1080p25`, `mtu=1400`):
- `bytes_per_frame = 5,529,600`
- `wire_bytes_per_second = 146,599,900 B/s`
- `wire_rate = 0.14660 GB/s`

---

## Audio (float32 PCM)

$$
\text{media\_bytes\_per\_second} = channels \times sample\_rate \times 4
$$

$$
\text{bytes\_per\_packet} = channels \times sample\_rate \times 4 \times ptime
$$

$$
\text{packets\_per\_second} = \left\lceil \frac{\text{bytes\_per\_packet}}{\text{mtu}-44} \right\rceil \times \frac{1}{ptime}
$$

Example (`2ch`, `48kHz`, `ptime=10ms`, `mtu=1400`):
- `media_bytes_per_second = 384,000 B/s`
- `wire_bytes_per_second = 408,600 B/s`
- `wire_rate = 0.41 MB/s` (rounded)

---

## Data (video/smpte291 in MXL)

In this repo, MXL sets data grain payload to `4096 bytes` for `video/smpte291`.

$$
\text{media\_bytes\_per\_second} = 4096 \times grain\_rate
$$

$$
\text{packets\_per\_second} = \left\lceil \frac{4096}{\text{mtu}-44} \right\rceil \times grain\_rate
$$

Example (`grain_rate=60`, `mtu=1400`):
- `wire_bytes_per_second = 265,440 B/s`
- `wire_rate = 0.27 MB/s` (rounded)

---

## Practical Notes
- For audio, bandwidth is `ptime`-sensitive.
