{ lib, stdenv, fetchFromGitHub, jansson, libconfig, libpcap, miniupnpc, paho-mqtt-c, zlib }:

stdenv.mkDerivation rec {
  pname = "linbpq";
  version = "6.0.24.59";

  src = fetchFromGitHub {
    owner = "g8bpq";
    repo = "linbpq";
    rev = "24.59c";
    hash = "sha256-jMrOM2L1WbTiyZ9gEQMmec/8+0uSHq331uxJREP+fPQ=";
  };

  buildInputs = [ jansson libconfig libpcap miniupnpc paho-mqtt-c zlib ];

  postPatch = ''
    substituteInPlace makefile \
      --replace-fail "sudo setcap" "#sudo setcap" \
      --replace-fail "-l:lib" "-l" \
      --replace-fail ".a" ""
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