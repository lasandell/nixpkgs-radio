{ lib, stdenv, fetchurl, atk, autoPatchelfHook, cairo,
  gdk-pixbuf, glib, gtk2, copyDesktopItems, iconConvTools,
  fontconfig, gcc, makeDesktopItem, makeWrapper, pango, webkitgtk_4_1, xorg }:

stdenv.mkDerivation rec {
  pname = "kh1util";
  version = "1.25.6.16";

  src = fetchurl {
    url = "https://ftp.elecraft.com/KH1/Utilities/KH1UtilityLINUX64BIT_1_25_6_16.tar.gz";
    hash = "sha256-oEjTY00Fj2/hQ3LWR3Yd+GGgP3fZ2qDnOeffDXo62ic=";
  };

  nativeBuildInputs = [ autoPatchelfHook copyDesktopItems iconConvTools makeWrapper ];

  buildInputs = [ atk cairo fontconfig gdk-pixbuf glib gtk2 pango webkitgtk_4_1 xorg.libX11 ];

  appendRunpaths = [ "${placeholder "out"}/lib" ];

  postInstall = ''
    mkdir -p $out/{bin,share/kh1util}
    cp -R * $out/share/kh1util
    wrapProgram $out/share/kh1util/kh1util --argv0 $out/share/kh1util/kh1util
    mv $out/share/kh1util/kh1util $out/bin/kh1util
    ln -s $out/share/kh1util/Libs $out/lib
  '';

  desktopItems = with meta; [
    (makeDesktopItem {
      name = pname;
      icon = pname;
      exec = mainProgram;
      comment = description;
      desktopName = "KH1 Utility";
      genericName = "Elecraft KH1 Utility";
      categories = [ "HamRadio" ];
      keywords = [ "Ham" "Radio" ];
    })
  ];

  meta = with lib; {
    description = "Elecraft KH1 Hand-Held 5-Band CW Transceiver Utility";
    homepage = "https://elecraft.com/pages/kx2-fully-portable-transceiver-firmware-and-utility";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "kh1util";
  };
}
