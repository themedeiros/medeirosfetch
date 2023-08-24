host="$(cat /etc/hostname)"
os='Medeiros OS'
kernel="$(uname -sr)"
shell="$(basename "${SHELL}")"

## UI DETECTION

parse_rcs() {
	for f in "${@}"; do
		wm="$(tail -n 1 "${f}" 2> /dev/null | cut -d ' ' -f 2)"
		[ -n "${wm}" ] && echo "${wm}" && return
	done
}

rcwm="$(parse_rcs "${HOME}/.xinitrc" "${HOME}/.xsession")"

ui='unknown'
uitype='UI'
if [ -n "${DE}" ]; then
	ui="${DE}"
	uitype='DE'
elif [ -n "${WM}" ]; then
	ui="${WM}"
	uitype='WM'
elif [ -n "${XDG_CURRENT_DESKTOP}" ]; then
	ui="${XDG_CURRENT_DESKTOP}"
	uitype='DE'
elif [ -n "${DESKTOP_SESSION}" ]; then
	ui="${DESKTOP_SESSION}"
	uitype='DE'
elif [ -n "${rcwm}" ]; then
	ui="${rcwm}"
	uitype='WM'
elif [ -n "${XDG_SESSION_TYPE}" ]; then
	ui="${XDG_SESSION_TYPE}"
fi

ui="$(basename "${ui}")"

## DEFINE COLORS

if [ -x "$(command -v tput)" ]; then
	bold="$(tput bold)"
	red="$(tput setaf 5)"
	reset="$(tput sgr0)"
fi

lc="${reset}${bold}${red}"         # labels
nc="${reset}${bold}${red}"         # user and hostname
ic="${reset}"                       # info
c0="${reset}${red}"                # first color

## OUTPUT

cat <<EOF


${c0}	██████   ██████ 	${nc}${USER}${ic}@${nc}${host}${reset}
${c0}	░░██████ ██████  	${lc}OS:        ${ic}${os}${reset}
${c0}	░███░█████░███   	${lc}KERNEL:    ${ic}${kernel}${reset}
${c0}	░███░░███ ░███      ${lc}SHELL:     ${ic}${shell}${reset}
${c0}	░███ ░░░  ░███   	${lc}${uitype}:        ${ic}${ui}${reset}
${c0}	░███      ░███    
${c0}	█████     █████  	
${c0}	░░░░░     ░░░░░ 
                

EOF
