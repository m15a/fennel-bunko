final: prev:

let
  inherit (prev.lib) optionalString;
in

{
  mkTestShell = { fennelVersion, luaVersion }: {
    name = "ci-test-${fennelVersion}-${luaVersion}";
    value = final.mkShell {
      buildInputs =
        let
          fennelSuffix =
            optionalString (fennelVersion != "stable")
              "-${fennelVersion}";
        in
        [
          final."fennel${fennelSuffix}-${luaVersion}"
          final.faith-unstable
        ];
      FENNEL_PATH = "${final.faith-unstable}/bin/?";
    };
  };

  faith = prev.faith.overrideAttrs (_: {
    patches = [ ./patches/faith.patch ];
  });

  faith-unstable = prev.faith-unstable.overrideAttrs (_: {
    patches = [ ./patches/faith.patch ];
  });

  fnlfmt = prev.fnlfmt.overrideAttrs (_: {
    patches = [ ./patches/fnlfmt.patch ];
  });

  fnlfmt-unstable = prev.fnlfmt-unstable.overrideAttrs (_: {
    patches = [ ./patches/fnlfmt.patch ];
  });

  fenneldoc = prev.fenneldoc.overrideAttrs (_: {
    patches = [ ./patches/fenneldoc.patch ];
  });
}
