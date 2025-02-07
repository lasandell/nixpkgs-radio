{ lib, stdenv, fetchFromGitHub, autoPatchelfHook, copyDesktopItems, icoutils,
  makeWrapper, makeDesktopItem, alsa-lib, fftwFloat, pulseaudio, qmake,
  qtmultimedia, qtserialport, qtbase, wrapQtAppsHook }:

let
  rev = "0.73";
in
stdenv.mkDerivation rec {
  pname = "qtsoundmodem";
  version = "0.0.${rev}";

  src = fetchFromGitHub {
    owner = "g8bpq";
    repo = "QtSoundModem";
    hash = "sha256-pflPC0VIKrEu6D5wzBHLQYkNFaIpi8HuIfWoOgZLwgo=";
    inherit rev;
  };

  nativeBuildInputs = [ autoPatchelfHook copyDesktopItems icoutils qmake wrapQtAppsHook ];

  buildInputs = [ alsa-lib fftwFloat pulseaudio qtbase qtmultimedia qtserialport ];

  runtimeDependencies = [ pulseaudio ];

  postPatch = ''
    substituteInPlace tcpCode.cpp \
      --replace-fail 'qDebug(datas.data())' 'qDebug() << datas.data()'
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp QtSoundModem $out/bin

    # icoFileToHiColorTheme doesn't work with palette icons
    mkdir -p $out/share/icons/hicolor/32x32/apps
    icotool --icon -x QtSoundModem.ico
    cp QtSoundModem_1_32x32x4.png $out/share/icons/hicolor/32x32/apps/QtSoundModem.png
  '';

  # Force QtSoundModem.ini to be placed in ~/.config
  # Have to double wrap due to wrapQtAppsHook not supporting --run
  postFixup = ''
    source ${makeWrapper}/nix-support/setup-hook
    wrapProgram $out/bin/QtSoundModem \
      --run 'mkdir -p "$HOME/.config"' \
      --run 'cd "$HOME/.config"'
  '';

  desktopItems = with meta; [
    (makeDesktopItem {
      name = "QtSoundModem";
      icon = "QtSoundModem";
      exec = "QtSoundModem";
      desktopName = "QtSoundModem";
      genericName = "Packet Radio Modem";
      categories = [ "HamRadio" ];
      keywords = [ "Ham" "Radio" "Packet"];
      comment = description;
    })
  ];

  meta = with lib; {
    description = "Packet radio modem based on UZ7HO's SoundModem";
    homepage = "https://www.cantab.net/users/john.wiseman/Documents/QtSoundModem.html";
    license = licenses.unfree;
    platforms = platforms.linux;
    mainProgram = "QtSoundModem";
  };
}