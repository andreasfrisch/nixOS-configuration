default: help

.PHONY: setup-hardware-config
setup-hardware-config:  ## copy local hardware config
	cp /etc/nixos/hardware-configuration.nix .

.PHONY: setup-flakes
setup-flakes:  ## setup flakes in the current shell
	NIX_CONFIG="experimental-features = nix-command flakes" nix flake update

.PHONY: setup-home-manager
setup-home-manager:  ## install home-manager
	nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
	nix-channel --update
	nix-shell '<home-manager>' -A install

.PHONY: system
system:  ## build and apply system settings
	sudo nixos-rebuild switch --flake .#castitas

.PHONY: home
home:  ## reload home settings
	home-manager switch --flake .

.PHONY: nixos-size
nixos-size:  ## check top 20 size consuming entries
	du -sh /nix/store/* | sort -h | tail -n 20

.PHONY: garbage-collect
garbage-collect:  ## collect nixOS and home manager generations
	sudo nix-collect-garbage -d
	home-manager expire-generations '-3 days'

.PHONY: init
init: setup-hardware-config setup-flakes setup-home-manager system home  ## setup from scratch

.PHONY: help
help: ## Shows this list
	@grep -F -h "##" $(MAKEFILE_LIST) | sed -e 's/\(\:.*\#\#\)/\:\ /' | grep -F -v grep -F | sed -e 's/\\$$//' | sed -e 's/##//'
