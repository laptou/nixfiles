{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  pname = "nrfutil";
  version = "8.0.0";
  
  src = fetchurl {
    url = "https://files.nordicsemi.com/ui/api/v1/download?repoKey=swtools&path=external/nrfutil/executables/universal-apple-darwin/nrfutil&isNativeBrowsing=false";
    hash = "sha256-cmyObky14IEfNCYg+IRyNRsSA/Kvjie3ROZT80oI3rQ=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/nrfutil
    chmod +x $out/bin/nrfutil
  '';
  
  meta = with lib; {
    description = "Nordic Semiconductor nRF Util";
    homepage = "https://www.nordicsemi.com/Products/Development-tools/nRF-Util";
    platforms = platforms.darwin;
    license = licenses.unfree;
    maintainers = [];
  };
}