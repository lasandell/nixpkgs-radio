{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      overlay = import ./overlays;
    in
    {
      overlays.default = import ./lib/pinOverlay.nix {
        inherit nixpkgs overlay;
      };

      nixosModules = {
        sdrplay = import ./nixosModules/sdrplay.nix;
        sdrplay2 = import ./nixosModules/sdrplay2.nix;
      };
    }
    //
    flake-utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ overlay ];
        };
        overlayPkgs = overlay pkgs pkgs;
      in
      {
        packages = nixpkgs.lib.filterAttrs (n: _: builtins.hasAttr n overlayPkgs) pkgs;

        devShells.default = import ./devShells pkgs;
      }
    );
}
