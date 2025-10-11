{ ... }:

{
  perSystem = { pkgs, self', ... }: {
    devShells.default = pkgs.mkShell {
      name = "lichtblick-dev";

      inputsFrom = [
        self'.packages.lichtblick-desktop
      ];

      packages = [
        pkgs.electron
      ];

      env = self'.packages.lichtblick-desktop.passthru.env;

      shellHook = ''
        if [ ! -d "$PWD/node_modules" ]; then
          echo "Running 'yarn install' to setup dev dependencies..."
          yarn install
        fi
      '';
    };
  };
}
