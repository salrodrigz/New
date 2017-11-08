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

source $MANAGEABLE_INSTALL_TOOL_DIR/common/mik_lib

#-------------------------------------------------------------------------------
# Collect media

echo "Collecting media"

mik_collect_media DATABASE_12c_LINUX_X86_64_1of2
mik_collect_media DATABASE_12c_LINUX_X86_64_2of2

echo "Media collected"

#--------------------------------------------------------------------------------
# TODO database pre-reqs

#--------------------------------------------------------------------------------
# Install Database

/usr/bin/unzip -o -q -d $DATABASE_MEDIA_DOWNLOAD_DIR ${MEDIA_LOC_DATABASE_12c_LINUX_X86_64_1of2}
/usr/bin/unzip -o -q -d $DATABASE_MEDIA_DOWNLOAD_DIR ${MEDIA_LOC_DATABASE_12c_LINUX_X86_64_2of2}

/bin/rm -f $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_HOST_OS_GROUP_NAME=$DATABASE_HOST_OS_GROUP_NAME >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo ORACLE_INVENTORY_DIR=$ORACLE_INVENTORY_DIR >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_ORACLE_HOME_DIR=$DATABASE_ORACLE_HOME_DIR >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_HOME_DIR=$DATABASE_HOME_DIR >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_GLOBAL_NAME=$DATABASE_GLOBAL_NAME >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_SID=$DATABASE_SID >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_SYS_USER_PASSWORD=$DATABASE_SYS_USER_PASSWORD >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_FILESYSTEM_DIR=$DATABASE_FILESYSTEM_DIR >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_HOST=$DATABASE_HOST >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_HOST_APPLICATIONS_HOME_DIR=$DATABASE_HOST_APPLICATIONS_HOME_DIR >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo APPLICATIONS_HOME_DIR=$APPLICATIONS_HOME_DIR >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
$JAVA_HOME/bin/java -cp $MANAGEABLE_INSTALL_TOOL_DIR/common template -map=$MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties -in=$MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/db_install.rsp.template > $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/db_install.rsp
$JAVA_HOME/bin/java -cp $MANAGEABLE_INSTALL_TOOL_DIR/common template -map=$MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties -in=$MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/database_cfg.sql.template > $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/database_cfg.sql
$JAVA_HOME/bin/java -cp $MANAGEABLE_INSTALL_TOOL_DIR/common template -map=$MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties -in=$MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/dbca.rsp.template > $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/dbca.rsp
/bin/rm -f $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties

RET_CODE=0
$DATABASE_MEDIA_DOWNLOAD_DIR/database/runInstaller -silent -responseFile $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/db_install.rsp -invPtrLoc $APPLICATIONS_HOME_DIR/oraInst.loc -waitforcompletion || RET_CODE=$?

/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' $DATABASE_ORACLE_HOME_DIR/root.sh"
/bin/bash -c "SUDO_ASKPASS=$MANAGEABLE_INSTALL_TOOL_DIR/common/askpass_sudo.sh ; export SUDO_ASKPASS ; $SUDO_PROGRAM -A -k -E -p '%H:%p' cp $APPLICATIONS_HOME_DIR/oraInst.loc /etc/"

#Configure database Listener
$DATABASE_ORACLE_HOME_DIR/bin/netca -silent -responsefile $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/netca.rsp

#configure database
$DATABASE_ORACLE_HOME_DIR/bin/dbca -silent -responseFile $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/dbca.rsp

echo "RET CODE is $RET_CODE"
# OUI return code of 6: The installation was successful after you proceeded by disregarding a few prerequisite checks or warnings.
# OUI return code of 253 (-3): The attempted installation encountered a prerequisite failure. Some of the required prerequisites have not been met. See the logs for details.
case "$RET_CODE" in
"")  ;;
0)  ;;
6)  ;;
253) ;;
*) false
  ;;
esac

/bin/bash -c "source $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/common/.bashrc_db ; echo -e \"alter profile default limit password_life_time unlimited failed_login_attempts unlimited;\nexit;\" | sqlplus ${DATABASE_SYS_USER_NAME}/${DATABASE_SYS_USER_PASSWORD}@${DATABASE_SID} as sysdba"

/bin/bash -c "source $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/common/.bashrc_db ; sqlplus $DATABASE_SYS_USER_NAME/$DATABASE_SYS_USER_PASSWORD@$DATABASE_SID as sysdba @$MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/database_cfg.sql"

/bin/bash -c "source ${MANAGEABLE_INSTALL_TOOL_DIR}/${DATABASE_SCRIPT_MODULE_NAME}/common/.bashrc_db ; sqlplus / as sysdba @${MANAGEABLE_INSTALL_TOOL_DIR}/${DATABASE_SCRIPT_MODULE_NAME}/database/shutdown.sql"
/bin/bash -c "source ${MANAGEABLE_INSTALL_TOOL_DIR}/${DATABASE_SCRIPT_MODULE_NAME}/common/.bashrc_db ; lsnrctl start ; sqlplus / as sysdba @${MANAGEABLE_INSTALL_TOOL_DIR}/${DATABASE_SCRIPT_MODULE_NAME}/database/startup.sql"
