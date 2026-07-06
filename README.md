# php

PHP is a server-side scripting language designed for web development, but which can also be used as a general-purpose programming language. PHP can be added to straight HTML or it can be used with a variety of templating engines and web frameworks. PHP code is usually processed by an interpreter, which is either implemented as a native module on the web-server or as a common gateway interface (CGI).

wikipedia.org/wiki/PHP

<img src="https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/php/logo.png" width="30%" height="auto" alt="php logo">

## How to use this Makejail

### Create a `Containerfile` in your PHP project

```dockerfile
FROM ghcr.io/appjail-makejails/php:15.1-85
COPY . /myapp
WORKDIR /myapp
CMD ["php", "./your-script.php"]
```

Then, run the commands to build and run the OCI image:

```console
$ buildah build --network=host -t my-php-app .
$ appjail oci run \
    -o overwrite=force \
    -o ephemeral \
    -o alias \
    -o ip4_inherit \
    localhost/my-php-app my-php-app
```

### Run a single PHP script

For many simple, single file projects, you may find it inconvenient to write a complete `Containerfile`. In such cases, you can run a PHP script by using the PHP OCI image directly:

```console
$ appjail oci run \
    -o overwrite=force \
    -o ephemeral \
    -o alias \
    -o ip4_inherit \
    -o fstab="$PWD /myapp" \
    -w /myapp \
    ghcr.io/appjail-makejails/php:15.1-85 my-php-app \
    php your-script.php
```

### Running as an arbitrary user

For running this OCI image as an arbitrary user, `-u` flag to `appjail oci run` should be used (which can accept both a username/group in the container's `/etc/passwd` file like `-u www` or a specific UID/GID like `-u 80:80`).

### Arguments (stage: build)

* `php_from` (default: `ghcr.io/appjail-makejails/php`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `php_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.
### Environment (stage: build)

* `PHP_USE_FPM` (optional): When set, php-fpm runs instead of the PHP CLI, with `/usr/local/www` as the working directory.


## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1-82
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        PHPVER: "82"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-83
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        PHPVER: "83"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-84
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        PHPVER: "84"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-85
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        PHPVER: "85"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```

## Notes

1. This image installs `php.ini-production` as `php.ini`. You can always override or customize these settings.
