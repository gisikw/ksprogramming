Kerbal Space Programming
========================

Kerbal Space Programming is a YouTube playthrough of [Kerbal Space
Program](https://kerbalspaceprogram.com) using entirely automated technology.
The video series can be enjoyed
[here](https://www.youtube.com/watch?v=fNlAME5eU3o&list=PLb6UbFXBdbCrvdXVgY_3jp5swtvW24fYv).

This repository is set up to provide the ships and scripts used for each
episode, and can be found in the various directories.

## List of Mods Used

For this playthrough the following mods were installed using the [Comprehensive
Kerbal Archive Network (CKAN)](https://github.com/KSP-CKAN/CKAN):

- KerbalEngineerRedux
- kOS
- RemoteTech
- SmartParts
- SurfaceLights
- TAC Life Support

There are several visual enhancement mods used in the playthrough, but the
above list should be sufficient to run the crafts in this repository.

This playthrough has a particular emphasis on the [Kerbal Operating System
(kOS)](https://github.com/KSP-KOS/KOS), which allows players to script the
behavior of their vessels like so:

    PRINT "Launching the ship!".
    STAGE.
    WAIT 10.
    STAGE.
    WAIT 10.
    PRINT "...are we there yet?".

For more information about the KerboScript syntax, visit their [documentation
page](http://ksp-kos.github.io/KOS_DOC/).

## Loading Ships and Scripts

All of the craft files and kOS scripts can be found in episode directories for
this repository. To use them in your own game, locate your Kerbal Space Program
[root directory](http://wiki.kerbalspaceprogram.com/wiki/Root_directory).

Craft files should be placed in either `./saves/[YOURSAVEGAME]/Ships/VAB` or
`./saves[YOURSAVEGAME]/Ships/SPH`, based on whether you wish to load them in
the Vehicle Assembly Building or the Spaceplane Hanger, respectively.

kOS script files should be placed into `./Ships/Script`, so that they can be
accessed on the Archive Volume inside kOS.

### Boot Scripts, Update Files, and Libraries

In later episodes, much of the mission logic has been handled using libraries
of shared utilities. To ensure that mission scripts are able to load these
libraries, the contents of the `library` folder of this repository should also
be copied into `./Ships/Script`.

Many of the craft in the episodes have instructions automatically uploaded
using the `boot.ks` script in the library directory. Mission scripts can then
be directly uploaded to the vessel by naming them
`./Ships/Script/[SHIPNAME].update.ks`

## Questions and Contributions

*Please note: many of the scripts here were valid with older versions of kOS
and may include syntax that is no longer accurate.*

If you have any questions about the project, please feel free to to submit an
[issue](https://github.com/gisikw/ksprogramming/issues).
