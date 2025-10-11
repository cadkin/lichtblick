{ self, ... }:

{
  perSystem = { pkgs, self', ... }: let
    callPackageArgs = {
      src = self;
      version = self.lichtblick.version;
    };

    desktop = pkgs.callPackage ../drv/desktop.nix callPackageArgs;
    web = pkgs.callPackage ../drv/web.nix callPackageArgs;
  in {
    packages = {
      default = desktop;

      lichtblick-desktop = desktop;
      lichtblick-web = web;
    };

    legacyPackages = {
      lichtblick = {
        desktop = desktop;
        web = web;
      };
    };
  };
}
