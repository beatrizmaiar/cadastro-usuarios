{ pkgs }: {
  deps = [
    pkgs.rubyPackages_3_2.railties
    pkgs.rubyPackages.railties
    pkgs.sqlite
  ];
}