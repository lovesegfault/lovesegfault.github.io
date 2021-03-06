{
  description = "lovesegfault's CV";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      flake = false;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  };

  outputs = { self, flake-utils, gitignore, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        gitignoreSource = (import gitignore { inherit (pkgs) lib; }).gitignoreSource;
      in
      {
        defaultPackage = with pkgs; stdenv.mkDerivation {
          name = "lovesegfault.github.io";
          src = gitignoreSource ./.;

          nativeBuildInputs = [ hugo ];

          makeFlags = [ "PREFIX=${placeholder "out"}" ];
        };

        devShell = self.defaultPackage.${system}.overrideAttrs (oldAttrs: {
          buildInputs = with pkgs; (oldAttrs.buildInputs or [ ]) ++ [
            git-lfs
            hugo
            mdl
            proselint
          ];
        });
      });
}
