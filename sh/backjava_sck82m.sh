#!/bin/bash
# Process backup files locally, in order of:  CycleLocal, BackItUp, YankStuff.....
#

#set -x

  usage(){
          echo " "
          echo " "
          echo " "
          echo "Usage:   $0 -F/-f       -Force back-up to LAN if VPN Connection Detected."
          echo "            -H/-h       -Show this help Screen."
          echo " "
          echo " "
    exit 1
  }

    if [  "$1" == "-H" ] || [ "$1" == "-h" ]
        then
          usage
    fi

    HomeSRCDir=''
    HomeSRCDir='/Users/dks0794897/dev2/java/dcsg/master/spring-cloud-kubernetes2'

    MaxFolders=''
    MaxFolders='20'

    ParentDirName=""
    ParentDirName="/Users/dks0794897/data/back/$HOSTNAME/dev2/java"

    ChildDirName=''
    ChildDirName='spring-cloud-kubernetes2-master'

    export LAN_VOL=
    export LAN_VOL='/media/eric/SlaveB'

    LANParentDirName=""
    LANParentDirName="$LAN_VOL$ParentDirName"

    needleHome="192.168.1"

    ifconfig | grep $needleHome >/dev/null
    greprc=$?

    cd $HomeSRCDir
    cd ./projects/spring-cloud-kubernetes-consumer-service

    m3 clean
    ./gradlew clean
    rm -rfv .gradle


    #$HomeSRCDir/projects/spring-cloud-kubernetes-consumer-service/.gradlew clean

    # Backs up locally to shadow directory...

    /Users/dks0794897/dev2/sh/cycleFolders2 "$ParentDirName" "$ChildDirName" "$MaxFolders"

    mkdir "$ParentDirName"
    mkdir "$ParentDirName/$ChildDirName"

    # Need a call to mvn clean here..

    /Users/dks0794897/dev2/sh/syncBackDir3  "$ParentDirName/$ChildDirName" "$HomeSRCDir" '**/*' '**/.git/*'

    # Backs up locally to external storage

    #
    # Check to see if at home...FORCE flag must be present, otherwise do LAN backup....
    #

    if [ $greprc -eq 0 ]
       then

          echo " "
          echo "*** Running At Home, Checking for FORCE..."
          echo " "

          if [  "$1" == "-F" ] || [ "$1" == "-f" ]
             then
                echo " "
                echo "FORCE DETECTED....Using FORCE!!"
                echo " "
          else
                echo " "
                echo "NO FORCE DETECTED....Dropping out..."
                echo " "

                exit 0
          fi

    fi

    # Does this exist ?
    if [ -d "$LAN_VOL" ]
        then

          /Users/dks0794897/dev2/sh/cycleFolders2 "$LANParentDirName" "$ChildDirName" "$MaxFolders"

          mkdir "$LANParentDirName"
          mkdir "$LANParentDirName/$ChildDirName"

          /Users/dks0794897/dev2/sh/syncBackDir3  "$LANParentDirName/$ChildDirName" "$HomeSRCDir" '**/*' '**/.git/*'


    else
        echo "$LAN_VOL" is not attached!
    fi
