# =============================================================================
# BMRR_CHRONY_SERVER
# =============================================================================
CHRONY_SYSD_UNIT_TEMPLATE=assets/chronyd/chrony_server.service.in
CHRONY_SYSD_UNIT_OUT_DIR=/etc/systemd/system
CHRONY_SYSD_UNIT_NAME=chrony_server.service
CHRONY_SYSD_UNIT_OUT=${CHRONY_SYSD_UNIT_OUT_DIR}/${CHRONY_SYSD_UNIT_NAME}

CHRONY_ALL_TARGET=${CHRONY_SYSD_UNIT_OUT}

${CHRONY_SYSD_UNIT_OUT}: ${CHRONY_SYSD_UNIT_OUT_DIR}
${CHRONY_SYSD_UNIT_OUT}: ${CHRONY_SYSD_UNIT_TEMPLATE}
${CHRONY_SYSD_UNIT_OUT}: stop_chrony
${CHRONY_SYSD_UNIT_OUT}:
	BMRR_GCS_INSTALL_DIR=$(shell pwd) \
	< ${CHRONY_SYSD_UNIT_TEMPLATE} > ${CHRONY_SYSD_UNIT_OUT} envsubst

${CHRONY_SYSD_UNIT_OUT_DIR}:
	mkdir -p ${CHRONY_SYSD_UNIT_OUT_DIR}

stop_chrony:
	- systemctl stop ${CHRONY_SYSD_UNIT_NAME}

SYSD_ALL_UNITS=${CHRONY_SYSD_UNIT_NAME}

install: ${CHRONY_ALL_TARGET} docker_network
	systemctl daemon-reload
	- for unit in ${SYSD_ALL_UNITS}; do \
		systemctl start $$unit; \
	done

enable:
	for unit in ${SYSD_ALL_UNITS}; do \
		systemctl enable $$unit; \
	done

docker_network:
	- docker network rm bmrr_gcs
	docker network create bmrr_gcs
