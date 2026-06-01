# nixpkgs-radio

Nix flake containing some supplemental packages for ham and software defined radio.

## Packages

The following packages are currently provided for the `x86_64-linux` and `aarch64-linux` platforms:

- `acarsdec` - ACARS decoder
- `cqrprop` - Desktop ham propagation info widget
- `dream` - Digital Radio Modiale decoder
- `dump1090-sdrplay` - SDRplay fork of the popular ADS-B decoder
- `hamclock` - Ham radio dashboard
- `kh1util` - Elecraft KH1 Utility
- `kx2util` - Elecraft KX2 Utility
- `linbpq` - Packet radio node based on BPQ32
- `qtsoundmodem` - Packet radio modem based on UZ7HO's SoundModem
- `qttermtcp` - Packet radio terminal based on BPQTermTCP
- `sdrconnect` - Cross-platform client for SDRplay 
- `xrouter` - Packet radio router

## Overlays

- `default` - Overlay containing all the pacakges

## NixOS Modules

- `sdrplay` - Enable SDRplay plugin for SoapySDR