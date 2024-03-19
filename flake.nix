{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    fup.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };
  outputs = { self, fup, ... }@inputs:
    fup.lib.mkFlake {
      inherit self inputs;

      channelsConfig.allowUnfree = true;

      sharedOverlays = [ self.overlays.default ];

      overlays = {
        default = import ./overlays;
      };

      outputsBuilder = channels: {
        packages = fup.lib.exportPackages self.overlays channels;
      };
    };
}