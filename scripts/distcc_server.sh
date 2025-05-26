#!/usr/bin/env bash

CMD="distccd --daemon --no-detach --user nobody --allow 0.0.0.0/0 --log-stderr --stats"


if [ -z "${DOCKER_IAMGE}" ] || [ -z "$(docker images -q "${DOCKER_IAMGE}" 2> /dev/null)" ]; then
	printf "ERROR: docker image not found, DOCKER_IAMGE=%s\n" "${DOCKER_IAMGE}"
	exit 1
fi

# docker run -d --rm --name "distcc-server" --network host ${DOCKER_IAMGE} bash -c "${CMD}"
docker run -d --rm --name "distcc-server" ${DOCKER_IAMGE} bash -c "${CMD}"
