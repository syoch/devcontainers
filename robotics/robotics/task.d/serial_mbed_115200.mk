st1:
	[ -z "$(DEV)" ] && { echo "\$$DEV Not specified"; exit 1; } || :

	stty -F $(DEV) sane

	stty -F $(DEV) speed 115200 \
		-echo

	stty raw opost -olcuc -echo; clear; socat stdio $(DEV); :
	stty sane