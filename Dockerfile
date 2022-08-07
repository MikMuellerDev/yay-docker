FROM archlinux:latest

LABEL author="MikMuellerDev"

# Install required software
RUN pacman -Syu --noconfirm \
    && pacman -S --needed base-devel git go --noconfirm

# Create a `build` user
RUN useradd -m --shell=/bin/false build && usermod -L build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Create temp location for the Yay installation
RUN mkdir -p /tmp/build \
    && chown -R build /tmp/build

# Change user and working directory in prepararion for the build
USER build
WORKDIR /tmp/build

# Install Yay
RUN git clone https://aur.archlinux.org/yay.git \
    && cd yay \
    && makepkg -si --noconfirm

# Switch back to the `root` user
USER root
WORKDIR /root

# Remove the `build` user
RUN userdel build

# Create a `yay` user
RUN useradd -m --shell=/bin/false yay && usermod -L yay
RUN echo "yay ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Use the `yay` user
USER yay
ENTRYPOINT ["yay"]
