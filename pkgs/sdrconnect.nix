{ lib, stdenv, fetchurl, alsaLib, copyDesktopItems, iconConvTools, fontconfig,
  gcc, icu, libusb1, makeDesktopItem, util-linux, xorg }:

stdenv.mkDerivation rec {
  pname = "sdrconnect";
  version = "unstable-2024-05-24";

  src = fetchurl {
    url = "https://www.sdrplay.com/software/SDRconnect_linux-x64_f795c3df0.run";
    hash = "sha256-KRs4zZxE5SzxjAqcmMJDuXTnRM0fpKfeth0aFanRxI0==";
  };

  nativeBuildInputs = [ copyDesktopItems iconConvTools ];

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

  postInstall = ''
    mkdir -p $out/bin $out/lib
    cp SDRconnect $out/bin
    cp *.so $out/lib
    icoFileToHiColorTheme sdrconnect.ico sdrconnect $out
  '';

  postFixup = ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/SDRconnect
    for file in $out/{bin,lib}/*; do
      patchelf --set-rpath "$out/lib:${lib.makeLibraryPath buildInputs}" $file
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      icon = pname;
      exec = meta.mainProgram;
      comment = meta.description;
      desktopName = "SDRconnect";
      genericName = "SDRplay Client";
      categories = [ "HamRadio" ];
      keywords = [ "Ham" "Radio" "SDR" ];
    })
  ];

  meta = with lib; {
    description = "Cross platform GUI client for SDRplay";
    homepage = "https://www.sdrplay.com/sdrconnect/";
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    mainProgram = "SDRconnect";
  };
}

