# Bezelproject for Linux

A modified script based on the BezelProject to allow for compatibility with regular Linux systems instead of just RetroPie. Requires both dialog and RPL to be installed. It also assumes a default installation of retroarch (i. e. through a package manager).

To get dialog on Arch Linux use ***sudo pacman -S dialog***. RPL is available as an AUR package.

-------
OVERVIEW

The Bezel Project Bezel Utility menu.

This utility will provide a downloader for Retroarach system bezel packs.

This utility provides a download for a bezel pack for a system and includes a PNG bezel file for every ROM for that system.  The download will also include the necessary configuration files needed for Retroarch to show them.

Periodically, new bezel packs are completed and you will need to run the script updater to download the newest version to see these additional packs.

***NOTE***
To have global support, these bezel packs will only work if the ROMs you are using are named according to the No-Intro naming convention used by EmuMovies/HyperSpin.

Systems with shared Retroarch cores and filenames: 
Only one bezel can exist for a specific game name, so systems that share the same Retroarch core and rom filename will use the same bezel.

-------
INSTALLATION

NOTE: do not install the script as user 'root'.  Only install the script as a normal user...otherwise it may cause future errors.

Before downloading, make sure bezels are enabled in retroarch by going to **Settings>On-Screen Display>Display Overlay** and setting it to "ON". Make sure to also enable fullscreen in **Settings>Video>Fullscreen Mode>Start in Fullscreen Mode**, since these are made to be used in fullscreen and break on Windowed Mode.

Type the following commands:

***wget https://raw.githubusercontent.com/Nitr4m12/BezelProject-for-Linux/master/bezelproject_linux.sh***

***chmod +x bezelproject_linux.sh***

***./bezelproject_linux.sh*** or ***bash bezelproject_linux.sh***

-------
UNINSTALL

NOTE: This modified script has the uninstall option removed by default, since I couldn't think of a way to make it work as it does in RetroPie. As of now, it deletes everything inside the config folder, including custom mappings and .opt files.

To manually remove The Bezel Project, delete the following directories.

~/.config/retroarch/overlay/ArcadeBezels

~/.config/retroarch/overlay/GameBezels

Edit the retroarch.cfg located in the main directory (I recommend making a backup first):

~/.config/retroarch/

In retroarch, disable overlays by going to Settings>On-Screen Display>Display Overlays, and setting it to "OFF"

To remove the Retroarch game override config files, delete the core named folders located here:

~/.config/retroarch/config/(core named folder)

-------
Supported cores

Arcade                                          lr-mame2003, lr-mame2010, lr-fba

Atari 2600                                      lr-stella

Atari 5200                                      lr-atari800

Atari 7800                                      lr-prosystem

ColecoVision                                    lr-bluemsx

GCE Vectrex                                     lr-vecx

NEC PC Engine CD                                lr-beetle-pce-fast

NEC PC Engine                                   lr-beetle-pce-fast

NEC SuperGrafx                                  lr-beetle-supergrafx

NEC TurboGrafx-CD                               lr-beetle-pce-fast

NEC TurboGrafx-16                               lr-beetle-pce-fast

Nintendo 64                                     lr-Mupen64plus

Nintendo Entertainment System                   lr-fceumm, lr-nestopia

Nintendo Famicom Disk System                    lr-fceumm, lr-nestopia

Nintendo Famicom                                lr-fceumm, lr-nestopia

Nintendo Game Boy                               lr-gambatte, lr-mgba

Nintendo Game Boy Color                         lr-gambatte, lr-mgba

Nintendo Super Famicom                          lr-snes9x, lr-snes9x2010

Sega 32X                                        lr-picodrive, lr-genesis-plus-gx

Sega CD                                         lr-picodrive, lr-genesis-plus-gx

Sega Genesis                                    lr-picodrive, lr-genesis-plus-gx

Sega Master System                              lr-picodrive, lr-genesis-plus-gx

Sega Mega Drive                                 lr-picodrive, lr-genesis-plus-gx

Sega Mega Drive Japan                           lr-picodrive, lr-genesis-plus-gx

Sega SG-1000                                    lr-genesis-plus-gx

Sony PlayStation                                lr-pcsx-rearmed

Super Nintendo Entertainment System             lr-snes9x, lr-snes9x2010
