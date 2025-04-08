ib:
	[ -z "$(DEV1)" ] && { echo "\$$DEV1 Not specified"; exit 1; } || :
	[ -z "$(DEV2)" ] && { echo "\$$DEV2 Not specified"; exit 1; } || :

	stty -F $(DEV1) speed 19200 -inlcr igncr onlcr -echo
	stty -F $(DEV2) speed 19200 -inlcr igncr onlcr -echo

	socat -v $(DEV1),raw,echo=0 $(DEV2),raw,echo=0