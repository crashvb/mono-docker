# mono

[![version)](https://img.shields.io/docker/v/crashvb/mono/latest)](https://hub.docker.com/repository/docker/crashvb/mono)
[![image size](https://img.shields.io/docker/image-size/crashvb/mono/latest)](https://hub.docker.com/repository/docker/crashvb/mono)
[![linting](https://img.shields.io/badge/linting-hadolint-yellow)](https://github.com/hadolint/hadolint)
[![license](https://img.shields.io/github/license/crashvb/mono-docker.svg)](https://github.com/crashvb/mono-docker/blob/master/LICENSE.md)

## Overview

This docker image contains:

* [dbus](https://dbus.freedesktop.org/)
* [mono](https://mono-project.com/)
* [vscode](https://code.visualstudio.com/)

## Entrypoint Scripts

### mono

The embedded entrypoint script is located at `/etc/entrypoint.d/mono` and performs the following actions:

1. A new mono configuration is generated using the following environment variables:

 | Variable | Default Value | Description |
 | -------- | ------------- | ----------- |

2. Volume permissions are normalized.

## Standard Configuration

### Container Layout

```
/
├─ etc/
│  ├─ entrypoint.d/
│  │  └─ mono
│  ├─ healthcheck.d/
│  │  └─ vscode
│  └─ supervisor/
│     └─ config.d/
│        ├─ 38dbus.conf
│        └─ 40vscode.conf
└─ home/
   └─ mono/
```

### Exposed Ports

None.

### Volumes

* `/home/mono` - mono configuration directory.

## Development

[Source Control](https://github.com/crashvb/mono-docker)

