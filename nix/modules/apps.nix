{ ... }:

{
  perSystem = { pkgs, self', ... }: {
    apps = {
      update-missing-hashes = {
        type = "app";
        program = pkgs.writeShellScriptBin "update-missing-hashes" ''
          ${pkgs.yarn-berry_4.yarn-berry-fetcher}/bin/yarn-berry-fetcher missing-hashes \
            ./yarn.lock > ./nix/drv/missing-hashes.json
        '';
      };
    };
  };
}
