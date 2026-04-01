{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    v-flakes.url = "github:valeratrades/v_flakes";
  };
  outputs = { self, nixpkgs, flake-utils, v-flakes }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
        };

        github = v-flakes.github {
          inherit pkgs;
          pname = "llm.c";
          syncFork = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          shellHook = github.shellHook;

          packages = with pkgs; [
            gcc
            gnumake
            cudaPackages.cudatoolkit
            cudaPackages.cuda_nvcc
            cudaPackages.libcublas
            cudaPackages.cudnn
            cudaPackages.nccl
          ] ++ github.enabledPackages;

          env.CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
        };
      }
    );
}
