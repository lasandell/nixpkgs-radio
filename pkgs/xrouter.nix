{ lib, stdenv, fetchzip, alsa-lib, autoPatchelfHook }:

let
  version = "504a";
  platforms = {
    aarch64-linux = {
      url = "https://wiki.oarc.uk/_media/packet:xrouter:xrpi64v${version}.zip";
      sha256 = "sha256-LfF6mSyfrqWchRvoZCZPKo15fIPGixKfA7AQGsohGGo=";
    };
    x86_64-linux = {
      url = "https://wiki.oarc.uk/_media/packet:xrouter:xrlin64v${version}-vanessa.zip";
      sha256 = "sha256-FZ58VjSrzf7k+nNttL68N5f0QAk1qS2fCQeaAMYOiqg=";
    };
  };

  inherit (stdenv.hostPlatform) system;
in

with platforms.${system} or (throw "Unsupported system: ${system}");

stdenv.mkDerivation rec {
  pname = "xrouter";
  inherit version;

  src = fetchzip {
    inherit url;
    inherit sha256;
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ alsa-lib ];

  postInstall = ''
    mkdir -p $out/bin
    cp * $out/bin/xrouter
    chmod +x $out/bin/xrouter
  '';

  meta = with lib; {
    description = "Packet radio router";
    homepage = "https://wiki.oarc.uk/packet:xrouter";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = attrNames platforms;
    mainProgram = "xrouter";
  };
}
