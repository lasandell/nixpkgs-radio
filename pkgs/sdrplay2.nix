{ stdenv, lib, fetchurl, autoPatchelfHook, libudev-zero }:

let
  version = "2.13.1";

  platforms = {
    aarch64-linux = {
      arch = "ARM64";
      archDir = ".";
      sha256 = "sha256-AhCU9GGsyi62ZkvWJa/H2qFM17zeT+q0h9XbIAa8T3s=";
    };
    x86_64-linux = {
      arch = "Linux";
      archDir = "x86_64";
      sha256 = "sha256-4jILnq//o8tdSelWIHryUhzPCYqswf2avsyPuWs2RSI=";
    };
  };

  inherit (stdenv.hostPlatform) system;
in

with platforms.${system} or (throw "Unsupported system: ${system}");

stdenv.mkDerivation {
  pname = "libsdrplay";
  inherit version;

  src = fetchurl {
    url = "https://www.sdrplay.com/software/SDRplay_RSP_API-${arch}-${version}.run";
    inherit sha256;
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ libudev-zero ];

  unpackPhase = ''
    sh "$src" --noexec --target .
  '';

  installPhase = ''
    lib=libmirsdrapi-rsp
    major=`echo "$version" | cut -d. -f1`
    minor=`echo "$version" | cut -d. -f2`
    libFile="$libName.so.$major.$minor"
    mkdir -p "$out/lib" "$out/include" "$out/lib/udev/rules.d"
    cp "${archDir}/$lib.so.$major.$minor" "$out/lib"
    ln -s "$out/lib/$lib.so.$major.$minor" "$out/lib/$lib.so.$major"
    ln -s "$out/lib/$lib.so.$major" "$out/lib/$lib.so"
    cp *.h "$out/include"
    cp *.rules "$out/lib/udev/rules.d"
  '';

  meta = with lib; {
    description = "Library for interfacing with SDRplay devices (legacy)";
    longDescription = ''
      Proprietary library and api service for working with SDRplay devices.
      For documentation and licensing details see
      https://www.sdrplay.com/docs/SDRplay_SDR_API_Specification.pdf
    '';
    homepage = "https://www.sdrplay.com/downloads/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = attrNames platforms;
  };
}
