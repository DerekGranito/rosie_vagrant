# Rosie Local Development VM for Vagrant
Provides a `Vagrantfile` and supporting scripts to run the Rosie environment
using Vagrant on systems like Windows or OS X.

## Contributors:
  - Mike Ryzewic (initial VM setup + instructions)
  - Guy Paddock (NFS Support for Windows and OSX, revised instructions)

## How to Use
The instructions for getting this version running are different, depending upon whether or not you've already got a local development VM running. This section includes steps for both scenarios.

### If you already have a v1 VM
If you already have a local Rosie development VM that is not yet using NFS mounts, you can upgrade it by following these steps:

1. Clone this `rosie_vagrant` repo from GitHub to somewhere on your machine. It can even be in your `rosie_dev` folder, but **not inside your `rosie_dev_vm` folder**.

2. Navigate to your existing `rosie_dev_vm` folder (typically, `rosie_dev/rosie_dev_vm`).

3. Rename your `Vagrantfile` to `Vagrantfile.bak`, to keep a back-up copy in case things don't work out.

4. _(Optional)_ Make a copy of your `package.box` file to somewhere safe, to keep a back-up copy in case things don't work out. This is an optional step because its typically unnecessary, the file is quite large, and it can take a long time to copy.

5. Copy the contents of the folder in which this `Readme.md` file resides (from the root of the GIT repo, that's the contents of `rosie_vagrant/configs/local_dev_vm`) into your `rosie_dev_vm` folder (where you navigated in step #2). This will create a new `Vagrantfile` in your `rosie_dev_vm` alongside the back-up copy you created in step #2, and add a few new files as well.

6. Open a command prompt / terminal window inside the `rosie_dev_vm` folder.

7. If you are running Windows, follow the special instructions for NFS in the
   section labeled ["Using NFS on Windows"](#using-nfs-on-windows) below,
   then proceed to the next step. On other OSes, you can skip this step.

8. Launch the new Rosie dev VM:

        vagrant up
        
9. If you get any errors, please troubleshoot them, and let your fellow
    developers know. :)

### If you're running the VM for the first time
These steps complement steps found on Confluence for [getting your development 
VM set-up](https://confluence.rosieapp.com/display/DEV/Rosie+Development+VM).

1. Install [Vagrant](https://www.vagrantup.com/downloads.html) and
  [Oracle VirtualBox](https://www.virtualbox.org/wiki/Downloads), if you have
  not already done so.

2. Create a folder on your machine called `rosie_dev`.  
   _For best results on a Windows machine, this should be in a path that is
   relatively short (for example, `C:\rosie_dev` or
   `C:\Users\short_user\rosie_dev`), as paths inside projects can often exceed
   Windows' [legacy 260 character limit on paths](https://msdn.microsoft.com/en-us/library/windows/desktop/aa365247\(v=vs.85\).aspx)._

3. Inside the folder you created in step #2, proceed to clone each of the Rosie
   projects you'll be working on using GIT /
   [SourceTree](https://www.sourcetreeapp.com/), such that the directory
   structure of the `rosie_dev` folder looks something like this:
   
   - `rosie_dev`
     - [`./rosie_server`](https://github.com/RosieApp/rosie_server)
     - [`./rosie_retailers`](https://github.com/RosieApp/rosie_retailers)
     - [`./analytics`](https://github.com/RosieApp/analytics)
     - [`./rare`](https://github.com/RosieApp/rare)
   
4. Inside the `rosie_dev` folder, create a folder called `rosie_dev_vm` (this should be alongside `rosie_server`, `rosie_retailers`, etc).

5. Unpack the folder in which this `Readme.md` file resides into the folder you
   created in step #4.

6. Obtain the latest `package.box.zip` file from here:

   https://drive.google.com/a/rosieapp.com/folderview?id=0B9J1ODuZicaHTG9DTVhpQVRNUVk&usp=sharing

7. Unpack the `package.box.zip` file into the `rosie_dev_vm` folder, so that
   you have `rosie_dev/rosie_dev_vm/package.box`.

8. Open a command prompt / terminal window inside the `rosie_dev_vm` folder.

9. If you are running Windows, follow the special instructions for NFS in the
   section labeled ["Using NFS on Windows"](#using-nfs-on-windows) below,
   then proceed to the next step. On other OSes, you can skip this step.

10. Use Vagrant to add the Rosie dev VM to your local VirtualBox install:

        vagrant box add rosie_dev rosie_dev.box

11. Launch the Rosie dev VM for the first time (_this typically takes 4-5
    minutes; do not worry_):

        vagrant up
        
12. If you get any errors, please troubleshoot them, and let your fellow
    developers know. :)

13. If all goes well, you should be able to follow along with the rest of the
    steps [in Confluence](https://confluence.rosieapp.com/display/DEV/Rosie+Development+VM) to run Rosie for the first time.

## Using NFS on Windows
For maximum performance, NFS is used to mount projects inside the VM instead of
VirtualBox shared folders. Unfortunately, Windows does not natively support
NFS. Luckily, an extension called
[Vagrant WinNFSd](https://github.com/winnfsd/vagrant-winnfsd) fills-in this gap
decently well.

Follow the steps in the following section(s) to get it installed:

### Using the "release" version of Vagrant WinNFSd
The release version is the most stable release, but has some flaws (described
in the next section). To get it, simply run the following to install Vagrant
WinNFSd:

    vagrant plugin install vagrant-winnfsd
    
### Using Rosie's custom version of Vagrant WinNFSd
At the time that this document has been written, Vagrant WinNFSd has several
issues that can make it frustrating to use. Namely, the fact that the share
list is not automatically reloaded when you reload your VM.

Alternatively, install the release version as mentioned in the above section,
and then replace the contents of the Vagrant WinNFSd plug-in (found under `C:\Users\%USERNAME%\.vagrant.d\gems\gems\vagrant-winnfsd-VERSION`, where
VERSION is currently `1.1.0` for me) with the custom fork found in the `master`
branch here:

https://github.com/GuyPaddock/vagrant-winnfsd
