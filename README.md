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

- KerbalEngineerRedux 1.0.16.6
- kOS 0.17.2
- RemoteTech 1.6.5
- SmartParts 1.6.5
- EnvironmentalVisualEnhancements-HR 7-4

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
[root directory](http://wiki.kerbalspaceprogram.com/wiki/Root_directory), and
copy the craft files into your savegame. The kOS scripts used will need to be
placed in `Ships/Script` at the top of your root directory.

## Questions and Contributions

If you have any questions about the project, please feel free to to submit an
[issue](https://github.com/gisikw/ksprogramming/issues).

As the series continues, we'll likely be adding some shared KerboScript
libraries to ensure we don't need to rewrite everything from scratch. As we
reach that point, pull requests are very much encouraged!
