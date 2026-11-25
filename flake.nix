{
  description = "Outpatient scheduling API - DevOps assessment env";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      # terraform is BSL-licensed (unfree in nixpkgs)
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [ python3 terraform kubectl kind curl ];
      };
    };
}
