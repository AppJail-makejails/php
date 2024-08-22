# php

PHP, which stands for "PHP: Hypertext Preprocessor" is a widely-used Open Source general-purpose scripting language that is especially suited for Web development and can be embedded into HTML.  Its syntax draws upon C, Java, and Perl, and is easy to learn.  The main goal of the language is to allow web developers to write dynamically generated webpages quickly, but you can do much more with PHP.

wikipedia.org/wiki/PHP

![php logo](https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/PHP-logo.svg/121px-PHP-logo.svg.png)

## How to use this Makejail

Create a `Makejail` in your PHP project.

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/php

WORKDIR /app
COPY app/

STAGE cmd

WORKDIR /app
ENTRYPOINT php
RUN main.php
```

Where `options/network.makejail` are the options that suit your environment, for example:

```
ARG network?
ARG interface=php

OPTION virtualnet=${network}:${interface} default
OPTION nat
```

Open a shell and run `appjail makejail`:

```sh
# Install the latest PHP version.
appjail makejail -j php

# Install 8.1:
appjail makejail -j php -- --php_tag 13.3-81

# Enable php-fpm:
appjail makejail -j php -- --php_use_fpm 1
```

### Arguments

* `php_tag` (default: `13.3-84`): see [#tags](#tags).
* `php_type` (default: `production`): The PHP configuration file to link to `/usr/local/etc/php.ini`. Valid values: `development`, `production`.
* `php_use_fpm` (default: `0`): If different than `0`, enable and run php-fpm.

## Tags

| Tag       | Arch    | Version        | Type   | `php_version` |
| --------- | ------- | -------------- | ------ | ------------- |
| `13.3-84` | `amd64` | `13.3-RELEASE` | `thin` |      `84`     |
| `13.3-83` | `amd64` | `13.3-RELEASE` | `thin` |      `83`     |
| `13.3-82` | `amd64` | `13.3-RELEASE` | `thin` |      `82`     |
| `13.3-81` | `amd64` | `13.3-RELEASE` | `thin` |      `81`     |
| `14.1-84` | `amd64` | `14.1-RELEASE` | `thin` |      `84`     |
| `14.1-83` | `amd64` | `14.1-RELEASE` | `thin` |      `83`     |
| `14.1-82` | `amd64` | `14.1-RELEASE` | `thin` |      `82`     |
| `14.1-81` | `amd64` | `14.1-RELEASE` | `thin` |      `81`     |

## Notes

1. `/usr/local/etc/php-fpm.d/www.conf`:`listen` is set to `0.0.0.0:9000`.
