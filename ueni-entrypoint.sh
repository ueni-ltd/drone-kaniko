#!/busybox/sh

set -euxo pipefail

export PLUGIN_REPO=${PLUGIN_REPO:-${DRONE_REPO_NAME}}
export PLUGIN_TAGS=${PLUGIN_TAGS:-${DRONE_BRANCH}-${DRONE_COMMIT_SHA}}

if [ "${PLUGIN_DEBUG-}" = "true" ]; then
	echo "Debug mode on"
	uname -a
	docker -v
	pwd
	env
fi

/kaniko/plugin.sh