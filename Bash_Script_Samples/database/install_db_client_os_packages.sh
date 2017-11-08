#!/bin/bash

# Copyright (c) 2012, 2015, Oracle and/or its affiliates. All rights reserved.

# The MIT License (MIT)

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.



trap "echo INSTALLATION FAILED" ERR
set -e
set -E
set -o pipefail

THIS_DIR=$( cd `/usr/bin/dirname ${BASH_SOURCE}` > /dev/null ; /bin/pwd )
if [ -z "$MIK_KNOBS_PATH" ]
then
  MIK_KNOBS_FILE=$THIS_DIR/../common/knobs
else
  MIK_KNOBS_FILE=$THIS_DIR/../../$MIK_KNOBS_PATH  
fi

source $MIK_KNOBS_FILE

if [ ! -z "${HTTP_PROXY_HOST}" ]
then
  if [ ! -z "${HTTP_PROXY_USER}" ]
  then
    export http_proxy="http://${HTTP_PROXY_USER}:${HTTP_PROXY_PASS}@${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}/"
  else
    export http_proxy="http://${HTTP_PROXY_HOST}:${HTTP_PROXY_PORT}/"
  fi
fi
if [ ! -z "${HTTPS_PROXY_HOST}" ]
then
  if [ ! -z "${HTTPS_PROXY_USER}" ]
  then
    export https_proxy="http://${HTTPS_PROXY_USER}:${HTTPS_PROXY_PASS}@${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}/"
  else
    export https_proxy="http://${HTTPS_PROXY_HOST}:${HTTPS_PROXY_PORT}/"
  fi
fi
if [ ! -z "${FTP_PROXY_HOST}" ]
then
  if [ ! -z "${FTP_PROXY_USER}" ]
  then
    export ftp_proxy="http://${FTP_PROXY_USER}:${FTP_PROXY_PASS}@${FTP_PROXY_HOST}:${FTP_PROXY_PORT}/"
  else
    export ftp_proxy="http://${FTP_PROXY_HOST}:${FTP_PROXY_PORT}/"
  fi
fi

/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install binutils"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install compat-libstdc++-33"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install compat-libstdc++-33"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install elfutils-libelf"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install elfutils-libelf-devel"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install gcc"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install gcc-c++"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install glibc"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install glibc-common"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install glibc-devel"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install glibc-headers"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install ksh"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install libaio"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install libaio-devel"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install libgcc"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install libstdc++"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install libstdc++-devel"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install make"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install sysstat"

/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install unixODBC"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install unixODBC-devel"

# Not defined in prereq list for client; needed for OHS

/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' /usr/bin/yum -y install compat-db"
