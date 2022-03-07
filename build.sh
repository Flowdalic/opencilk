#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

git submodule update --init --recursive --depth 3

readonly OPENCILK_PROJECT_DIR="${SCRIPT_DIR}/opencilk-project"
readonly CHEETAH_DIR="${SCRIPT_DIR}/cheetah"
readonly PRODUCTIVITY_TOOLS_DIR="${SCRIPT_DIR}/productivity-tools"

declare -A SYMLINKS
SYMLINKS["${SCRIPT_DIR}/opencilk-project/cheetah"]="${CHEETAH_DIR}"
SYMLINKS["${SCRIPT_DIR}/opencilk-project/cilktools"]="${PRODUCTIVITY_TOOLS_DIR}"

for LINK in "${!SYMLINKS[@]}"; do
	TARGET="${SYMLINKS[${LINK}]}"

	if [[ -e "${LINK}" ]]; then
		if [[ -L "${LINK}" ]]; then
			CURRENT_TARGET=$(readlink "${LINK}")
			if [[ "${CURRENT_TARGET}" == "${TARGET}" ]]; then
				# Link is correct, nothing to do.
				continue
			fi
		fi

		rm -rf "${LINK}"
	fi

	ln -rs "${TARGET}" "${LINK}"
done

BUILD_DIR="${SCRIPT_DIR}/build"

if [[ ! -d "${BUILD_DIR}" ]]; then
	mkdir "${BUILD_DIR}"
fi

cd "${BUILD_DIR}"

COMPONENTS="clang;compiler-rt"
RUNTIMES="cheetah;cilktools"

# TODO: Make this configurable. We want at least a debug build
# (assertions on, RelWithDebInfo) and a release build (assertions off,
# Release).
OPENCILK_ASSERTIONS="On"
BUILD_TYPE="RelWithDebInfo"

cmake \
	-G Ninja \
	-DLLVM_ENABLE_PROJECTS="${COMPONENTS}" \
    -DLLVM_ENABLE_RUNTIMES="${RUNTIMES}" \
    -DLLVM_TARGETS_TO_BUILD=host \
    -DLLVM_ENABLE_ASSERTIONS="${OPENCILK_ASSERTIONS}" \
    -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
    "${OPENCILK_PROJECT_DIR}/llvm"

ninja
