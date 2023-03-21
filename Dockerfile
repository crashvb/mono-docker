FROM crashvb/x11:202303201341@sha256:524df83a1510cd07681cf3afa5c915f7603719c39938f71be7255b9dde23c02a
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:524df83a1510cd07681cf3afa5c915f7603719c39938f71be7255b9dde23c02a" \
	org.opencontainers.image.base.name="crashvb/x11:202303201341" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing mono." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/mono-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/mono" \
	org.opencontainers.image.url="https://github.com/crashvb/mono-docker"

# Configure: (display)
ARG display_height=1200
ARG display_width=1920
ENV DISPLAY_GEOMETRY="${display_width}x${display_height}"

# Install packages, download files ...
# hadolint ignore=DL3009,DL4006
RUN docker-apt-install gnupg && \
	APT_SUITE=stable-focal apt-add-repo "mono" https://download.mono-project.com/repo/ubuntu main 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
	APT_SUITE=stable apt-add-repo "vscode" https://packages.microsoft.com/repos/code main BC528686B50D79E339D3721CEB3E94ADBE1229CF && \
	apt-get update && \
	docker-apt \
		code \
		dbus \
		dbus-x11 \
		mono-complete

# Configure: dbus
RUN install --directory --group=root --mode=0755 --owner=root /run/dbus && \
	rm --force /var/lib/dbus/machine-id

# Configure: mono
ENV MONO_DATA=/home/mono MONO_GID=1000 MONO_HOME=/home/mono MONO_UID=1000 X11_GNAME=mono X11_UNAME=mono
RUN groupadd --gid=${MONO_GID} ${X11_GNAME} && \
	useradd --create-home --gid=${MONO_GID} --groups=ssl-cert --home-dir=${MONO_HOME} --shell=/bin/bash --uid=${MONO_UID} ${X11_UNAME}

# Configure: supervisor
COPY *-wrapper /usr/local/bin/
COPY supervisord.dbus.conf /etc/supervisor/conf.d/38dbus.conf
COPY supervisord.vscode.conf /etc/supervisor/conf.d/40vscode.conf

# Configure: entrypoint
COPY entrypoint.mono /etc/entrypoint.d/mono

# Configure: healthcheck
COPY healthcheck.vscode /etc/healthcheck.d/vscode

VOLUME ${MONO_DATA}
