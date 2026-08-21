default: help

.PHONY: setup-hardware-config
setup-hardware-config:  ## copy local hardware config into host folder
	cp /etc/nixos/hardware-configuration.nix hosts/castitas/hardware-configuration.nix

.PHONY: setup-flakes
setup-flakes:  ## setup flakes in the current shell
	NIX_CONFIG="experimental-features = nix-command flakes" nix flake update

.PHONY: setup-home-manager
setup-home-manager:  ## install home-manager
	nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz home-manager
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

HOST ?= castitas

.PHONY: install
install:  ## install NixOS on a new machine (usage: make install TARGET=root@<ip> HOST=castitas)
	@[[ -n "$(TARGET)" ]] || { echo "ERROR: TARGET is required. Usage: make install TARGET=root@<ip>"; exit 1; }
	@bash ./scripts/install.sh --host $(HOST) --target $(TARGET)

.PHONY: secrets-init
secrets-init:  ## generate a personal age key and install it (run once on a new machine)
	@if [ -f /etc/sops/age/keys.txt ]; then \
		echo "Age key already exists at /etc/sops/age/keys.txt — skipping."; \
		echo "Public key:"; \
		grep 'public key' /etc/sops/age/keys.txt; \
	else \
		sudo mkdir -p /etc/sops/age && sudo chmod 700 /etc/sops/age; \
		TMPKEY=$$(mktemp); \
		age-keygen -o $$TMPKEY; \
		sudo cp $$TMPKEY /etc/sops/age/keys.txt; \
		sudo chmod 600 /etc/sops/age/keys.txt; \
		cat $$TMPKEY; \
		rm $$TMPKEY; \
		echo ""; \
		echo "==> Key installed at /etc/sops/age/keys.txt"; \
		echo "==> IMPORTANT: Save the AGE-SECRET-KEY line to 1Password now!"; \
		echo "==> Then put the public key (age1...) into .sops.yaml"; \
	fi

.PHONY: secrets-install-key
secrets-install-key:  ## install an existing age key onto this machine (paste from 1Password)
	@sudo mkdir -p /etc/sops/age && sudo chmod 700 /etc/sops/age
	@echo "Paste your AGE-SECRET-KEY line (from 1Password), then press Enter and Ctrl+D:"
	@TMPKEY=$$(mktemp); cat > $$TMPKEY; sudo cp $$TMPKEY /etc/sops/age/keys.txt; rm $$TMPKEY
	@sudo chmod 600 /etc/sops/age/keys.txt
	@echo "Key installed at /etc/sops/age/keys.txt"

.PHONY: secrets-encrypt
secrets-encrypt:  ## encrypt the secrets file (run after editing secrets/castitas.yaml in plain text)
	sops --encrypt --in-place secrets/castitas.yaml

.PHONY: secrets-edit
secrets-edit:  ## decrypt, open in $$EDITOR, re-encrypt on save
	sops secrets/castitas.yaml

.PHONY: password-update
password-update:  ## hash a new password and update the encrypted secrets file
	@echo "Enter your new password when prompted:"
	@HASH=$$(mkpasswd -m sha-512); \
	sops --set '["user"]["hashedPassword"] "'"$$HASH"'"' secrets/castitas.yaml; \
	echo "Password updated in secrets/castitas.yaml"
