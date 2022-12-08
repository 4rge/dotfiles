#! /usr/bin/env bash

set -o pipefail ; set -o errtrace; shopt -s huponexit; trap 'printf $?:' ERR ## debugging
shopt -s dotglob ; shopt -s globstar ; shopt -s nullglob; shopt -s extglob ## globbing
shopt -s cmdhist ## history
shopt -s autocd; shopt -s cdable_vars; shopt -s cdspell; shopt -s direxpand ## navigation
shopt -s expand_aliases

function sud0() {
pkg="apt"; src="search"; upd="update"; upg="upgrade"; atc="autoclean"; rmv="autoremove"; ins="install"; prg="purge"
#pkg="pacman"; src="-Ss"; upd="-Syy"; upg="-Syu"; atc="-Sc"; rmv="-R `pacman -Qtdq`"; ins="-S"; prg="-R"
case $1 in
    s) $pkg $src $2;;
    i) sudo $pkg $upd && sudo $pkg $ins $2;;
    p) sudo $pkg $prg $2 && sudo $pkg $rmv -y;;
    u) for out in $upd $upg $atc $rmv; do sudo $pkg $out ; done ; clear;;
    t) sudo journalctl --flush --rotate 2> /dev/null; cd /var/log && sudo truncate -s 0 * 2> /dev/null; cd ~ ; rm -rf ~/.local/share/recently-used.xbel; rm -rf ~/.wget-hsts ; trash-empty ; clear; trap `history -c` EXIT;;
    *) sudo $@;;
    esac
}

function syst() {
case $1 in
    c) bleachbit --clean bash.history deepscan.backup deepscan.ds_store deepscan.thumbs_db deepscan.tmp deepscan.vim_swap_root deepscan.vim_swap_user gnome.run gnome.search_history journald.clean system.cache system.clipboard system.desktop_entry system.recent_documents system.rotated_logs system.tmp system.trash thumbnails.cache 2> /dev/null | zenity --progress --auto-close --pulsate --no-cancel --text="Cleaning"; trap 'sud0 t' EXIT; clear;;
    i) zenity --notification --text=`curl -s http://ipecho.net/plain; echo` 2> /dev/null;;
    m) zenity --notification --text="$(ip -o link show "wlo1" 2> /dev/null | awk '{ print toupper(gensub(/.*link\/[^ ]* ([[:alnum:]:]*).*/,"\\1", 1)); }')" 2> /dev/null;;
    a) sudo cat /proc/net/arp;;
    s) dd if=/dev/zero of=/tmp/output.img bs=8k count=256k conv=fdatasync; rm -rf /tmp/output.img;;
    *) uptime;;
    esac
}


function cust() {
case $1 in
    p) rsync -ah --info=progress2 $2 $3;;
    l) echo "Total Files : `find . -type f | wc -l`" && du -hd1 * | sort -hr;;
    b) brightnessctl set "$(VALUE=`zenity --scale --text="Set brightness." --min-value=50 --value=125 --max-value=255 --step=5`; echo $VALUE)";;
    *) clear;;
    esac
} 

function h4sh() {
case $1 in
    sha3) argx=$2; for ((i = 0 ; i < 99 ; i++)); do argx="`python3 << EOF
import sys, hashlib; s = hashlib.sha3_512(); s.update(bytes("$argx", 'utf-8')); print(s.hexdigest())
EOF`"; done; echo $argx;;
    rename) cp $2 `python3 << EOF
import sys, hashlib; s = hashlib.sha3_512(); s.update(bytes("$argx", 'utf-8')); print(s.hexdigest())
EOF`;;
    *) printf "Options are sha3 or rename";;
    esac
}
function d0k3r() {
case $1 in
    b) sudo docker build -t $2 .;;
    r) case $2 in
        s) sudo docker restart $3;;
        *) sudo docker run -d -p 80:80 $2;;
        esac;;
    s) sudo docker stop $2;;
    -) case $2 in
        a) sudo docker rm -f $(docker ps -qa);;
        *) sudo docker rm $2;;
        esac;;
    +) sudo docker save -o $2 $3;;
    e) sudo docker exec -ti $2 sh;;
    *) sudo docker ps -a;;
    esac
}
alias d='d0k3r'
alias h='h4sh'
alias c='cust'
alias s='sud0'
alias sys='syst'
