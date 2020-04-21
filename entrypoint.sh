#!/bin/bash
set -e -x

# CLI arguments
PY_VERSIONS=$1
BUILD_REQUIREMENTS=$2
SYSTEM_PACKAGES=$3
PACKAGE_PATH=$4
PIP_WHEEL_ARGS=$5
UPLOAD_RELEASE_ASSET_URL=$6

if [ ! -z "$SYSTEM_PACKAGES" ]; then
    yum install -y ${SYSTEM_PACKAGES}  || { echo "Installing yum package(s) failed."; exit 1; }
fi

# Compile wheels
arrPY_VERSIONS=(${PY_VERSIONS// / })
for PY_VER in "${arrPY_VERSIONS[@]}"; do
    # Update pip
    /opt/python/"${PY_VER}"/bin/pip install --upgrade --no-cache-dir pip

    # Check if requirements were passed
    if [ ! -z "$BUILD_REQUIREMENTS" ]; then
        /opt/python/"${PY_VER}"/bin/pip install --no-cache-dir ${BUILD_REQUIREMENTS} || { echo "Installing requirements failed."; exit 1; }
    fi

    echo "Building wheels in /github/workspace/${PACKAGE_PATH}"
    ls /github/workspace
    ls /github/workspace/${PACKAGE_PATH}


    # Build wheels
    /opt/python/"${PY_VER}"/bin/pip wheel /github/workspace/"${PACKAGE_PATH}" -w /github/workspace/wheelhouse/ ${PIP_WHEEL_ARGS} || { echo "Building wheels failed."; exit 1; }
done

# Bundle external shared libraries into the wheels
for whl in /github/workspace/wheelhouse/*-linux*.whl; do
    auditwheel repair "$whl" --plat "${PLAT}" -w /github/workspace/wheelhouse/ || { echo "Repairing wheels failed."; auditwheel show "$whl"; exit 1; }
done

echo "Succesfully build wheels:"
ls /github/workspace/wheelhouse


# If an upload release asset url has been specificed, upload the assets
if [ ! -z "$UPLOAD_RELEASE_ASSET_URL" ]
then
  echo "Uploading wheels as release assets"
  for FILE in /github/workspace/wheelhouse; do
    echo "Uploading $FILE"
    curl \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Content-Type: $(file -b --mime-type $FILE)" \
      --data-binary @$FILE \
      "${UPLOAD_RELEASE_ASSET_URL}$(basename $FILE)"
  done
fi
