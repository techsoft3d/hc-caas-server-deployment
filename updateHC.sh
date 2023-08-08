#!/bin/bash
# public URL of HC tar file (e.g. dropbox, google drive, etc.)
URL="https://location.of.hoops.commmunicator.tar.file/HOOPS_Communicator_2023_SP2_Linux.tar.gz"

rm -r HOOPS_Communicator

# Download tar file
wget ${URL}
# Get the name of the downloaded file
file=$(basename ${URL})
# Extract the first directory from the tar file
first_dir=$(tar tf ${file} | grep / | awk -F/ '{print $1}' | uniq | head -n 1)
# Extract that directory
tar xvf ${file} ${first_dir}
mv ${first_dir} HOOPS_Communicator
rm ${file}