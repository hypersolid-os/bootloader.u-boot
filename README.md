Container isolated U-Boot build enviromment for raspberry pi (and others)
=============================================================

build your customized [u-boot](https://www.denx.de/wiki/U-Boot) raspberry pi bootloader

Features
--------------------------------------

* Targeted to 64bit Rapsberry PI 3/4
* Build environment isolated within container
* `.config` overrides via `merge_config.sh`
* Easy to customize
* Ready to go

Requirements
--------------------------------------

* Debian/Ubuntu hostsystem
* podman with non-root config
* uid/gid remapping enabled

Step 1 - Build container image
--------------------------------------

```bash
./build.sh
```

Step 2 - Configuration
--------------------------------------

### Device/Archicture selection ###



### Image configuration ###

To alter a set of build config variables, just place them within `conf/config` - the values are merged with the default board profile.

Step 3 - Build u-boot binary (64bit only)
--------------------------------------

The `uboot-build` script triggers the build process

```bash
build@32e99ec1ab77:~/uboot$ uboot-build 
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  YACC    scripts/kconfig/zconf.tab.c
  LEX     scripts/kconfig/zconf.lex.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
#
# configuration written to .config
#
scripts/kconfig/conf  --syncconfig Kconfig
  UPD     include/config.h
  CFG     u-boot.cfg
  GEN     include/autoconf.mk.dep
...
  DTC     arch/arm/dts/bcm2711-rpi-4-b.dtb
  COPY    u-boot.bin
  SHIPPED dts/dt.dtb
```

Finally, `u-boot.bin` is copied into the bind mount to `u-boot.bin`


Step 4 - Raspberry PI Boot
--------------------------------------

Following file from the [raspberry firmware package](https://github.com/raspberrypi/firmware) are required:

* `bootcode.bin` (raspberry v1 v2 v3)
* `start*.elf` (all)
* `fixup*.dat` (all)
* `bcm*.dtb` (all)

And additionally the `u-boot.bin` bootloader

### Boot config ###

File `config.txt`

```
disable_splash=1

boot_delay=0
gpu_mem=16

enable_uart=1
kernel=u-boot.bin
arm_64bit=1
```

### SD Card setup ###

* MBR (DOS) partition table
* FAT32 boot partition (first partition) with boot flag set
* Size min `50MB`

References
--------------------------------------

* https://elinux.org/RPi_U-Boot
* https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#boot-sequence

License
----------------------------

**hypersolid** is OpenSource and licensed under the Terms of [GNU General Public Licence v2](LICENSE.txt). You're welcome to [contribute](CONTRIBUTE.md)!