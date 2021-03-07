#!/bin/sh

catimg "$1" >&2
read -p "Captcha code: " captcha >&2
echo $captcha
