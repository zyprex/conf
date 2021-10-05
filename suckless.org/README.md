# Usage for 'dwm.config.h'

## Start from scratch

1. Clone the Dwm source files
```shell
git clone https://git.suckless.org/dwm
```

## Update

2. Update Dwn

Remove any patch

```shell
git apply -R /path/of/dwm_conf/patches/*
rm config.h
```

3. Git pull Dwn

## Recover Dwm configurations

4. Recover all patches

```shell
git apply /path/of/dwm_conf/patches/*
```

## Modified Your 'config.h'

5. Recover 'config.h'
6. Edit your 'config.h'
8. Backup the 'config.h' file

## The 'dwm\_bar.sh'

Dwm statusabar show:
1. wifi connect state
2. time and date
3. battery

# Add Dwm to the display manager's session select menu

```shell
echo -e \
"[Desktop Entry]\n\
Encoding=UTF-8\n\
Name=dwm\n\
Comment=dwm window manager\n\
Exec=/usr/local/bin/dwm\n\
Type=Application\n" > /usr/share/xsessions/dwm.desktop
```

# Patches

[https://dwm.suckless.org/patches/](https://dwm.suckless.org/patches/)

## Use a Patch
```
$ git diff > my_custom_patch_file.diff
$ git apply patch_file.diff
$ git apply patch_file.diff
```
