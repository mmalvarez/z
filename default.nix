with import <nixpkgs> { };

let generator = pkgs.stdenv.mkDerivation {
  name = "utdemircom-generator";
  src = ./generator;
  phases = "unpackPhase buildPhase";
  buildInputs = [
    (pkgs.haskellPackages.ghcWithPackages (p: with p; [ hakyll ]))
  ];
  buildPhase = ''
    mkdir -p $out/bin
    ghc -O2 -dynamic --make site.hs -o $out/bin/generate-site
  '';
};

site = pkgs.stdenv.mkDerivation {
  name = "utdemircom-site";
  src = ./site;
  phases = "unpackPhase buildPhase";
  buildInputs = [ generator ];
  buildPhase = ''
    export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive";
    export LANG=en_US.UTF-8
    generate-site build

    mkdir $out
    cp -r _site/* $out
  '';
};
in site
