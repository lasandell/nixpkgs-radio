{ lib, stdenv, fetchFromGitHub, copyDesktopItems, iconConvTools, makeWrapper,
  makeDesktopItem, qmake, qtmultimedia, qtserialport, qtbase, wrapQtAppsHook }:

let
  rev = "0.73";
in
stdenv.mkDerivation rec {
  pname = "qttermtcp";
  version = "0.0.${rev}";

  src = fetchFromGitHub {
    owner = "g8bpq";
    repo = "QtTermTCP";
    hash = "sha256-TF6qc7bN9dVlef+wRyF8Y1ox16bViZLNjgNRqeJCnds=";
    # 0.73 tag points to 0.0.0.71 commit, so we use the hash instead
    rev = "e1ed8e1fb27378046f3ab390ef07b87a26cb6ced"; # inherit rev;
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
    description = "AX.25 packet radio client based on BPQTermTCP";
    longDescription = ''
      Binary is wrapped to set the working directory to ~/.config/QTermTCP
      so that it writes its config files there.
    '';
    homepage = "https://www.cantab.net/users/john.wiseman/Documents/QtTermTCP.html";
    license = licenses.unfree;
    platforms = platforms.linux;
    mainProgram = "QtTermTCP";
  };
}