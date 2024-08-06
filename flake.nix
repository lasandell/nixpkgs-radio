{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    fup.url = "github:gytis-ivaskevicius/flake-utils-plus";
    flake-compat.url = "github:edolstra/flake-compat";
  };
  outputs = { self, fup, ... }@inputs:
    fup.lib.mkFlake {
      inherit self inputs;

      channelsConfig.allowUnfree = true;

      sharedOverlays = [ self.overlays.default ];

      overlays = {
        default = import ./overlays;
        sdrplay = import ./overlays/sdrplay.nix;
        sdrplay2 = import ./overlays/sdrplay2.nix;
      };

      outputsBuilder = channels: {
        packages = fup.lib.exportPackages { inherit (self.overlays) default; } channels;
      };
    };
}