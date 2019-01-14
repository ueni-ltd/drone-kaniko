#!/busybox/sh

set -euo pipefail

export PATH=$PATH:/kaniko/
echo '{"credsStore": "ecr-login"}' > /kaniko/.docker/config.json

DOCKERFILE=${PLUGIN_DOCKERFILE:-Dockerfile}
CONTEXT=${PLUGIN_CONTEXT:-$PWD}
LOG=${PLUGIN_LOG:-info}
case "${PLUGIN_CACHE:-}" in
  true) CACHE="true" ;;
     *) CACHE="false" ;;
esac

if [[ -n "${PLUGIN_BUILD_ARGS:-}" ]]; then
    BUILD_ARGS=$(echo "${PLUGIN_BUILD_ARGS}" | tr ',' '\n' | while read build_arg; do echo "--build-arg=${build_arg}"; done)
fi

if [[ -n "${PLUGIN_TAGS:-}" ]]; then
    DESTINATIONS=$(echo "${PLUGIN_TAGS}" | tr ',' '\n' | while read tag; do echo "--destination=${PLUGIN_IMAGE_NAME}:${tag} "; done)
else
    DESTINATIONS="--destination=${PLUGIN_IMAGE_NAME}:${DRONE_COMMIT_SHA}"
fi

/kaniko/executor -v ${LOG} \
    --context=${CONTEXT} \
    --dockerfile=${DOCKERFILE} \
    --cache=${CACHE} \
    ${DESTINATIONS} \
    ${BUILD_ARGS:-}
