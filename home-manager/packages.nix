{ pkgs, ... }:

with pkgs; [
  # programs
  awscli2
  doppler
  fd
  gcc
  jq
  just
  k9s
  kubectl
  lazydocker
  niv
  nodejs-18_x
  pulumi-bin
  python3Full
  ripgrep
  rustc
  rustfmt
  terraform
  virtualenv
  teams

  # language servers
  gopls
  nil
  nodePackages."@prisma/language-server"
  nodePackages."bash-language-server"
  nodePackages."dockerfile-language-server-nodejs"
  nodePackages."graphql-language-service-cli"
  nodePackages."pyright"
  nodePackages."typescript"
  nodePackages."typescript-language-server"
  nodePackages."vscode-langservers-extracted"
  nodePackages."yaml-language-server"
  rust-analyzer
  sumneko-lua-language-server
  terraform-ls
]
