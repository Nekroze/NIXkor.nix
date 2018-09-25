# NIXkor

An attempt at replacing [dotfiles][1] with as much pure [NixOS][2] as possible.

## Usage

This git repository is designed to be imported in the [Nix][3] language and called as a function to generate your variant of the [NixOS][2] configuration.

### Example Using Default Values

```nix
{ pkgs, ... }:
let
  NIXkor = pkgs.fetchFromGitHub {
    owner = "Nekroze";
	repo = "NIXkor.nix";
	# use whatever is the latest commit hash
	rev = "7f7bdfc1c2131fe55094ff288069d5936d28c895";
	# update this hash when builds fail when updating rev.
    sha256 = "0jp7qq02ly9wiqbgh5yamwd31ah1bbybida7mn1g6qpdijajf247";
  };
in {
  imports = [
    ./hardware-configuration.nix
	(NIXkor {})
  ];
}
```
