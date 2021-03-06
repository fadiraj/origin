#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

OS_ROOT=$(dirname "${BASH_SOURCE}")/..
source "${OS_ROOT}/hack/lib/init.sh"

# Go to the top of the tree.
cd "${OS_ROOT}"

if [[ -z "$(which protoc)" || "$(protoc --version)" != "libprotoc 3.0."* ]]; then
  echo "Generating protobuf requires protoc 3.0.0-beta1 or newer. Please download and"
  echo "install the platform appropriate Protobuf package for your OS: "
  echo
  echo "  https://github.com/google/protobuf/releases"
  echo
  exit 1
fi

if [[ -z "$(which goimports)" ]]; then
  echo "goimports is required to be present on your path in order to format the generated"
  echo "protobuf files"
  echo
  exit 1
fi

os::build::setup_env

"${OS_ROOT}/hack/build-go.sh" tools/genprotobuf vendor/k8s.io/kubernetes/cmd/libs/go2idl/go-to-protobuf/protoc-gen-gogo
genprotobuf="$( os::build::find-binary genprotobuf )"

if [[ -z "${genprotobuf}" ]]; then
	echo "It looks as if you don't have a compiled genprotobuf binary."
	echo
	echo "If you are running from a clone of the git repo, please run"
	echo "'./hack/build-go.sh tools/genprotobuf'."
	exit 1
fi

PATH="$( dirname "${genprotobuf}" ):${PATH}" ${genprotobuf} --output-base="${GOPATH}/src" "$@"