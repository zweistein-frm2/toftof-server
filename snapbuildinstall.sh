#!/bin/sh
snapcraft --debug # only needed to generate .snap file
sudo snap install toftof-server_1_amd64.snap --devmode  # this works on every linux with snapd support (ubuntu 18 and higher  by default)