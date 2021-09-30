#!/bin/bash

#IFS=';'

# Welcome
 dialog --backtitle "The Bezel Project" --title "The Bezel Project - Bezel Pack Utility" \
    --yesno "\nThe Bezel Project Bezel Utility menu.\n\nThis utility will provide a downloader for Retroarach system bezel packs to be used for various systems within RetroPie.\n\nThese bezel packs will only work if the ROMs you are using are named according to the No-Intro naming convention used by EmuMovies/HyperSpin.\n\nThis utility provides a download for a bezel pack for a system and includes a PNG bezel file for every ROM for that system.  The download will also include the necessary configuration files needed for Retroarch to show them.  The script will also update the required retroarch.cfg files for the emulators located in the /opt/retropie/configs directory.  These changes are necessary to show the PNG bezels with an opacity of 1.\n\nPeriodically, new bezel packs are completed and you will need to run the script updater to download the newest version to see these additional packs.\n\n**NOTE**\nThe MAME bezel back is inclusive for any roms located in the arcade/fba/mame-libretro rom folders.\n\n\nDo you want to proceed?" \
    28 110 2>&1 > /dev/tty \
    || exit


function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "What action would you like to perform?" 25 75 20 \
            1 "Update install script - script will exit when updated" \
            2 "Download theme style bezel pack" \
            3 "Download system style bezel pack" \
            4 "Information:  Retroarch cores setup for bezels per system" \
            5 "Uninstall the bezel project completely" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) update_script  ;;
            2) download_bezel  ;;
            3) download_bezelsa  ;;
            4) retroarch_bezelinfo  ;;
            5) removebezelproject ;;
            *)  break ;;
        esac
    done
}

#########################################################
# Functions for download and enable/disable bezel packs #
#########################################################


function update_script() {
    # Code taken and modified from https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
    SCRIPTPATH="$( cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 ; pwd -P )"

    mv "${SCRIPTPATH}/bezelproject_linux.sh" "${SCRIPTPATH}/bezelproject_linux.sh.bkp"
    wget "https://raw.githubusercontent.com/Nitr4m12/BezelProject-for-Linux/master/bezelproject_linux.sh"
    chmod 777 "bezelproject_linux.sh"
    exit
}

function install_bezel_pack() {
    local theme="$1"
    local repo="$2"
    if [[ -z "$repo" ]]; then
        repo="default"
    fi
    if [[ -z "$theme" ]]; then
        theme="default"
        repo="default"
    fi
    atheme=`echo ${theme} | sed 's/.*/\L&/'`

    git clone "https://github.com/${repo}/bezelproject-${theme}.git" "/tmp/${theme}"
    find "/tmp/${theme}/retroarch/config/" -type f -name "*.cfg" -print0 | while IFS= read -r -d '' file; do
        sed -i 's+/opt/retropie/configs/all+~/.config+g' "${file}"
        echo 'video_fullscreen = "true"' >> "${file}"
    done
    if [[ ! -d "${HOME}/.config/retroarch/overlay/GameBezels/${theme}" ]]; then
        mkdir -p "${HOME}/.config/retroarch/overlay/GameBezels/${theme}"
        ls "/tmp/${theme}/retroarch/config" >> "${HOME}/.config/retroarch/overlay/GameBezels/${theme}/emulators.txt" 
        cat "${HOME}/.config/retroarch/overlay/GameBezels/${theme}/emulators.txt" >> "${HOME}/.config/retroarch/overlay/all_emulators.txt"
    fi
    cp -r "/tmp/${theme}/retroarch/" "${HOME}/.config/"
    rm -rf "/tmp/${theme}"
}

function uninstall_bezel_pack() {
    local theme="$1"
    if [[ -d "${HOME}/.config/retroarch/overlay/GameBezels/${theme}" ]]; then
        while IFS= read -r dir; do
            rm -rf "${HOME}/.config/retroarch/config/${dir}" 
        done < "${HOME}/.config/retroarch/overlay/${theme}/emulators.txt"
        rm -rf "${HOME}/.config/retroarch/overlay/GameBezels/${theme}"
    fi
    if [[ "${theme}" == "MAME" ]]; then
      if [[ -d "${HOME}/.config/retroarch/overlay/ArcadeBezels" ]]; then
        while IFS= read -r dir; do
            rm -rf "${HOME}/.config/retroarch/config/${dir}" 
        done < "${HOME}/.config/retroarch/overlay/MAME/emulators.txt"      
        rm -rf "${HOME}/.config/retroarch/overlay/ArcadeBezels"
      fi
    fi
}

function removebezelproject() {
    rm -rf "${HOME}/.config/retroarch/overlay/GameBezels"
    rm -rf "${HOME}/.config/retroarch/overlay/ArcadeBezels"
    # Code adapted from https://askubuntu.com/questions/503334/how-to-move-directories-that-were-listed-in-a-txt-file?rq=1
    while IFS= read -r dir; do
        rm -rf "${HOME}/.config/retroarch/config/${dir}" 
    done < ~/.config/retroarch/overlay/all_emulators.txt
    rm -f ~/.config/retroarch/overlay/all_emulators.txt
}

function download_bezel() {
    local themes=(
        'thebezelproject Atari2600'
        'thebezelproject Atari5200'
        'thebezelproject Atari7800'
        'thebezelproject AtariJaguar'
        'thebezelproject AtariLynx'
        'thebezelproject Atomiswave'
        'thebezelproject C64'
        'thebezelproject CD32'
        'thebezelproject CDTV'
        'thebezelproject ColecoVision'
        'thebezelproject Dreamcast'
        'thebezelproject FDS'
        'thebezelproject Famicom'
        'thebezelproject GB'
        'thebezelproject GBA'
        'thebezelproject GBC'
        'thebezelproject GCEVectrex'
        'thebezelproject GameGear'
        'thebezelproject Intellivision'
        'thebezelproject MAME'
        'thebezelproject MSX'
        'thebezelproject MSX2'
        'thebezelproject MasterSystem'
        'thebezelproject MegaDrive'
        'thebezelproject N64'
        'thebezelproject NDS'
        'thebezelproject NES'
        'thebezelproject NGP'
        'thebezelproject NGPC'
        'thebezelproject Naomi'
        'thebezelproject PCE-CD'
        'thebezelproject PCEngine'
        'thebezelproject PSX'
        'thebezelproject SFC'
        'thebezelproject SG-1000'
        'thebezelproject SNES'
        'thebezelproject Saturn'
        'thebezelproject Sega32X'
        'thebezelproject SegaCD'
        'thebezelproject SuperGrafx'
        'thebezelproject TG-CD'
        'thebezelproject TG16'
        'thebezelproject Videopac'
        'thebezelproject Virtualboy'
    )
    while true; do
        local theme
        local installed_bezelpacks=()
        local repo
        local options=()
        local status=()
        local default

        local i=1
        for theme in "${themes[@]}"; do
            theme=($theme)
            repo="${theme[0]}"
            theme="${theme[1]}"
            if [[ $theme == "MegaDrive" ]]; then
              theme="Megadrive"
            fi
            if [[ -d "${HOME}/.config/retroarch/overlay/GameBezels/${theme}" ]]; then
                status+=("i")
                options+=("$i" "Update or Uninstall ${theme} (installed)")
                installed_bezelpacks+=("${theme} $repo")
            else
                status+=("n")
                options+=("$i" "Install ${theme} (not installed)")
            fi
            ((i++))
        done
        local cmd=(dialog --default-item "$default" --backtitle "$__backtitle" --menu "The Bezel Project -  Theme Style Downloader - Choose an option" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        [[ -z "$choice" ]] && break
        case "$choice" in
            *)  #install or update themes
                theme=(${themes[choice-1]})
                repo="${theme[0]}"
                theme="${theme[1]}"
#                if [[ "${status[choice]}" == "i" ]]; then
                if [[ -d "${HOME}/.config/retroarch/overlay/GameBezels/${theme}" ]]; then
                    options=(1 "Update ${theme}" 2 "Uninstall ${theme}")
                    cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option for the bezel pack" 12 40 06)
                    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
                    case "$choice" in
                        1)
                            install_bezel_pack "${theme}" "${repo}"
                            ;;
                        2)
                            uninstall_bezel_pack "${theme}"
                            ;;
                    esac
                else
                    install_bezel_pack "${theme}" "${repo}"
                fi
                ;;
        esac
    done
}

function install_bezel_packsa() {
    local theme="$1"
    local repo="$2"
    if [[ -z "${repo}" ]]; then
        repo="default"
    fi
    if [[ -z "${theme}" ]]; then
        theme="default"
        repo="default"
    fi
    atheme=`echo ${theme} | sed 's/.*/\L&/'`

    git clone "https://github.com/${repo}/bezelprojectsa-${theme}.git" "/tmp/${theme}"
    find "/tmp/${theme}/retroarch/config/" -type f -name "*.cfg" -print0 | while IFS= read -r -d '' file; do
     sed -i 's+/opt/retropie/configs/all+~/.config+g' "${file}"
     echo 'video_fullscreen = "true"' >> "${file}"
    done
    cp -r "/tmp/${theme}/retroarch/" "${HOME}/.config/"
    rm -rf "/tmp/${theme}"
}

function download_bezelsa() {
    local themes=(
        'thebezelproject Amiga'
        'thebezelproject AmstradCPC'
        'thebezelproject Atari2600'
        'thebezelproject Atari5200'
        'thebezelproject Atari7800'
        'thebezelproject Atari800'
        'thebezelproject AtariJaguar'
        'thebezelproject AtariLynx'
        'thebezelproject AtariST'
        'thebezelproject Atomiswave'
        'thebezelproject C64'
        'thebezelproject CD32'
        'thebezelproject CDTV'
        'thebezelproject ColecoVision'
        'thebezelproject Dreamcast'
        'thebezelproject FDS'
        'thebezelproject Famicom'
        'thebezelproject GB'
        'thebezelproject GBA'
        'thebezelproject GBC'
        'thebezelproject GCEVectrex'
        'thebezelproject GameGear'
        'thebezelproject Intellivision'
        'thebezelproject MAME'
        'thebezelproject MSX'
        'thebezelproject MSX2'
        'thebezelproject MasterSystem'
        'thebezelproject MegaDrive'
        'thebezelproject N64'
        'thebezelproject NDS'
        'thebezelproject NES'
        'thebezelproject NGP'
        'thebezelproject NGPC'
        'thebezelproject PCE-CD'
        'thebezelproject PCEngine'
        'thebezelproject PSX'
        'thebezelproject Pico'
        'thebezelproject SFC'
        'thebezelproject SG-1000'
        'thebezelproject SNES'
        'thebezelproject Saturn'
        'thebezelproject Sega32X'
        'thebezelproject SegaCD'
        'thebezelproject SuperGrafx'
        'thebezelproject TG-CD'
        'thebezelproject TG16'
        'thebezelproject Videopac'
        'thebezelproject Virtualboy'
        'thebezelproject WonderSwan'
        'thebezelproject WonderSwanColor'
        'thebezelproject X68000'
        'thebezelproject ZX81'
        'thebezelproject ZXSpectrum'
    )
    while true; do
        local theme
        local installed_bezelpacks=()
        local repo
        local options=()
        local status=()
        local default

        local i=1
        for theme in "${themes[@]}"; do
            theme=($theme)
            repo="${theme[0]}"
            theme="${theme[1]}"
            if [[ ${theme} == "MegaDrive" ]]; then
              theme="Megadrive"
            fi
            if [[ -d "${HOME}/.config/retroarch/overlay/GameBezels/${theme}" ]]; then
                status+=("i")
                options+=("$i" "Update or Uninstall ${theme} (installed)")
                installed_bezelpacks+=("${theme} ${repo}")
            else
                status+=("n")
                options+=("$i" "Install ${theme} (not installed)")
            fi
            ((i++))
        done
        local cmd=(dialog --default-item "$default" --backtitle "$__backtitle" --menu "The Bezel Project -  System Style Downloader - Choose an option" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        [[ -z "$choice" ]] && break
        case "$choice" in
            *)  #install or update themes
                theme=(${themes[choice-1]})
                repo="${theme[0]}"
                theme="${theme[1]}"
#                if [[ "${status[choice]}" == "i" ]]; then
                if [[ -d "${HOME}/.config/retroarch/overlay/GameBezels/${theme}" ]]; then
                    options=(1 "Update ${theme}" 2 "Uninstall ${theme}")
                    cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option for the bezel pack" 12 40 06)
                    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
                    case "$choice" in
                        1)
                            install_bezel_packsa "${theme}" "${repo}"
                            ;;
                        2)
                            uninstall_bezel_pack "${theme}"
                            ;;
                    esac
                else
                    install_bezel_packsa "${theme}" "${repo}"
                fi
                ;;
        esac
    done
}

function retroarch_bezelinfo() {

echo "The Bezel Project is setup with the following sytem-to-core mapping." > /tmp/bezelprojectinfo.txt
echo "" >> /tmp/bezelprojectinfo.txt

echo "To show a specific game bezel, Retroarch must have an override config file for each game.  These " >> /tmp/bezelprojectinfo.txt
echo "configuration files are saved in special directories that are named according to the Retroarch " >> /tmp/bezelprojectinfo.txt
echo "emulator core that system uses." >> /tmp/bezelprojectinfo.txt
echo "" >> /tmp/bezelprojectinfo.txt

echo "The supplied Retroarch configuration files for the bezel utility are setup to use certain " >> /tmp/bezelprojectinfo.txt
echo "emulators for certain systems." >> /tmp/bezelprojectinfo.txt
echo "" >> /tmp/bezelprojectinfo.txt

echo "In order for the supplied bezels to be shown, you must be using the proper Retroarch emulator " >> /tmp/bezelprojectinfo.txt
echo "for a system listed in the table below." >> /tmp/bezelprojectinfo.txt
echo "" >> /tmp/bezelprojectinfo.txt

echo "This table lists all of the systems that have the abilty to show bezels that The Bezel Project " >> /tmp/bezelprojectinfo.txt
echo "hopes to make bezels for." >> /tmp/bezelprojectinfo.txt
echo "" >> /tmp/bezelprojectinfo.txt
echo "" >> /tmp/bezelprojectinfo.txt

echo "System                                          Retroarch Emulator" >> /tmp/bezelprojectinfo.txt
echo "Amstrad CPC                                     lr-caprice32" >> /tmp/bezelprojectinfo.txt
echo "Atari 800                                       lr-atari800" >> /tmp/bezelprojectinfo.txt
echo "Atari 2600                                      lr-stella" >> /tmp/bezelprojectinfo.txt
echo "Atari 5200                                      lr-atari800" >> /tmp/bezelprojectinfo.txt
echo "Atari 7800                                      lr-prosystem" >> /tmp/bezelprojectinfo.txt
echo "Atari Jaguar                                    lr-virtualjaguar" >> /tmp/bezelprojectinfo.txt
echo "Atari Lynx                                      lr-handy, lr-beetle-lynx" >> /tmp/bezelprojectinfo.txt
echo "Atari ST                                        lr-hatari" >> /tmp/bezelprojectinfo.txt
echo "Bandai WonderSwan                               lr-beetle-wswan" >> /tmp/bezelprojectinfo.txt
echo "Bandai WonderSwan Color                         lr-beetle-wswan" >> /tmp/bezelprojectinfo.txt
echo "ColecoVision                                    lr-bluemsx" >> /tmp/bezelprojectinfo.txt
echo "GCE Vectrex                                     lr-vecx" >> /tmp/bezelprojectinfo.txt
echo "MAME                                            lr-various" >> /tmp/bezelprojectinfo.txt
echo "Mattel Intellivision                            lr-freeintv" >> /tmp/bezelprojectinfo.txt
echo "MSX                                             lr-fmsx, lr-bluemsx" >> /tmp/bezelprojectinfo.txt
echo "MSX2                                            lr-fmsx, lr-bluemsx" >> /tmp/bezelprojectinfo.txt
echo "NEC PC Engine CD                                lr-beetle-pce-fast" >> /tmp/bezelprojectinfo.txt
echo "NEC PC Engine                                   lr-beetle-pce-fast" >> /tmp/bezelprojectinfo.txt
echo "NEC SuperGrafx                                  lr-beetle-supergrafx" >> /tmp/bezelprojectinfo.txt
echo "NEC TurboGrafx-CD                               lr-beetle-pce-fast" >> /tmp/bezelprojectinfo.txt
echo "NEC TurboGrafx-16                               lr-beetle-pce-fast" >> /tmp/bezelprojectinfo.txt
echo "Nintendo 64                                     lr-Mupen64plus" >> /tmp/bezelprojectinfo.txt
echo "Nintendo Entertainment System                   lr-fceumm, lr-nestopia" >> /tmp/bezelprojectinfo.txt
echo "Nintendo DS                                     lr-desmume, lr-desmume-2015" >> /tmp/bezelprojectinfo.txt
echo "Nintendo Famicom Disk System                    lr-fceumm, lr-nestopia" >> /tmp/bezelprojectinfo.txt
echo "Nintendo Famicom                                lr-fceumm, lr-nestopia" >> /tmp/bezelprojectinfo.txt
echo "Nintendo Game Boy                               lr-gambatte" >> /tmp/bezelprojectinfo.txt
echo "Nintendo Game Boy Color                         lr-gambatte" >> /tmp/bezelprojectinfo.txt
echo "Nintendo Game Boy Advance                       lr-mgba" >> /tmp/bezelprojectinfo.txt
echo "Nintendo Super Famicom                          lr-snes9x, lr-snes9x2010" >> /tmp/bezelprojectinfo.txt
echo "Nintendo Virtual Boy                            lr-beetle-vb" >> /tmp/bezelprojectinfo.txt
echo "Philips Videopac G7000 - Magnavox Odyssey2      lr-lr-o2em" >> /tmp/bezelprojectinfo.txt
echo "Sammy Atomiswave                                lr-flycast" >> /tmp/bezelprojectinfo.txt
echo "Sega 32X                                        lr-picodrive, lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega CD                                         lr-picodrive, lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega Dreamcast                                  lr-flycast" >> /tmp/bezelprojectinfo.txt
echo "Sega Game Gear                                  lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega Genesis                                    lr-picodrive, lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega Master System                              lr-picodrive, lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega Mega Drive                                 lr-picodrive, lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega Mega Drive Japan                           lr-picodrive, lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega Naomi                                      lr-flycast" >> /tmp/bezelprojectinfo.txt
echo "Sega Pico		                                  lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega SG-1000                                    lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega Saturn                                     lr-yabause, lr-beetle-saturn" >> /tmp/bezelprojectinfo.txt
echo "Sharp X68000                                    lr-px68k" >> /tmp/bezelprojectinfo.txt
echo "Sinclair ZX-81                                  lr-81" >> /tmp/bezelprojectinfo.txt
echo "Sinclair ZX Spectrum                            lr-fuse" >> /tmp/bezelprojectinfo.txt
echo "SNK Neo Geo Pocket                              lr-beetle-ngp" >> /tmp/bezelprojectinfo.txt
echo "SNK Neo Geo Pocket Color                        lr-beetle-ngp" >> /tmp/bezelprojectinfo.txt
echo "Sony PlayStation                                lr-pcsx-rearmed" >> /tmp/bezelprojectinfo.txt
echo "Super Nintendo Entertainment System             lr-snes9x, lr-snes9x2010" >> /tmp/bezelprojectinfo.txt
echo "" >> /tmp/bezelprojectinfo.txt

dialog --backtitle "The Bezel Project" \
--title "The Bezel Project - Bezel Pack Utility" \
--textbox /tmp/bezelprojectinfo.txt 30 110
}

# Main

main_menu

