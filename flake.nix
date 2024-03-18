{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    fup.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };
  outputs = { self, fup, ... }@inputs:
    fup.lib.mkFlake {
      inherit self inputs;

      channelsConfig.allowUnfree = true;

      sharedOverlays = [(final: prev: {
        qttermtcp =  prev.libsForQt5.callPackage ./pkgs/qttermtcp.nix {};
      })];

      outputsBuilder = channels: {
        packages = {
          inherit (channels.nixpkgs) qttermtcp;
        };
      };
    };
}