final: prev: {
    acarsdec =  prev.callPackage ../pkgs/acarsdec.nix {};
    cqrprop = prev.callPackage ../pkgs/cqrprop.nix {};
    dump1090-sdrplay = prev.callPackage ../pkgs/dump1090-sdrplay.nix {};
    dumphfdl = prev.callPackage ../pkgs/dumphfdl.nix {};
    libacars =  prev.callPackage ../pkgs/libacars.nix {};
    qttermtcp =  prev.libsForQt5.callPackage ../pkgs/qttermtcp.nix {};
    sdrconnect = prev.callPackage ../pkgs/sdrconnect.nix {};
    sdrplay2 =  prev.callPackage ../pkgs/sdrplay2.nix {};
}
