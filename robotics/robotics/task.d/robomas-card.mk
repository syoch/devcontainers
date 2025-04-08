US_PJ_F3 = build/NUCLEO_F303K8/src/F303K8-HAL-build

drmc_t_1: build
	FLASH_ARGS="--serial 0670FF373146363143202623" ninja -C $(US_PJ_F3) upload_25-robomas

drmc_t_2: build
	FLASH_ARGS="--serial 0671FF373146363143203322" ninja -C $(US_PJ_F3) upload_26-robomas-agent-1

drmc_t_3: build
	: FLASH_ARGS="--serial 0667FF373146363143225029" ninja -C $(US_PJ_F3) upload_26-robomas-agent-2

drmc_t: drmc_t_2 drmc_t_3 drmc_t_1
