{ stdenv, lib, fetchurl, autoPatchelfHook, libudev-zero }:

let
  arch =
    if stdenv.isx86_64 then "x86_64"
    else if stdenv.isi686 then "i686"
    else if stdenv.isAarch64 then "aarch64"
    else throw "unsupported architecture";

  version = "2.13.1";

  srcs = rec {
    aarch64 = {
      url = "https://www.sdrplay.com/software/SDRplay_RSP_API-ARM64-${version}.run";
      hash = "sha256-AhCU9GGsyi62ZkvWJa/H2qFM17zeT+q0h9XbIAa8T3s=";
    };

    x86_64 = {
      url = "https://www.sdrplay.com/software/SDRplay_RSP_API-Linux-${version}.run";
      sha256 = "08j56rmvk3ycpsdgvhdci84wy72jy9x20mp995fwp8zzmyg0ncp2";
    };

    i686 = x86_64;
  };

  archDir = if stdenv.isAarch64 then "." else arch;
in
stdenv.mkDerivation {
  pname = "libsdrplay";
  inherit version;

  src = fetchurl srcs."${arch}";

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
    mkdir -p "$out/lib" "$out/include" "$out/etc/udev/rules.d"
    cp "${archDir}/$lib.so.$major.$minor" "$out/lib"
    ln -s "$out/lib/$lib.so.$major.$minor" "$out/lib/$lib.so.$major"
    ln -s "$out/lib/$lib.so.$major" "$out/lib/$lib.so"
    cp *.h "$out/include"
    cp *.rules "$out/etc/udev/rules.d"
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
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
  };
}
