{ lib, stdenv, fetchFromGitHub, copyDesktopItems, iconConvTools, makeWrapper,
  makeDesktopItem, qmake, qtmultimedia, qtserialport, qtbase, wrapQtAppsHook }:

let
  rev = "0.78";
in
stdenv.mkDerivation rec {
  pname = "qttermtcp";
  version = "0.0.${rev}";

  src = fetchFromGitHub {
    owner = "g8bpq";
    repo = "QtTermTCP";
    hash = "sha256-Zyb6vakBU8AHbjx5tHMRBgSDTTqYzYpGtD+cYdSgHrI=";
    inherit rev;
  };

  nativeBuildInputs = [ copyDesktopItems iconConvTools qmake wrapQtAppsHook ];

  buildInputs = [ qtbase qtmultimedia qtserialport ];

  postPatch = ''
    substituteInPlace QtTermTCP.cpp \
      --replace-fail 'qDebug(datas.data())' 'qDebug() << datas.data()'
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp QtTermTCP $out/bin
    icoFileToHiColorTheme QtTermTCP.ico QtTermTCP $out
  '';

  # Force QtTermTCP.ini to be placed in ~/.config
  # Have to double wrap due to wrapQtAppsHook not supporting --run
  postFixup = ''
    source ${makeWrapper}/nix-support/setup-hook
    wrapProgram $out/bin/QtTermTCP \
      --run 'mkdir -p "$HOME/.config"' \
      --run 'cd "$HOME/.config"'
  '';

  desktopItems = with meta; [
    (makeDesktopItem {
      name = "QtTermTCP";
      icon = "QtTermTCP";
      exec = "QtTermTCP";
      desktopName = "QtTermTCP";
      genericName = "Packet Radio Client";
      categories = [ "HamRadio" ];
      keywords = [ "Ham" "Radio" "Packet"];
      comment = description;
    })
  ];

  meta = with lib; {
    description = "Packet radio terminal based on BPQTermTCP";
    homepage = "https://www.cantab.net/users/john.wiseman/Documents/QtTermTCP.html";
    license = licenses.unfree;
    platforms = platforms.linux;
    mainProgram = "QtTermTCP";
  };
}