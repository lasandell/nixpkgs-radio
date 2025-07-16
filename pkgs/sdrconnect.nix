{ lib, stdenv, fetchurl, alsa-lib, autoPatchelfHook, copyDesktopItems, iconConvTools,
  fontconfig, gcc, icu, libusb1, makeDesktopItem, util-linux, xorg }:

let
  version = "1.0.4";
  hash = "83273bcd8";
  platforms = {
    aarch64-linux = {
      arch = "arm64";
      sha256 = "sha256-PiKSbc+7hfJ+GkLlM2jWeUuD++3hFHB/pP7fBTmEMj0=";
    };
    x86_64-linux = {
      arch = "x64";
      sha256 = "sha256-gelLMfbNhpnFGqP1dCzkLdTz28lM6dctJcbopYUdtmQ=";
    };
  };

  inherit (stdenv.hostPlatform) system;
in

with platforms.${system} or (throw "Unsupported system: ${system}");

stdenv.mkDerivation rec {
  pname = "sdrconnect";
  inherit version;

  src = fetchurl {
    url = "https://www.sdrplay.com/software/SDRconnect_linux-${arch}_${hash}.run";
    inherit sha256;
  };

  nativeBuildInputs = [ autoPatchelfHook copyDesktopItems iconConvTools ];

  buildInputs = [
    alsa-lib
    fontconfig
    libusb1
    util-linux # for libuuid
    gcc.cc.lib # for libstdc++
  ];

  runtimeDependencies = [
    icu
    xorg.libX11
    xorg.libICE
    xorg.libSM
  ];

  appendRunpaths = [ "${placeholder "out"}/lib" ];

  unpackPhase = ''
    bash $src --target . --noexec
  '';

  postInstall = ''
    mkdir -p $out/bin $out/lib
    cp SDRconnect $out/bin
    cp *.so $out/lib
    icoFileToHiColorTheme sdrconnect.ico sdrconnect $out
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
