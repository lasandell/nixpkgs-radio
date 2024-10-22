{ stdenv, lib, fetchurl, copyDesktopItems, makeDesktopItem, xorg,
  extraVariants ? [ "web" "fb0" ],
  extraResolutions ? [ "800x480" "1600x960" "2400x1440" "3200x1920" ],
  defaultResolution ? builtins.head extraResolutions
}:

stdenv.mkDerivation rec {
  pname = "hamclock";
  version = "4.0.8";

  src = fetchurl {
    url = "https://clearskyinstitute.com/ham/HamClock/ESPHamClock.tgz";
    sha256 = "sha256-nZW0FvG1vh4uavbcftDJKPeYMlkfHLJoYhreyRFHJJ4=";
  };

  sourceRoot = "ESPHamClock";

  nativeBuildInputs = [ copyDesktopItems ];

  buildInputs = [ xorg.libX11 ];

  postInstall = ''
    mkdir -p $out/bin
    for resolution in ${lib.concatStringsSep " " extraResolutions}; do
      make -j $NIX_BUILD_CORES hamclock-$resolution
      cp hamclock-$resolution $out/bin
      for variant in ${lib.concatStringsSep " " extraVariants}; do
        make -j $NIX_BUILD_CORES hamclock-$variant-$resolution
        cp hamclock-$variant-$resolution $out/bin
      done
    done
    
    ln -s hamclock-${defaultResolution} $out/bin/hamclock

    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp hamclock.png $out/share/icons/hicolor/256x256/apps

    mkdir -p $out/share/man/man1
    cp hamclock.1 $out/share/man/man1
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      icon = pname;
      exec = meta.mainProgram;
      comment = meta.description;
      desktopName = "HamClock";
      genericName = "Ham Radio Dashboard";
      categories = [ "HamRadio" ];
      keywords = [ "Ham" "Radio" ];
    })
  ];

  meta = with lib; {
    description = "Display ham radio information on your desktop";
    homepage = "https://www.clearskyinstitute.com/ham/HamClock/";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "hamclock";
  };
}
