final: prev:

{
  faith = {
    stable = {
      luajit = prev.faith.stable.luajit.overrideAttrs (_: { patches = [ ./patches/faith.patch ]; });
      lua5_1 = prev.faith.stable.lua5_1.overrideAttrs (_: { patches = [ ./patches/faith.patch ]; });
      lua5_2 = prev.faith.stable.lua5_2.overrideAttrs (_: { patches = [ ./patches/faith.patch ]; });
      lua5_3 = prev.faith.stable.lua5_3.overrideAttrs (_: { patches = [ ./patches/faith.patch ]; });
      lua5_4 = prev.faith.stable.lua5_4.overrideAttrs (_: { patches = [ ./patches/faith.patch ]; });
    };
    unstable = {
      luajit = prev.faith.unstable.luajit.overrideAttrs (_: { patches = [ ./patches/faith.patch ]; });
      lua5_1 = prev.faith.unstable.lua5_1.overrideAttrs (_: { patches = [ ./patches/faith.patch ]; });
      lua5_2 = prev.faith.unstable.lua5_2.overrideAttrs (_: { patches = [ ./patches/faith.patch ]; });
      lua5_3 = prev.faith.unstable.lua5_3.overrideAttrs (_: { patches = [ ./patches/faith.patch ]; });
      lua5_4 = prev.faith.unstable.lua5_4.overrideAttrs (_: { patches = [ ./patches/faith.patch ]; });
    };
  };

  fnlfmt = prev.fnlfmt.overrideAttrs (_: { patches = [ ./patches/fnlfmt.patch ]; });
}
