{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.playwright-browsers.url = "github:rencire/nix-playwright-browsers/v1.45.0";

  outputs = { self, nixpkgs, flake-utils, playwright-browsers }:
    flake-utils.lib.eachDefaultSystem (system:
    let
        pkgs = import nixpkgs {
          inherit system;
        };
        browsers = playwright-browsers.packages.${system}.default;
    in 
    with pkgs; {
      devShells = {
        default = mkShell {
          packages = [ 
            nodejs_20
            # xvfb
            # xorg.xvfb
            # x11vnc
            # tini
            # novnc
            # # websockify
            # dos2unix
            # # python3-pip
            # gtk3
            # alsa-lib
            # xorg.libXcomposite
            # pango
            # cairo
            # # TODO add rest of libraries
          ];
          # Use 1466 firefox browser version in `playwright-driver.brwosers` from nixpkgs
          # Need to make sure npm package `playwright-firefox` is also using 1466 firefox browser.
          shellHook = ''
            export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
            export PLAYWRIGHT_BROWSERS_PATH="${browsers}"
          '';
        };
      };
    });
}
