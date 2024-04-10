@ECHO OFF

call m3.bat clean,compile,package, -D"skipTests=true" -D"HOME=C:" %1
