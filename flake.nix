{
  description = "Lichtblick - integrated visualization and diagnosis tool for robotics";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };

    parts = {
      url = "github:hercules-ci/flake-parts";
    };
  };

  outputs = inputs @ { self, parts, ... }: (
    parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = { pkgs, self', ... }: {
        packages = let
          callPackageArgs = {
            src = self;
            version = pkgs.lib.pipe ./package.json [
              (builtins.readFile)
              (builtins.fromJSON)
              (builtins.getAttr "version")
            ];
          };
        in {
          default = self'.packages.desktop;

          desktop = pkgs.callPackage ./nix/desktop.nix callPackageArgs;
          web = pkgs.callPackage ./nix/web.nix callPackageArgs;
        };

        apps = {
          update-missing-hashes = {
            type = "app";
            program = pkgs.writeShellScriptBin "update-missing-hashes" ''
              ${pkgs.yarn-berry_3.yarn-berry-fetcher}/bin/yarn-berry-fetcher missing-hashes ./yarn.lock > ./nix/missing-hashes.json
            '';
          };
        };
      };
    }
  );
}
