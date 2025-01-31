{ pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-23.05.tar.gz";
    sha256 = "05cbl1k193c9la9xhlz4y6y8ijpb2mkaqrab30zij6z4kqgclsrd";
  }) {}
}:

let
  darwinSpecific = pkgs.lib.optionals pkgs.stdenv.isDarwin (with pkgs.darwin; [
    apple_sdk.frameworks.Accelerate
    apple_sdk.frameworks.CoreFoundation
    apple_sdk.frameworks.CoreServices
    apple_sdk.frameworks.Foundation
    apple_sdk.frameworks.Metal
    apple_sdk.frameworks.MetalKit
    apple_sdk.frameworks.MetalPerformanceShaders
    apple_sdk.frameworks.Security
    cctools
    sigtool
  ]);

  linuxSpecific = pkgs.lib.optionals pkgs.stdenv.isLinux (with pkgs; [
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
    cudaPackages.cuda_runtime
  ]);

  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    huggingface-hub
  ]);

in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake
    curl
    just
    openssl
  ];

  buildInputs = with pkgs; [
    pythonEnv
    libiconv
  ] ++ darwinSpecific ++ linuxSpecific;

  shellHook = pkgs.lib.concatStrings [
    (pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
      export CPATH=${pkgs.darwin.apple_sdk.frameworks.Accelerate}/Library/Frameworks/Accelerate.framework/Headers
    '')
    (pkgs.lib.optionalString pkgs.stdenv.isLinux ''
      export CUDA_PATH=${pkgs.cudaPackages.cuda_cudart}
      export LD_LIBRARY_PATH=${pkgs.cudaPackages.cuda_cudart}/lib:$LD_LIBRARY_PATH
    '')
  ];
}
