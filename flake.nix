{
  description = "Lichtblick - integrated visualization and diagnosis tool for robotics";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/release-26.05";
    };

    parts = {
      url = "github:hercules-ci/flake-parts";
    };
  };

  outputs = inputs @ { self, nixpkgs, parts, ... }: (
    parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      flake.lichtblick.version = nixpkgs.lib.pipe ./package.json [
        (builtins.readFile)
        (builtins.fromJSON)
        (builtins.getAttr "version")
      ];

      imports = [
        ./nix/modules/develop.nix
        ./nix/modules/packages.nix
        ./nix/modules/apps.nix
      ];
    }
  );
}
