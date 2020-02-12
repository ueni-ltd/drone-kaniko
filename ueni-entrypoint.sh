#!/busybox/sh

set -euxo pipefail

export PLUGIN_REPO=${PLUGIN_REPO:-${DRONE_REPO_NAME}}
export PLUGIN_TAGS=${PLUGIN_TAGS:-${DRONE_BRANCH}-${DRONE_COMMIT_SHA}}

if [ -e ${DRONE_WORKSPACE_BASE}/.git ]; then
	rm -rf ${DRONE_WORKSPACE_BASE}/.git
fi

set +x
if [ "${PLUGIN_DEBUG-}" = "true" ]; then
	echo "Debug mode on"
	set -x
	uname -a
	pwd
	env
	cat /proc/mounts
	/busybox/sh -x /kaniko/plugin.sh
else
	/kaniko/plugin.sh
fi
