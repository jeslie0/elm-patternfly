{
  description = "A derivation and flake for building an elm package.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
    mkElmDerivation.url = github:jeslie0/mkElmDerivation;
  };

  outputs = { self, nixpkgs, mkElmDerivation, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        elmPackageName = "elm-patternfly";
        version = "0.1.0";
        pkgs = import nixpkgs {
          overlays = [ mkElmDerivation.overlays.mkElmDerivation ];
          inherit system;
        };

        elmPatternfly = pkgs.mkElmDerivation {
            pname = elmPackageName;
            version = version;
            src = ./.;
          };
        patternfly = pkgs.stdenvNoCC.mkDerivation rec {
          pname = "patternfly";
          version = "4.224.2";
          src = builtins.fetchTarball {
            url = "https://registry.npmjs.org/@patternfly/patternfly/-/patternfly-${version}.tgz";
            sha256 = "sha256:04v9kl36ala47vg9snq1bcmsg1d0dm5kq2dl9i85hmi6505qlxjb";
          };
          installPhase = "mkdir -p $out/patternfly-css; cp -r * $out/patternfly-css/";
        };
      in
        {
          packages.default = patternfly;

          devShell = pkgs.mkShell {
            inputsFrom = [ elmPatternfly ];
            packages = with pkgs;
              [ elmPackages.elm
                elmPackages.elm-format
                elmPackages.elm-language-server
                elmPackages.elm-live
              ];
          };
        }
    );
}
