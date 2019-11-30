FROM archlinux/base

# install stuff
RUN pacman -Sy --noconfirm archlinux-keyring base-devel namcap \
		pacman-contrib git neovim && \
	pacman -Syu --noconfirm

# makepkg cannot (and should not) be run as root
RUN useradd -m notroot

# allow notroot to run stuff as root
RUN echo "notroot ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/notroot

# continue as notroot
USER notroot
WORKDIR /home/notroot

# auto-fetch GPG keys (for checking signatures)
RUN mkdir .gnupg && \
	touch .gnupg/gpg.conf && \
	echo "keyserver-options auto-key-retrieve" >.gnupg/gpg.conf

# install yay (for building AUR dependencies)
RUN git clone https://aur.archlinux.org/yay-bin.git
WORKDIR /home/notroot/yay-bin
RUN makepkg --noconfirm --syncdeps --rmdeps --install --clean
WORKDIR /home/notroot
RUN rm -rf yay-bin
