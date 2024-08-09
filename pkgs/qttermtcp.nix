{ lib, stdenv, fetchFromGitHub, copyDesktopItems, iconConvTools,
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
    hash = "sha256-omvJ4jOQnEDc2aPqT8LkJDpo8iWsLoREyqEmq959TA8=";
    inherit rev;
  };

  nativeBuildInputs = [ copyDesktopItems iconConvTools qmake wrapQtAppsHook ];

  buildInputs = [ qtbase qtmultimedia qtserialport ];

  qmakeFlags = [
    "QMAKE_CXXFLAGS+=-Wno-error=format-security"
  ];

  postInstall = ''
    mkdir -p $out/bin
    cp QtTermTCP $out/bin
    icoFileToHiColorTheme QtTermTCP.ico QtTermTCP $out
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
    homepage = "https://www.cantab.net/users/john.wiseman/Documents/QtTermTCP.html";
    license = licenses.unfree;
    platforms = platforms.linux;
    mainProgram = "QtTermTCP";
  };
}