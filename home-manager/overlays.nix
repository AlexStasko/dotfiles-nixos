self: super:

let
  sources = import ../nix/sources.nix;
  tabninePlatform = if (builtins.hasAttr super.stdenv.hostPlatform.system
    tabnineSupportedPlatforms) then
    builtins.getAttr (super.stdenv.hostPlatform.system)
    tabnineSupportedPlatforms
  else
    throw "Not supported on ${super.stdenv.hostPlatform.system}";
  tabnineSupportedPlatforms = {
    "x86_64-darwin" = {
      name = "x86_64-apple-darwin";
      sha256 = "sha256-NY6+KMqpjHYeWiYQ5RtDDZm0uh3zByzsLN4l0VTisyA=";
    };
    "x86_64-linux" = {
      name = "x86_64-unknown-linux-musl";
      sha256 = "sha256-eN3uW3y/jETyK+sHpvJ+PR1bfcYBEYWhy0WGGa9z57I=";
    };
  };
  tabnineVersion = "4.4.118";
in {
  customTmux = with self; {
    catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
      pluginName = "catppuccin";
      src = sources."catppuccin-tmux";
      version = "unstable-2022-09-14";
    };
  };
  customVim = with self; {
    cmp-tabnine = pkgs.vimPlugins.cmp-tabnine.overrideAttrs (oldAttrs: {
      buildInputs = [ customVim.tabnine ];
      postFixup = ''
        mkdir -p $target/binaries/${customVim.tabnine.version}
        ln -s ${customVim.tabnine}/bin/ $target/binaries/${customVim.tabnine.version}/${customVim.tabnine.passthru.platform}
      '';
      src = sources."cmp-tabnine";
    });

    earthly-vim = pkgs.vimUtils.buildVimPlugin {
      name = "earthly-vim";
      src = sources."earthly.vim";
    };

    gitsigns-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "gitsigns.nvim";
      src = sources."gitsigns.nvim";
    };

    lsp_lines-nvim = pkgs.vimUtils.buildVimPlugin {
      name = "lsp_lines-nvim";
      src = sources."lsp_lines.nvim";
    };

    tabnine = pkgs.tabnine.overrideAttrs (oldAttrs: {
      src = fetchurl {
        inherit (tabninePlatform) sha256;
        url =
          "https://update.tabnine.com/bundles/${tabnineVersion}/${tabninePlatform.name}/TabNine.zip";
      };
      version = tabnineVersion;
    });

    astasko = pkgs.vimUtils.buildVimPlugin {
      name = "astasko";
      src = ./config/nvim;
    };

    vim-just = pkgs.vimUtils.buildVimPlugin {
      name = "vim-just";
      src = sources."vim-just";
    };
  };
}
