{ lib, stdenv, fetchurl, makeDesktopItem, alsaLib, fontconfig, gcc, icu, libusb1, util-linux, xorg }:

let
  desktopItem = makeDesktopItem {
    name = "sdrconnect";
    desktopName = "SDRconnect";
    comment = "SDRplay's SDRconnect";
    icon = "sdrconnect";
    exec = "SDRconnect";
    categories = [ "X-SDR" ];
    startupNotify = true;
  };
in

stdenv.mkDerivation rec {
  pname = "sdrconnect";
  version = "unstable-2024-05-24";

  src = fetchurl {
    url = "https://www.sdrplay.com/software/SDRconnect_linux-x64_f795c3df0.run";
    hash = "sha256-KRs4zZxE5SzxjAqcmMJDuXTnRM0fpKfeth0aFanRxI0==";
  };

  # Only used to set rpath with patchelf
  buildInputs = [
    # elf dependencies
    alsaLib
    fontconfig
    libusb1
    util-linux # for libuuid
    gcc.cc.lib # for libstdc++
    # dlopen dependencies
    icu
    xorg.libX11
    xorg.libICE
    xorg.libSM
  ];

  unpackPhase = ''
    bash $src --target . --noexec
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/share/icons/hicolor/128x128/apps/ $out/share/applications
    cp SDRconnect $out/bin
    cp *.so $out/lib
    cp sdrconnect.ico $out/share/icons/hicolor/128x128/apps
    ln -s ${desktopItem}/share/applications/sdrconnect.desktop $out/share/applications
  '';

  postFixup = ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/SDRconnect
    for file in $out/{bin,lib}/*; do
      patchelf --set-rpath "$out/lib:${lib.makeLibraryPath buildInputs}" $file
    done
  '';

  meta = with lib; {
    description = "Cross platform GUI client for SDRplay";
    homepage = "https://www.sdrplay.com/sdrconnect/";
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    mainProgram = "SDRconnect";
  };
}

