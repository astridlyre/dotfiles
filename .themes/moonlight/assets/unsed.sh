#!/bin/sh
sed -i \
         -e 's/rgb(0%,0%,0%)/#1b1b20/g' \
         -e 's/rgb(100%,100%,100%)/#b4b4b9/g' \
    -e 's/rgb(50%,0%,0%)/#1b1b20/g' \
     -e 's/rgb(0%,50%,0%)/#ffc552/g' \
 -e 's/rgb(0%,50.196078%,0%)/#ffc552/g' \
     -e 's/rgb(50%,0%,50%)/#1b1b20/g' \
 -e 's/rgb(50.196078%,0%,50.196078%)/#1b1b20/g' \
     -e 's/rgb(0%,0%,50%)/#b4b4b9/g' \
	"$@"
