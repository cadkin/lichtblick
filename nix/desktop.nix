{
  src, version,

  lib, stdenv, makeWrapper,

  yarn-berry_3,

  nodejs, electron
}:

stdenv.mkDerivation rec {
  pname = "lichtblick-desktop";
  inherit version src;

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit src missingHashes;
    hash = "sha256-jYD+SdgwR3+XUukmzzixHCbt8Xdrzr0RFqL00gn++yg=";
  };

  nativeBuildInputs = [
    makeWrapper
    yarn-berry_3.yarnBerryConfigHook
    yarn-berry_3
    nodejs
  ];

  env = {
    LICHTBLICK_YARN_PATH = "${lib.getExe yarn-berry_3}";
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  buildPhase = ''
    yarn run desktop:build:prod
  '';

  installPhase = ''
    ASSETS_DIR="$out/share/${pname}/assets"
    mkdir -p $ASSETS_DIR

    cp -r desktop/.webpack/* $ASSETS_DIR

    makeWrapper ${lib.getExe electron} $out/bin/${pname} \
      --add-flags $ASSETS_DIR
  '';
}
