{ inputs }:

final: prev:

let
  fennelWith = { lua }:
  final.stdenv.mkDerivation rec {
    pname = "fennel";
    version = "1.4.1-dev";
    src = inputs.fennel;
    nativeBuildInputs = [
      lua
      final.pandoc
    ];
    postPatch = ''
      # FIXME: maninst function and run ./fennel do not work.
      sed -i Makefile \
          -e 's|$(call maninst,$(doc),$(DESTDIR)$(MAN_DIR)/$(doc))|$(shell mkdir -p $(dir $(DESTDIR)$(MAN_DIR)$(doc)) && cp $(doc) $(DESTDIR)$(MAN_DIR)/$(doc))|' \
          -e 's|\./fennel|lua fennel|'
    '';
    makeFlags = [
      "PREFIX=$(out)"
    ];
    postBuild = ''
      patchShebangs .
    '';
  };

  faithWith = { fennel }:
  final.stdenv.mkDerivation {
    pname = "faith";
    version = "0.1.3-dev";
    src = inputs.faith;
    nativeBuildInputs = [
      fennel
    ];
    buildPhase = ''
      mkdir bin
      {
          echo '#!/usr/bin/env fennel'
          cat faith.fnl
      } > bin/faith
      chmod +x bin/faith
      patchShebangs .
    '';
    installPhase = ''
      mkdir -p $out/bin
      install -m755 bin/faith -t $out/bin/
    '';
  };
in

rec {
  fennel = fennel-lua5_3;

  fennel-luajit = fennelWith { lua = final.luajit; };
  fennel-lua5_1 = fennelWith { lua = final.lua5_1; };
  fennel-lua5_2 = fennelWith { lua = final.lua5_2; };
  fennel-lua5_3 = fennelWith { lua = final.lua5_3; };
  # NOTE: currently broken
  # fennel-lua5_4 = fennelWith { lua = final.lua5_4 };

  faith = faith-lua5_3;

  faith-luajit = faithWith { fennel = final.fennel-luajit; };
  faith-lua5_1 = faithWith { fennel = final.fennel-lua5_1; };
  faith-lua5_2 = faithWith { fennel = final.fennel-lua5_2; };
  faith-lua5_3 = faithWith { fennel = final.fennel-lua5_3; };
  # NOTE: currently broken
  # faith-lua5_4 = faithWith { fennel = final.fennel_lua5_4 };

  fnlfmt = final.stdenv.mkDerivation {
    pname = "fnlfmt";
    version = "0.3.2-dev";
    src = inputs.fnlfmt;
    nativeBuildInputs = [
      final.luajit
      final.luajit.pkgs.fennel
    ];
    patches = [
      ./patches/fnlfmt.patch
    ];
    postPatch = ''
      sed -i Makefile -e 's|./fennel|lua fennel|'
    '';
    makeFlags = [ "PREFIX=$(out)" ];
    postBuild = ''
      patchShebangs .
    '';
  };

  fenneldoc = final.stdenv.mkDerivation rec {
    pname = "fenneldoc";
    version = "1.0.1-dev";
    src = inputs.fenneldoc;
    nativeBuildInputs = [
      final.luajit
      final.luajit.pkgs.fennel
    ];
    postPatch = ''
      sed -i Makefile -e 's|\./fenneldoc|lua fenneldoc|'
    '';
    makeFlags = [
      "VERSION=${version}"
      "PREFIX=$(out)"
    ];
    postBuild = ''
      patchShebangs .
    '';
  };
}
