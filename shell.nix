{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, ghc-prim, primitive, stdenv, vector, llvm, random, criterion, MonadRandom}:
      mkDerivation {
        pname = "simd";
        version = "0.1.0.999";
        src = ./.;
        pkgconfigDepends = [ llvm ];
        libraryHaskellDepends = [ base ghc-prim primitive vector random criterion MonadRandom];
        homepage = "http://github.com/mikeizbicki/simd";
        description = "simple interface to GHC's SIMD instructions";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f { llvm = pkgs.llvm_35; };

in

  if pkgs.lib.inNixShell then drv.env else drv
