{ lib, stdenv, fetchurl, alsaLib, copyDesktopItems, iconConvTools, fontconfig,
  gcc, icu, libusb1, makeDesktopItem, util-linux, xorg }:

let
  date = "2024-05-24";
  hash = "f795c3df0";

  platforms = {
    aarch64-linux = {
      arch = "arm64";
      sha256 = "sha256-J/WJpVne11j4JIZlSzMeMA6CdaN7qpWKhKhjmIlrcGk=";
    };
    x86_64-linux = {
      arch = "x64";
      sha256 = "sha256-KRs4zZxE5SzxjAqcmMJDuXTnRM0fpKfeth0aFanRxI0==";
    };
  };

  inherit (stdenv.hostPlatform) system;
in

with platforms.${system} or (throw "Unsupported system: ${system}");

stdenv.mkDerivation rec {
  pname = "sdrconnect";
  version = "unstable-${date}";

  src = fetchurl {
    url = "https://www.sdrplay.com/software/SDRconnect_linux-${arch}_${hash}.run";
    inherit sha256;
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

  desktopItems = with meta; [
    (makeDesktopItem {
      name = pname;
      icon = pname;
      exec = mainProgram;
      comment = description;
      desktopName = "SDRconnect";
      genericName = "SDRplay Client";
      categories = [ "HamRadio" ];
      keywords = [ "Ham" "Radio" "SDR" ];
    })
  ];

  meta = with lib; {
    description = "Cross platform GUI client for SDRplay";
    homepage = "https://www.sdrplay.com/sdrconnect/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = attrNames platforms;
    mainProgram = "SDRconnect";
  };
}
