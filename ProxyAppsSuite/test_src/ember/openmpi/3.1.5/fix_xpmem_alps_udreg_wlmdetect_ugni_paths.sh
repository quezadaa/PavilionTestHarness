#!/bin/bash

function usage {
    echo "
Usage:

fix_xpmem_alps_udreg_wlmdetect_paths.sh <path to openmpi installation>

where <path to openmpi installation> is a directory that contains the 'lib'
and 'share' directories associated with an openmpi installation.
"

}

# Check command line parameters
if [[ "$#" != 1 ]]; then
    echo "One command line parameter is needed"
    usage
    exit 1
fi

# grab the installation directory
install_dir=$1

# Check the directory we have been given
if [ ! -d $install_dir ]; then
    echo "$install_dir is not a valid directory"
    exit 1
fi

# Check for the share/openmpi directory
if [ ! -d $install_dir/share/openmpi ]; then
    echo "$install_dir does not contain a share/openmpi directory"
    exit 1
fi

# Check for the lib/pkgconfig directory
if [ ! -d $install_dir/lib/pkgconfig ]; then
    echo "$install_dir does not contain a lib/pkgconfig directory"
    exit 1
fi

for product in xpmem alps udreg wlm_detect ugni; do
    # go to the share/openmpi directory
    pushd $install_dir/share/openmpi 2>&1 >> /dev/null
    # grab only files (ignore symbolic links) named *-wrapper-data.txt
    for file in `find . -maxdepth 1 -type f -name "*-wrapper-data.txt"`; do
        # Use sed to replace version strings with "default" from those files
        sed --in-place "s|$product/[_-\.[:alnum:]]*/|$product/default/|g" $file
    done
    popd 2>&1 >> /dev/null

    # now go to the lib/pkgconfig directory
    pushd $install_dir/lib/pkgconfig 2>&1 >> /dev/null
    # grab only files (ignore symbolic links) named *.pc
    for file in `find . -maxdepth 1 -type f -name "*.pc"`; do
        # Use sed to replace version strings with "default"
        sed --in-place "s|$product/[_-\.[:alnum:]]*/|$product/default/|g" $file
    done
    popd 2>&1 >> /dev/null
done