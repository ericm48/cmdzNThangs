@ECHO OFF

call m3.bat clean,compile,package,install -D"skipTests=true" -D"HOME=C:" %1
