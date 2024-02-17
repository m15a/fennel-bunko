{ inputs }:

final: prev: {
  fennel = final.stdenv.mkDerivation rec {
    pname = "fennel";
    version = "1.4.1-dev";
    src = inputs.fennel;
    nativeBuildInputs = [
      final.lua5_3
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
  };
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
  };
  faith = final.stdenv.mkDerivation {
    pname = "faith";
    version = "0.1.3-dev";
    src = inputs.faith;
    nativeBuildInputs = [
      final.luajit.pkgs.fennel
    ];
    buildPhase = ''
      mkdir bin
      {
          echo '#!/usr/bin/env fennel'
          cat faith.fnl
      } >> bin/faith
      chmod +x bin/faith
      patchShebangs .
    '';
    installPhase = ''
      mkdir -p $out/bin
      install -m755 bin/faith -t $out/bin/
    '';
  };
}
