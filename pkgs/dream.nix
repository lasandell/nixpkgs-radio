{ stdenv, lib, fetchsvn, copyDesktopItems, fdk_aac, fftw, hamlib, libopus, libpcap,
  libsndfile, makeDesktopItem, pkg-config, pulseaudio, qmake, qtbase, qtwebengine,
  qwt6_1, speexdsp, makeWrapper, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "dream";
  version = "2.3";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/drm/code/tags/dream-${version}";
    hash = "sha256-nok/9QFqm9YAok1UAvKCdlSxNjZwSVUW6QaN0lg7cfU=";
    rev = "1412";
  };

  nativeBuildInputs = [ copyDesktopItems pkg-config qmake wrapQtAppsHook ];

  buildInputs = [
    fdk_aac fftw hamlib libopus libpcap libsndfile pulseaudio qtbase
    qtwebengine qwt6_1 speexdsp
  ];

  postPatch = ''
    substituteInPlace dream.pro \
      --replace-fail /usr/bin $out/bin \
      --replace-fail /usr/share $out/share
    substituteInPlace src/GUI-QT/DRMPlot.h \
      --replace-fail '/* Qwt includes */' '#include <qwt_text.h>'
  '';

  qmakeFlags = [
    "CONFIG+=fdk-aac"
    "CONFIG+=hamlib"
    "CONFIG+=opus"
    "CONFIG+=pulseaudio"
    "CONFIG+=sndfile"
    "CONFIG+=sound"
    "CONFIG+=speexdsp"
    "INCLUDEPATH+=${qwt6_1}/include"
    "LIBS+=-lqwt"
    "QT+=webenginewidgets"
  ];

  postInstall = ''
    iconPath=$out/share/icons/hicolor/scalable/apps
    mkdir -p $iconPath
    cp src/GUI-QT/res/MainIcon.svg $iconPath/dream.svg
  '';

  # Force config files to be placed in ~/.config/dream
  # Have to double wrap due to wrapQtAppsHook not supporting --run
  postFixup = ''
    source ${makeWrapper}/nix-support/setup-hook
    wrapProgram $out/bin/dream \
      --run 'mkdir -p "$HOME/.config/dream"' \
      --run 'cd "$HOME/.config/dream"'
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      icon = pname;
      exec = meta.mainProgram;
      comment = meta.description;
      desktopName = "Dream";
      genericName = "Digital Radio Mondiale Receiver";
      categories = [ "HamRadio" ];
      keywords = [ "Ham" "Radio" "SDR" "DRM" ];
    })
  ];

  meta = with lib; {
    description = "Software radio for AM and Digital Radio Mondiale (DRM)";
    longDescription = ''
      Binary is wrapped to set the working directory to ~/.config/dream so that
      it writes its config files there. This verison crashes when setting the
      audio device, so you may need to set it manaully in ~/.config/dream/Dream.ini.
    '';
    homepage = "https://sourceforge.net/projects/drm/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    mainProgram = "dream";
  };
}
