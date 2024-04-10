
# Welcome to the CmdZNThangs Git Repo! 

This repo contains Micellany command files (Windows .BATs, 'Nix shell-scripts, etc)

These are provided as-is.

## cmdz -Contains Windows Implemenations

## sh   -Contains Linux/MAC-OS Implementations


## Notes:
- 10-Apr-2024: Initial implementation.
- 10-Apr-2024: For maven items, (ie m3 stuff), make sure you have the following evars set in your command-line enviro (Either Windows or Bash):

M2_USER=/Path-to-my/settings.xml  (ex. /Users/foo-user/data/maven-3.x/eric/settings.xml)
M2_DATA=/Path-to-my-m2 repo/      (ex. /Users/foo-user/data/maven-3.x  # This folder contains the .m2/ folder)
M2_HOME=/Path-to-my-maven-install (ex: /opt/java/apache-maven-3.9.6)

-These work best, when placed into a folder that is high in your path. (For me this is /dev2/sh or /dev2/cmdz)

### Maven Items:
-All of the m3xxx scripts call the m3 script.

### SDKMan:
-These commands where implemented before sdkman was implemented. Therefore the setXXX commands are replaced by the use of sdkman.   

## Helpful Hints:
-Because of the way some mvnw wrappers work (or not), you probably will want to create a sym-link to CENTRALIZED .m2 folder.  This will save you extraneous downloads of depenancies to redundant locations.  

On my MAC-os implementations, I've made my centralized .m2 location under:
```
/Users/foo-user/data/maven-3.x/.m2
```

NixCommand: 
```ln -s /Users/foo-user/data/maven-3.x/.m2 /Users/foo-user/.m2   # SymLink. ```







