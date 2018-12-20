#/bin/bash

BROKEN_LINKS_FILE=/tmp/vmwb-broken-links.txt
DEPENDENCIES_FILE=/tmp/vmwb-dependencies.txt

rm -f ${BROKEN_LINKS_FILE}
rm -f ${DEPENDENCIES_FILE}

# find all of the symlinks that are broken (because toolchain is not mounted) and direct those to a file
find . -type l -xtype l -exec file -b {} \; > ${BROKEN_LINKS_FILE}

#now rip out all the extraneous file and path info and leave only the directory in /build/toolchain that has what we need
# also pipe through sort and remove duplicates to get a minimal list
sed -rn "s/^.*build\\/toolchain\\/([a-zA-Z0-9]+)\\/([a-zA-Z0-9_\.\-]+).*/\1\\/\2/p" ${BROKEN_LINKS_FILE} | sort -u > ${DEPENDENCIES_FILE}

export DEPENDENCIES=`cat $DEPENDENCIES_FILE`
echo "${DEPENDENCIES}"

