# rutosbuild

Teltonika RutOS is OpenWrt based Linux operating system used in Teltonika networking
products (as well as some generic platforms).

This configuration sets up RutOS build environment and suplementary scripts
to compile RutOS.

https://wiki.teltonika.lt/view/Software_Development_Kit_instructions


## Layout
The SDK is downloaded from Teltonika webpage. In the container the RutOS 
source (SDK) is by default placed in /home/build/RUT folder with "build_rut.sh"
script for compilation with default settings. 

The SDK source URL and local build directory are defined with environment variables
`SOURCEURL` and `LOCALBUILDDIR` respectively.

The config system has check to NOT allow building as user "root" so process
must use some other user. 
User is set to "build" 



## Compiling

By default running the container builds RutOS. This is done by the script 
`/home/build/RUT/build_rut.sh`.

NOTE this will compile the toolset needed, the kernel and services making the
RutOS and process can take rather long time depending on the available compute 
resources.

Example output (with lots of compilation output removed)

```
[xeon ~]$ time docker run pmta/rutosbuild 
:
Using LOCALBUILDDIR /home/build/RUT/
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   194  100   194    0     0   1644      0 --:--:-- --:--:-- --:--:--  1644
100  394M  100  394M    0     0  22.4M      0  0:00:17  0:00:17 --:--:-- 24.4M
tar: Removing leading `/' from member names
Checking 'non-root'... ok.
Checking 'working-make'... ok.
:
# configuration written to .config
#
Using 82 jobs for compilation (80 CPUs + 2)
 make[1] world
 make[2] compile-install
 :
 make[4] -C target/linux install
 make[2] package/index
Build successful

real	22m9.127s
user	0m0.141s
sys	0m0.055s
[xeon ~]$ 
```

### Options

By default the image uses Number_of_CPUs + 2 jobs for compilation. In the
example above a system with 80 CPUs the number of jobs equal to 82. 

This can be overridden by setting environment variable NPROC to positive
integer number of desired (parallel) jobs. 

The NPROC environment variable defines the number CPUs that should be used for
compilation.

For example limit used CPUs to 8:
```
[i7 ~]$ docker run --env NPROC=8 pmta/rutosbuild
:
Using LOCALBUILDDIR /home/build/RUT/
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   194  100   194    0     0   1644      0 --:--:-- --:--:-- --:--:--  1644
100  394M  100  394M    0     0  22.4M      0  0:00:17  0:00:17 --:--:-- 24.4M
tar: Removing leading `/' from member names

Checking 'non-root'... ok.
Checking 'working-make'... ok.
:
# configuration written to .config
#
Using 8 jobs for compilation (as defined by NPROC ENV variable)
 make[1] world
 make[2] compile-install
 :
```


Instead of automatically building, the container can be started with shell for
modifying settings etc.

Build can be started manually with "build_rut.sh" script.

```
[xeon ~]$ docker run -it pmta/rutosbuild sh
$ ls
README	RUT  

$ cat README
############################
# To manually compile run: 
# cd $LOCALBUILDDIR
# /bin/sh ./build_rut.sh

$ cd $LOCALBUILDDIR
$ /bin/sh ./build_rut.sh
Using LOCALBUILDDIR /home/build/RUT/
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   194  100   194    0     0   1644      0 --:--:-- --:--:-- --:--:--  1644
100  394M  100  394M    0     0  22.4M      0  0:00:17  0:00:17 --:--:-- 24.4M
tar: Removing leading `/' from member names

Checking 'non-root'... ok.
Checking 'working-make'... ok.
:

```

