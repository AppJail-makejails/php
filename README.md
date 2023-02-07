# php

PHP, which stands for "PHP: Hypertext Preprocessor" is a widely-used Open Source general-purpose scripting language that is especially suited for Web development and can be embedded into HTML.  Its syntax draws upon C, Java, and Perl, and is easy to learn.  The main goal of the language is to allow web developers to write dynamically generated webpages quickly, but you can do much more with PHP.

wikipedia.org/wiki/PHP

![php logo](https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/PHP-logo.svg/121px-PHP-logo.svg.png)

## How to use this Makejail

### Basic usage

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
ARG network
ARG interface=php

OPTION virtualnet=${network}:${interface}
OPTION nat
```

Open a shell and run `appjail makejail`:

```
appjail makejail -j php -- --network development

# Install 8.1:
appjail makejail -j php -- --network development --php_version 81

# Disable php-fpm:
appjail makejail -j php -- --network development --php_use_fpm 0
```

### PHP Extensions

Since `php_version` argument is defined, you can use it to install an extension of that PHP version.

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/php

PKG php${php_version}-extensions
```

### Arguments

* `php_version` (default: `81`): PHP version. Valid values: `80`, `81`, `82`.
* `php_type` (default: `production`): The PHP configuration file to link to `/usr/local/etc/php.ini`. Valid values: `development`, `production`.
* `php_use_fpm` (default: `1`): If different than `0`, enable and run php-fpm.
