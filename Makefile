default: help

.PHONY: install-home-manager
install-home-manager:  ## install home-manager
	nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
	nix-channel --update
	nix-shell '<home-manager>' -A install

.PHONY: system
system:  ## reload system settings
	sudo nixos-rebuild switch --flake .

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

.PHONY: help
help: ## Shows this list
	@grep -F -h "##" $(MAKEFILE_LIST) | sed -e 's/\(\:.*\#\#\)/\:\ /' | grep -F -v grep -F | sed -e 's/\\$$//' | sed -e 's/##//'
