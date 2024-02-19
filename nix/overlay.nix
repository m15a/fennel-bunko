final: prev:

let
  fennelVersions = [
    "stable"
    "unstable"
  ];

  luaVersions = [
    "luajit"
    "lua5_1"
    "lua5_2"
    "lua5_3"
    "lua5_4"
  ];

  fennelLuaVersionMatrix = prev.lib.cartesianProductOfSets {
    fennelVersion = fennelVersions;
    luaVersion = luaVersions;
  };

  buildFaith = { fennelVersion, luaVersion }:
    prev."faith-${fennelVersion}-${luaVersion}".overrideAttrs (_: {
      patches = [ ./patches/faith.patch ];
    });

  buildPackageSet = { pname, builder }:
    builtins.listToAttrs
      (map
        ({ fennelVersion, luaVersion } @ args:
          {
            name = "${pname}-${fennelVersion}-${luaVersion}";
            value = builder args;
          })
        fennelLuaVersionMatrix);
in

(buildPackageSet {
  pname = "faith";
  builder = buildFaith;
}) // {
  fnlfmt = prev.fnlfmt.overrideAttrs (_: {
    patches = [ ./patches/fnlfmt.patch ];
  });
}
