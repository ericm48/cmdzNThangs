@ECHO OFF

set JAVA_HOME=
set JAVA_HOME=C:\apps\java\jdk1.8.0_05

set JRE_HOME=
set JRE_HOME=C:\apps\java\jdk1.8.0_05

set JAVAFX_HOME=
set JAVAFX_HOME=C:\apps\java\JavaFX2.0SDK

set PATH=%JAVA_HOME%\bin;%JAVAFX_HOME%\rt\bin;%PATH%

set JVM_OPTS=
set JVM_OPTS=-Xmx1024m

