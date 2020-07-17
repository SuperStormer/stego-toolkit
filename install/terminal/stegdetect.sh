#!/bin/bash

set -e

# Download
wget -O /tmp/wenglish.deb https://snapshot.debian.org/archive/debian/20050312T000000Z/pool/main/w/wenglish/wenglish_2.0-2_all.deb
wget -O /tmp/stegdetect.deb https://snapshot.debian.org/archive/debian/20080801T000000Z/pool/main/s/stegdetect/stegdetect_0.6-6_amd64.deb

# Install
dpkg -i /tmp/wenglish.deb
dpkg -i /tmp/stegdetect.deb || apt-get install -f -y
rm /tmp/stegdetect.deb /tmp/wenglish.deb
