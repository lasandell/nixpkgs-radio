final: prev: {
    acarsdec =  prev.callPackage ../pkgs/acarsdec.nix {};
    cqrprop = prev.callPackage ../pkgs/cqrprop.nix {};
    dream = prev.libsForQt5.callPackage ../pkgs/dream.nix {};
    dump1090-sdrplay = prev.callPackage ../pkgs/dump1090-sdrplay.nix {};
    hamclock = prev.callPackage ../pkgs/hamclock.nix {};
    kh1util = prev.callPackage ../pkgs/kh1util.nix {};
    kx2util = prev.callPackage ../pkgs/kx2util.nix {};
    linbpq =  prev.callPackage ../pkgs/linbpq.nix {};
    qtsoundmodem =  prev.libsForQt5.callPackage ../pkgs/qtsoundmodem.nix {};
    qttermtcp =  prev.libsForQt5.callPackage ../pkgs/qttermtcp.nix {};
    sdrconnect = prev.callPackage ../pkgs/sdrconnect.nix {};
    xrouter = prev.callPackage ../pkgs/xrouter.nix {};
}
