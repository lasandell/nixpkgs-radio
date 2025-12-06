{ lib, stdenv, fetchFromGitHub, jansson, libconfig, libpcap, miniupnpc, paho-mqtt-c, zlib }:

stdenv.mkDerivation rec {
  pname = "linbpq";
  version = "6.0.25.13";

  src = fetchFromGitHub {
    owner = "g8bpq";
    repo = "linbpq";
    rev = "25.13";
    hash = "sha256-Wk3DF2uAKBUlMurzQDsysffpvys9NSxTwv3uJg4BdC8=";
  };

  buildInputs = [ jansson libconfig libpcap miniupnpc paho-mqtt-c zlib ];

  postPatch = ''
    substituteInPlace makefile \
      --replace-fail "sudo setcap" "#sudo setcap" \
  '';
  
  installPhase = ''
    mkdir -p $out/bin
    cp linbpq $out/bin
  '';

  meta = with lib; {
    description = "Packet radio node based on BPQ32";
    homepage = "https://www.cantab.net/users/john.wiseman/Documents/LinBPQGuides.html";
    license = licenses.unfree;
    platforms = platforms.linux;
    mainProgram = "linbpq";
  };
}