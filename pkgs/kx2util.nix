{ lib, stdenv, fetchurl, atk, autoPatchelfHook, cairo,
  gdk-pixbuf, glib, gtk2, copyDesktopItems, iconConvTools,
  fontconfig, gcc, makeDesktopItem, makeWrapper, pango, webkitgtk_4_1, xorg }:

stdenv.mkDerivation rec {
  pname = "kx2util";
  version = "1.23.4.23";

  src = fetchurl {
    url = "https://ftp.elecraft.com/KX2/Utilities/KX2UtilityLINUX64BIT_1_23_4_23.tar.gz";
    hash = "sha256-aTA/m7mPT6IiU+RazNJjz9+RFV/DOx7C1iEVbA7vvt4=";
  };

  nativeBuildInputs = [ autoPatchelfHook copyDesktopItems iconConvTools makeWrapper ];

  buildInputs = [ atk cairo fontconfig gdk-pixbuf glib gtk2 pango webkitgtk_4_1 xorg.libX11 ];

  appendRunpaths = [ "${placeholder "out"}/lib" ];

  postInstall = ''
    mkdir -p $out/{bin,share/kx2util}
    cp -R * $out/share/kx2util
    wrapProgram $out/share/kx2util/kx2util --argv0 $out/share/kx2util/kx2util
    mv $out/share/kx2util/kx2util $out/bin/kx2util
    ln -s $out/share/kx2util/Libs $out/lib
  '';

  desktopItems = with meta; [
    (makeDesktopItem {
      name = pname;
      icon = pname;
      exec = mainProgram;
      comment = description;
      desktopName = "KX2 Utility";
      genericName = "Elecraft KX2 Utility";
      categories = [ "HamRadio" ];
      keywords = [ "Ham" "Radio" ];
    })
  ];

  meta = with lib; {
    description = "Elecraft KX2 Ultra-Portable Transceiver Utility";
    homepage = "https://elecraft.com/pages/kx2-fully-portable-transceiver-firmware-and-utility";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "kx2util";
  };
}
