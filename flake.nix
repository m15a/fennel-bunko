{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fennel = {
      url = "sourcehut:~technomancy/fennel/main";
      flake = false;
    };
    fenneldoc = {
      url = "gitlab:andreyorst/fenneldoc/master";
      flake = false;
    };
    fnlfmt = {
      url = "sourcehut:~technomancy/fnlfmt/main";
      flake = false;
    };
    faith = {
      url = "sourcehut:~technomancy/faith/main";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
  let
    overlay = import ./nix/overlay.nix { inherit inputs; };
  in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
        mkCIShell = { fennel, faith }:
        pkgs.mkShell {
          buildInputs = [ fennel faith ];
          FENNEL_PATH = "${faith}/bin/?";
        };
      in
      {
        devShells = rec {
          ci-luajit = mkCIShell {
            fennel = pkgs.fennel-luajit;
            faith = pkgs.faith-luajit;
          };
          ci-lua5_1 = mkCIShell {
            fennel = pkgs.fennel-lua5_1;
            faith = pkgs.faith-lua5_1;
          };
          ci-lua5_2 = mkCIShell {
            fennel = pkgs.fennel-lua5_2;
            faith = pkgs.faith-lua5_2;
          };
          ci-lua5_3 = mkCIShell {
            fennel = pkgs.fennel-lua5_3;
            faith = pkgs.faith-lua5_3;
          };
          # NOTE: currently broken
          # ci-lua5_4 = mkCIShell {
          #   fennel = pkgs.fennel-lua5_4;
          #   faith = pkgs.faith-lua5_4;
          # };

          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              fennel
              faith
              fnlfmt
              fenneldoc
            ] ++ (with lua5_3.pkgs; [
              readline
            ]);
            FENNEL_PATH = "${pkgs.faith}/bin/?";
          };
        };
      });
}
