final: prev: {
    acarsdec =  prev.callPackage ../pkgs/acarsdec.nix {};
    ax25-apps-ve7fet =  prev.callPackage ../pkgs/ax25-apps-ve7fet.nix {};
    ax25-tools-ve7fet = prev.callPackage ../pkgs/ax25-tools-ve7fet.nix {};
    cqrprop = prev.callPackage ../pkgs/cqrprop.nix {};
    dream = prev.libsForQt5.callPackage ../pkgs/dream.nix {};
    dump1090-sdrplay = prev.callPackage ../pkgs/dump1090-sdrplay.nix {};
    dumphfdl = prev.callPackage ../pkgs/dumphfdl.nix {};
    hamclock = prev.callPackage ../pkgs/hamclock.nix {};
    kh1util = prev.callPackage ../pkgs/kh1util.nix {};
    kx2util = prev.callPackage ../pkgs/kx2util.nix {};
    libacars =  prev.callPackage ../pkgs/libacars.nix {};
    libax25-ve7fet =  prev.callPackage ../pkgs/libax25-ve7fet.nix {};
    linbpq =  prev.callPackage ../pkgs/linbpq.nix {};
    qtsoundmodem =  prev.libsForQt5.callPackage ../pkgs/qtsoundmodem.nix {};
    qttermtcp =  prev.libsForQt5.callPackage ../pkgs/qttermtcp.nix {};
    sdrconnect = prev.callPackage ../pkgs/sdrconnect.nix {};
    sdrplay2 =  prev.callPackage ../pkgs/sdrplay2.nix {};
    soapysdrplay2 = prev.callPackage ../pkgs/soapysdrplay2.nix {};
    xrouter = prev.callPackage ../pkgs/xrouter.nix {};
}
