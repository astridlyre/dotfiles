#!/bin/sh
sed -i \
         -e 's/rgb(0%,0%,0%)/#000000/g' \
         -e 's/rgb(100%,100%,100%)/#c6c6c6/g' \
    -e 's/rgb(50%,0%,0%)/#000000/g' \
     -e 's/rgb(0%,50%,0%)/#ffd787/g' \
 -e 's/rgb(0%,50.196078%,0%)/#ffd787/g' \
     -e 's/rgb(50%,0%,50%)/#000000/g' \
 -e 's/rgb(50.196078%,0%,50.196078%)/#000000/g' \
     -e 's/rgb(0%,0%,50%)/#c6c6c6/g' \
	"$@"
