#!/bin/sh
sed -i \
         -e 's/#1e1d2f/rgb(0%,0%,0%)/g' \
         -e 's/#d9e0ee/rgb(100%,100%,100%)/g' \
    -e 's/#1a1826/rgb(50%,0%,0%)/g' \
     -e 's/#abe9b3/rgb(0%,50%,0%)/g' \
     -e 's/#1e1d2f/rgb(50%,0%,50%)/g' \
     -e 's/#d9e0ee/rgb(0%,0%,50%)/g' \
	"$@"
