#!/busybox/sh

set -euxo pipefail

export PLUGIN_REPO=${PLUGIN_REPO:-${DRONE_REPO_NAME}}
export PLUGIN_TAGS=${PLUGIN_TAGS:-${DRONE_BRANCH}-${DRONE_COMMIT_SHA}}

if [ -e .git ]; then
	rm -rf .git*
fi

set +x
if [ "${PLUGIN_DEBUG-}" = "true" ]; then
	echo "Debug mode on"
	set -x
	uname -a
	pwd
	env
fi

set -x
/kaniko/plugin.sh
