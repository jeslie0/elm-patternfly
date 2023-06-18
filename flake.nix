{
  description = "A flake to build patternfly-elm examples and provide a development shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    mkElmDerivation.url = "github:jeslie0/mkElmDerivation";
  };

  outputs = { self, nixpkgs, mkElmDerivation, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          overlays = [ mkElmDerivation.overlays.mkElmDerivation ];
          inherit system;
        };

        patternfly = pkgs.stdenvNoCC.mkDerivation rec {
          pname = "patternfly";
          version = "4.224.2";
          src = builtins.fetchTarball {
            url = "https://registry.npmjs.org/@patternfly/patternfly/-/patternfly-${version}.tgz";
            sha256 = "sha256:04v9kl36ala47vg9snq1bcmsg1d0dm5kq2dl9i85hmi6505qlxjb";
          };
          installPhase = "mkdir -p $out; mv * $out";
        };

        makeExample = dirname:
          let js = pkgs.mkElmDerivation {
                name = "${dirname}JS";
                src = ./.;
                targets = [ "examples/src/${dirname}/Main.elm"];
                outputJavaScript = true;
                optimizationLevel = 2;
                postInstall = "mv $out/Main.min.js $out/main.min.js";
              };

          in
            pkgs.stdenvNoCC.mkDerivation {
              name = "${dirname}Example";
              src = ./.;
              buildPhase = "mkdir -p $out/patternfly-css";
              installPhase = ''
                       cp examples/src/${dirname}/index.html $out/index.html
                       cp -r ${patternfly}/* $out/patternfly-css
                       cp ${js}/main.min.js $out
                       '';
            };

        packages = with builtins;
          let examplesContents = readDir ./examples/src;
              exampleDirectories = filter (name: examplesContents.${name} == "directory") (attrNames examplesContents);
          in
            listToAttrs (map (dirName: { name = dirName; value= makeExample dirName; }) exampleDirectories);
      in

        {
          packages = packages;

          devShell = pkgs.mkShell {
            packages = with pkgs.elmPackages;
              [ elm
                elm-format
                elm-live
                elm-language-server
                elm-doc-preview
              ];
          };
        }
    );
}
