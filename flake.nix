{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    fup.url = "github:gytis-ivaskevicius/flake-utils-plus";
    flake-compat.url = "github:edolstra/flake-compat";
  };
  outputs = { self, fup, ... }@inputs:
    fup.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];

      channelsConfig.allowUnfree = true;

      sharedOverlays = [ self.overlays.default ];

      overlays.default = import ./overlays;

      nixosModules = {
        sdrplay = import ./nixosModules/sdrplay.nix;
        sdrplay2 = import ./nixosModules/sdrplay2.nix;
      };

      outputsBuilder = channels: {
        packages = fup.lib.exportPackages { inherit (self.overlays) default; } channels;

        devShells.default = import ./devShells (channels.nixpkgs);
      };
    };
}
