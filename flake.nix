{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
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
      };

      outputsBuilder = channels: {
        packages = fup.lib.exportPackages { inherit (self.overlays) default; } channels;
      };
    };
}