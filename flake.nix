{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          default = promptarrow;

          promptarrow = pkgs.stdenv.mkDerivation rec {
            pname = "promptarrow";
            version = "0.0.0";

            src = ./.;

            installPhase = ''
              mkdir -p $out/bin
              install promptarrow.sh $out/bin/promptarrow
            '';
          };
        };
      }
    );
}
