{
  src, version,

  lib, stdenv,

  yarn-berry_3,

  nodejs, electron
}:

stdenv.mkDerivation rec {
  pname = "lichtblick-web";
  inherit version src;

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit src missingHashes;
    hash = "sha256-zNp9nZePdYlmx46ILxYNWa1U/POJvrPUFbsQlljvAME=";
  };

  nativeBuildInputs = [
    yarn-berry_3.yarnBerryConfigHook
    yarn-berry_3
    nodejs
  ];

  env = {
    LICHTBLICK_YARN_PATH = "${lib.getExe yarn-berry_3}";
    ELECTRON_OVERRIDE_DIST_PATH = "${electron}/bin";
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  buildPhase = ''
    yarn run web:build:prod
  '';

  installPhase = ''
    ASSETS_DIR="$out/srv/lichtblick"
    mkdir -p $ASSETS_DIR

    cp -r web/.webpack/* $ASSETS_DIR
  '';

  doCheck = true;
  checkPhase = ''
    yarn run test
  '';
}
