final: prev: {
    acarsdec =  prev.callPackage ../pkgs/acarsdec.nix {};
    libacars =  prev.callPackage ../pkgs/libacars.nix {};
    qttermtcp =  prev.libsForQt5.callPackage ../pkgs/qttermtcp.nix {};
    dump1090-sdrplay = prev.callPackage ../pkgs/dump1090-sdrplay.nix {};
}
