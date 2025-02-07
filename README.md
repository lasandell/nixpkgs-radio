# nixpkgs-radio

Nix flake containing some supplemental packages for ham and software defined radio.

## Packages

The following packages are currently provided for the `x86_64-linux` and `aarch64-linux` platforms:

- `acarsdec` - ACARS decoder
- `ax25-apps-ve7fet` - VE7FET fork of ax25-apps
- `ax25-tools-ve7fet` - VE7FET fork of ax25-apps
- `cqrprop` - Desktop ham propagation info widget
- `dream` - Digital Radio Modiale decoder
- `dump1090-sdrplay` - SDRplay fork of the popular ADS-B decoder
- `dumphfdl` - Decoder for HFDL (HF ACARS)
- `hamclock` - Ham radio dashboard
- `kh1util` - Elecraft KH1 Utility
- `kx2util` - Elecraft KX2 Utility
- `libacars` - ACARS decoding library
- `libax25-ve7fet` - VE7FET fork of libax25
- `qtsoundmodem` - Packet radio modem based on UZ7HO's SoundModem
- `qttermtcp` - Packet radio client based on BPQTermTCP
- `sdrconnect` - Cross-platform client for SDRplay 
- `sdrplay2` - Legacy SDRplay library
- `soaprsdrplay2` - Legacy SDRplay plugin for SoapySDR

## Overlays

- `default` - Overlay containing all the pacakges

## NixOS Modules

- `sdrplay` - Enable SDRplay plugin for SoapySDR
- `sdrplay2` - Enable legacy SDRplay plugin for SoapySDR