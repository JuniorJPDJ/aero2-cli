# Aero2 CommandLine Interface

Pretty simple sh scripts handling aero2 captcha in terminal.
It supports printing images in terminal window using `catimg` or handling captchas through KDE notifications with D-BUS.

## Requirements:
- POSIX compatible system (eg. Linux based distro like Arch Linux or Alpine Linux)
- `catimg` when you want to show captchas in terminal window
- `gdbus` and `dbus-monitor` if you want to show captchas in KDE

## Usage:
Just run it!
```sh
$ ./aero-cli.sh
```

You can optionally specify second argument, which is command for captcha handling.
Default it will show captcha using catimg, you can also show your captcha in KDE notification if you are using KDE.
```sh
$ ./aero-cli.sh ./aero-captcha-handler-notify.sh
```


Aero2-CLI shows info boxes from original web page and gracefuly shuts down when internet access is already unlocked:
```sh
$ ./aero2-cli.sh 
Dostęp do Internetu został odblokowany.
```

If you are doing some weird networking like VPN, you may need to route `212.2.127.254` (Aero2 DNS) and `212.2.123.253` (Aero2 capative portal) through Aero2 WAN.

## Screenshots:

KDE Notifications:\
![image](https://user-images.githubusercontent.com/7334549/110255160-abd8d880-7f92-11eb-96fe-f5b477095c2d.png)

catimg:\
![image](https://user-images.githubusercontent.com/7334549/110255196-bf843f00-7f92-11eb-8c97-f233cbefc618.png)
