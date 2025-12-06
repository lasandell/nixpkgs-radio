{ lib, stdenv, fetchFromGitHub, copyDesktopItems, iconConvTools, makeWrapper,
  makeDesktopItem, qmake, qtmultimedia, qtserialport, qtbase, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "qttermtcp";
  version = "0.0.0.79";
  # version = "0.0.${rev}"

  src = fetchFromGitHub {
    owner = "g8bpq";
    repo = "QtTermTCP";
    hash = "sha256-+kCbqUfSBhEu8VSeYEEHLAMKTBhpBQlJB+12iuz+VEM=";
    # Use commit hash due to 0.79 tag with 0.0.0.78 version
    rev = "a5e1b1389cbd9b3718b9ae41277f90633154cf47";
    # rev = "0.79";
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