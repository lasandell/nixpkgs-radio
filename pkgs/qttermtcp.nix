{ lib, stdenv, fetchurl, qmake, qtbase, unzip, wrapQtAppsHook, }:

stdenv.mkDerivation rec {
  pname = "qttermtcp";
  version = "0.0.0.39";

  src = fetchurl {
    url = "https://www.cantab.net/users/john.wiseman/Downloads/QtTermSource.zip";
    hash = "sha256-PkR84kR9qRFFf/N/pEkq6TtiOihHGBFFQaQdVz60mdk=";
  };

  nativeBuildInputs = [ qmake unzip wrapQtAppsHook ];

  buildInputs = [ qtbase ];

  setSourceRoot = "sourceRoot=`pwd`";

  installPhase = ''
    mkdir -p $out/bin
    cp QtTermTCP $out/bin
  '';

  meta = with lib; {
    description = "QtTermTCP is a multi-platform version of BPQTermTCP";
    homepage = "https://www.cantab.net/users/john.wiseman/Documents/QtTermTCP.html";
    license = licenses.unfree;
    platforms = platforms.linux;
    mainProgram = "QtTermTCP";
  };
}