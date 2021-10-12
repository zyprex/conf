# Preface

Private config of desktop environment(prefer feel over look).

- zsh: replacement of bash.
- suckless.org: dwm, windows manager, use some widget of xfce4.
- xfwm4: minic dwm as many as possible.
- timer.sh: countdown or countup seconds, locate in path `~/bin`.
- restime.sh: remember to take a break, locate in path `~/bin`.
- autostart.sh: autostart some programs, locate in path `~/bin`.
- redshift\_schedule.sh: change redshift color temperature every one hour, locate in path `~/bin`.
- backup.zsh: backup some files.

# Q&A

## About Font

Install fonts for current user only, copy font files to `$HOME/.local/share/fonts`, and `sudo fc-cache -f -v`.

List available fonts use: `fc-list`.

Find fonts on [ProgrammingFonts](https://www.programmingfonts.org/).

## Kill Other TTY

If you get stuck, consider switch to tty1~6 ( <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>F1~F6</kbd>), and terminate your processes.

```sh
who -la
kill <pid1> <pid2>
```

## Noisy Beep

[PC\_speaker](https://wiki.archlinux.org/title/PC_speaker#Globally)
Blacklisting the pcspkr module will prevent udev from loading it at boot. Create the file:
`/etc/modprobe.d/nobeep.conf` and `blacklist pcspkr`

## Adjust Brightness

In most cases, it nesssary get nonfree display driver after system upgrade:

```
sudo mhwd -a pci nonfree 0300
```

## Boot Benckmark

Some unnecessary service lagged the boot, use `systemctl` disable them:

```
systemd-analyze
systemd-analyze blame
systemctl disable [xxx]
```
