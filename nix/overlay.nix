{ inputs }:

final: prev:

let
  fennelWith = { lua }:
  final.callPackage ./pkgs/fennel {
    src = inputs.fennel;
    inherit lua;
  };

  faithWith = { fennel }:
  final.callPackage ./pkgs/faith {
    src = inputs.faith;
    inherit fennel;
  };
in

{
  fennel = rec {
    default = lua5_3;
    luajit = fennelWith { lua = final.luajit; };
    lua5_1 = fennelWith { lua = final.lua5_1; };
    lua5_2 = fennelWith { lua = final.lua5_2; };
    lua5_3 = fennelWith { lua = final.lua5_3; };
    lua5_4 = fennelWith { lua = final.lua5_4; };
  };

  faith = rec {
    default = lua5_3;
    luajit = faithWith { fennel = final.fennel.luajit; };
    lua5_1 = faithWith { fennel = final.fennel.lua5_1; };
    lua5_2 = faithWith { fennel = final.fennel.lua5_2; };
    lua5_3 = faithWith { fennel = final.fennel.lua5_3; };
    lua5_4 = faithWith { fennel = final.fennel.lua5_4; };
  };

  fnlfmt = final.callPackage ./pkgs/fnlfmt {
    src = inputs.fnlfmt;
    lua = final.luajit;
  };

  fenneldoc = final.callPackage ./pkgs/fenneldoc {
    src = inputs.fenneldoc;
    lua = final.luajit;
  };
}
