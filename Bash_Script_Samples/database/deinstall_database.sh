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



echo "Reading configuration"

THIS_DIR=$( cd `/usr/bin/dirname ${BASH_SOURCE}` > /dev/null ; /bin/pwd )
if [ -z "$MIK_KNOBS_PATH" ]
then
  MIK_KNOBS_FILE=$THIS_DIR/../common/knobs
else
  MIK_KNOBS_FILE=$THIS_DIR/../../$MIK_KNOBS_PATH  
fi

source $MIK_KNOBS_FILE

echo "Configuration read"

#--------------------------------------------------------------------------------
# Deinstall Database

/bin/rm -f $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_HOST_NAME=$DATABASE_HOST_NAME >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_HOME_DIR=$DATABASE_HOME_DIR >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_SID=$DATABASE_SID >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_DATA_DIR=$DATABASE_DATA_DIR >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_ORACLE_HOME_DIR=$DATABASE_ORACLE_HOME_DIR >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo ORACLE_INVENTORY_DIR=$ORACLE_INVENTORY_DIR >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
echo DATABASE_SID_UPPERCASE=$DATABASE_SID_UPPERCASE >> $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties
$JAVA_HOME/bin/java -cp $MANAGEABLE_INSTALL_TOOL_DIR/common template -map=$MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties -in=$MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/deinstall_database.rsp.template > $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/deinstall_database.rsp
/bin/rm -f $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/map.properties

$DATABASE_ORACLE_HOME_DIR/deinstall/deinstall -silent -paramfile $MANAGEABLE_INSTALL_TOOL_DIR/${DATABASE_SCRIPT_MODULE_NAME}/database/deinstall_database.rsp
#$DATABASE_ORACLE_HOME_DIR/deinstall/deinstall -checkonly 
