# Pins an overlay to a specific nixpkgs, so packages are built against
# that nixpkgs regardless of the consumer's version.
{ nixpkgs, overlay }:

final: prev:
let
  pinnedPkgs = import nixpkgs {
    inherit (prev.stdenv.hostPlatform) system;
    config = prev.config;
    overlays = [ overlay ];
  };
  overlayAttrs = overlay pinnedPkgs pinnedPkgs;
in
builtins.mapAttrs (name: _: pinnedPkgs.${name}) overlayAttrs
