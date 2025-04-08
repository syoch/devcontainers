st:
	[ -z "$(DEV)" ] && { echo "\$$DEV Not specified"; exit 1; } || :

	stty -F $(DEV) sane

	# 115200
	stty -F $(DEV) speed 2000000 \
		-echo

	stty raw opost -olcuc -echo; clear; socat stdio $(DEV); :
	stty sane