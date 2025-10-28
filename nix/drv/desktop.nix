{
  src, version,

  lib, stdenv, makeWrapper, makeDesktopItem, copyDesktopItems,

  yarn-berry_3,

  nodejs, electron, imagemagick
}:

stdenv.mkDerivation rec {
  pname = "lichtblick-desktop";
  inherit version src;

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit src missingHashes;
    hash = "sha256-dDTJIvKSEFT3hejhyQJph9v4yjIjVQ99HwzgmPzHAY4=";
  };

  nativeBuildInputs = [
    makeWrapper
    yarn-berry_3.yarnBerryConfigHook
    yarn-berry_3.yarn-berry-offline
    nodejs
    imagemagick
    copyDesktopItems
  ];

  env = {
    LICHTBLICK_YARN_PATH = "${lib.getExe yarn-berry_3.yarn-berry-offline}";
    ELECTRON_OVERRIDE_DIST_PATH = "${electron}/bin";
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  passthru = {
    inherit env;
  };

  buildPhase = ''
    yarn run desktop:build:prod
  '';

  installPhase = ''
    runHook preInstall

    SHARE_DIR="$out/share/lichtblick"
    mkdir -p $SHARE_DIR

    # Wrapper
    WEBPACK_DIR="$SHARE_DIR/webpack"
    mkdir -p $WEBPACK_DIR

    cp -r desktop/.webpack/* $WEBPACK_DIR

    makeWrapper ${lib.getExe electron} $out/bin/lichtblick \
      --add-flags $WEBPACK_DIR

    # Desktop
    mkdir -p $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256}/apps
    for dimension in 16x16 32x32 48x48 64x64 128x128 256x256; do
      magick convert -background none packages/suite-desktop/resources/icon/icon.svg \
        -geometry $dimension \
        $out/share/icons/hicolor/$dimension/apps/lichtblick.png
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "lichtblick";
      desktopName = "Lichtblick";
      exec = "lichtblick";
      icon = "lichtblick";
      comment = "Integrated visualization and diagnosis tool for robotics";
      categories = [
        "Development"
      ];
      mimeTypes = [
        "application/octet-stream"
        "application/zip"
        "x-scheme-handler/lichtblick"
      ];
    })
  ];

  doCheck = true;
  checkPhase = ''
    yarn run test
  '';

  meta = {
    description = "Integrated visualization and diagnosis tool for robotics";
  };
}
