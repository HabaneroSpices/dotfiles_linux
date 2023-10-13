.POSIX:

export DOTFILES_DIR ?= ${HOME}/.dotfiles

default: system nvim zsh-fancy user

system:
	./scripts/setup-system.sh

nvim:
	./scripts/setup-nvim.sh

user:
	./scripts/setup-user.sh

zsh-fancy:
	./scripts/setup-p10k.sh

sync:
	git fetch
	git pull
	git add -u
	git commit -m "Sync"
	git push
