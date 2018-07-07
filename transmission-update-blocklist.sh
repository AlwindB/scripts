#!/bin/bash

export PATH=/raid/data/module/ModBase1/system/bin:$PATH

# blocklist directory
BLOCKLISTDIR=/raid/data/MOD_CONFIG/transmission/blocklists

cd ${BLOCKLISTDIR}
if [ $? -eq 0 ]; then
  if [ -f blocklist ]; then
    echo "removing blocklist file"
    rm blocklist
  fi
  # if no blocklist file exist update blocklist
  if [ ! -f blocklist ]; then
    echo "no blocklist file exists, fetching through wget"
    wget --quiet --output-document=blocklist.gz "http://john.bitsurge.net/public/biglist.p2p.gz"
    # if download successful unzip it
    if [ -f blocklist.gz ]; then
          echo "downloaded blocklist.gz successfully, unzipping"
          gunzip blocklist.gz
          # if file extracted successfully reload transmission
          if [ $? -eq 0 ]; then
            echo "blocklist extracted, preparing to reload transmission"
            chmod go+r blocklist
            killall transmission-daemon
            sleep 20
            /raid/data/module/transmission/sys/bin/transmission-daemon --logfile /raid/data/MOD_CONFIG/transmission/logfile.log --config-dir /raid/data/MOD_CONFIG/transmission
          else
                echo "removing any blocklist* file"
                rm -f blocklist*
          fi
        fi
  fi
  cd - 2>&1 >/dev/null
fi
