BEGIN --
-- Header: SRM/src/deliverables/usersdothemes.sql /cgbuuim_7.2.0/5 2011/09/20 14:25:37 csinavar Exp 
--
-- usersdothemes.sql
--
-- Copyright (c) 2010, 2012, Oracle and/or its affiliates. 
-- All rights reserved. 
--
--    NAME
--      usersdothemes.sql - populate uim themes metadata
--
--    DESCRIPTION
--      UIM Default theme metadata for MDSYS
--
--    NOTES
--      <other useful comments, qualifications, etc.>
--
--    MODIFIED   (MM/DD/YY)
--

-- ECHO ON
-- FEEDBACK 1
-- NUMWIDTH 10
-- LINESIZE 80
-- TRIMSPOOL ON
-- TAB OFF
-- PAGESIZE 100

delete from user_sdo_themes where NAME IN ('EDGE', 'PIPE', 'PHYSICAL_PORT', 'MULTINODEPLACE', 'EQUIPMENT', 'LOGICAL_DEVICE', 'CUSTOM_NETWORK_ADDRESS', 'PLACE', 'NETWORK', 'PHYSICAL_DEVICE', 'CUSTOM_OBJECT', 'DEVICE_INTERFACE', 'PARTY');

insert into user_sdo_themes (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) values ('EDGE','Base Network Edge Theme','TOPOLOGYEDGE','GEOMETRY','<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="KEYCOLUMN">
  <hidden_info>
    <field column="EDGE_ID" name="Edge Id"/>
    <field column="EDGE_NAME" name="Edge Name"/>
  </hidden_info>
  <rule>
    <features asis="true" style="L.NETWORK_EDGE"> SELECT NE.ID AS EDGE_ID, NE.NAME AS EDGE_NAME, NE.ENTITYCLASS || ''-'' || NE.ENTITYID AS KEYCOLUMN, TE.GEOMETRY AS GEOMETRY FROM TOPOLOGYEDGE TE, TOPEDGEASSOCIATION TEA, NETWORKEDGE NE WHERE TE.BUSINESSOBJECTTYPEID = ''7'' AND TEA.TOPOLOGYEDGE = TE.ENTITYID AND TEA.REFERENCEID = NE.ENTITYID AND TE.GEOMETRY IS NOT NULL AND NE.EDGEASSOCTYPE = ''EDGE'' AND NE.NETWORK = :1 </features>
    <label column="EDGE_NAME" style="T.TEXT"> 1 </label>
  </rule>
</styling_rules>');

insert into user_sdo_themes (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) values ('PIPE','Base Pipe Theme','TOPOLOGYEDGE','GEOMETRY','<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="KEYCOLUMN">
  <hidden_info>
    <field column="EDGE_ID" name="Edge Id"/>
    <field column="EDGE_NAME" name="Edge Name"/>
    <field column="PIPE_ID" name="Pipe Id"/>
    <field column="PIPE_NAME" name="Pipe Name"/>
  </hidden_info>
  <rule>
    <features asis="true" style="L.PIPE"> SELECT NE.ID AS EDGE_ID, NE.NAME AS EDGE_NAME, PI.ID AS PIPE_ID, PI.NAME AS PIPE_NAME, NE.ENTITYCLASS || ''-'' || NE.ENTITYID AS KEYCOLUMN, TE.GEOMETRY AS GEOMETRY FROM TOPOLOGYEDGE TE, TOPEDGEASSOCIATION TEA, NETWORKEDGE NE, NETEDGE_PIPEREL NEP, PIPE PI WHERE TE.BUSINESSOBJECTTYPEID = ''7'' AND TEA.TOPOLOGYEDGE = TE.ENTITYID AND TEA.REFERENCEID = NE.ENTITYID AND TE.GEOMETRY IS NOT NULL AND NE.EDGEASSOCTYPE = ''PIPE'' AND NE.ENTITYID = NEP.NETWORKEDGE AND NEP.PIPE = PI.ENTITYID AND NE.NETWORK = :1 </features>
    <label column="EDGE_NAME" style="T.TEXT"> 1 </label>
  </rule>
</styling_rules>');

insert into user_sdo_themes (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) values ('PHYSICAL_PORT','Base Physical Port Theme','TOPOLOGYNODE','GEOMETRY','<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="KEYCOLUMN">
  <hidden_info>
    <field column="NODE_ID" name="Node Id"/>
    <field column="RES_ID" name="Physical Port Id"/>
    <field column="RES_NAME" name="Physical Port Name"/>
    <field column="PLACE_ID" name="Place Id"/>
    <field column="PLACE_NAME" name="Place Name"/>
    <field column="LATITUDE" name="Latitude"/>
    <field column="LONGITUDE" name="Longitude"/>
  </hidden_info>
  <rule>
    <features asis="true" style="M.PHYSICAL_PORT"> SELECT NN.ID AS NODE_ID, RES.ENTITYCLASS || ''-'' || RES.ENTITYID || ''::'' || PL.ENTITYCLASS || ''-'' || PL.ENTITYID AS KEYCOLUMN, NN.NAME AS NODE_NAME, PL.ID AS PLACE_ID, PL.NAME AS PLACE_NAME, ROUND(T.LATITUDE,6) AS LATITUDE, ROUND(T.LONGITUDE,6) AS LONGITUDE, RES.ID AS RES_ID, RES.NAME AS RES_NAME, T.GEOMETRY AS GEOMETRY FROM TOPOLOGYNODE T, TOPNODEASSOCIATION TNA, NETWORKNODE NN, NETWORK N, PLACE_NETWORKNODEREL PLREL, GEOGRAPHICPLACE PL ,NETNODE_PHYPORTREL NNREL, PHYSICALPORT RES WHERE T.BUSINESSOBJECTTYPEID = ''6'' AND TNA.TOPOLOGYNODE = T.ENTITYID AND TNA.REFERENCEID = NN.ENTITYID AND NN.NETWORK = N.ENTITYID AND PLREL.NETWORKNODE(+) = NN.ENTITYID AND PLREL.GEOGRAPHICPLACE = PL.ENTITYID(+) AND T.GEOMETRY IS NOT NULL AND NNREL.NETWORKNODE = NN.ENTITYID AND NNREL.PHYSICALPORT = RES.ENTITYID AND NN.NODETYPE = ''PHYSICAL_PORT'' AND N.ENTITYID = :1 </features>
    <label column="NODE_NAME" style="T.TEXT"> 1 </label>
  </rule>
</styling_rules>');

insert into user_sdo_themes (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) values ('MULTINODEPLACE','Multiple Nodes at a Place Theme','TOPOLOGYNODE','GEOMETRY','<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="KEYCOLUMN">
  <hidden_info>
    <field column="NODE_ID" name="Node Id"/>
    <field column="PLACE_ID" name="Place Id"/>
    <field column="PLACE_NAME" name="Place Name"/>
    <field column="LATITUDE" name="Latitude"/>
    <field column="LONGITUDE" name="Longitude"/>
  </hidden_info>
  <rule>
    <features asis="true" style="M.MULTINODEPLACE"> SELECT ''*'' AS NODE_ID, PL.ENTITYCLASS || ''-'' || PL.ENTITYID || '':: MULTINODE'' AS KEYCOLUMN, ''Multiple Nodes'' AS NODE_NAME, PL.ID AS PLACE_ID, PL.NAME AS PLACE_NAME, ROUND(T.LATITUDE,6) AS LATITUDE, ROUND(T.LONGITUDE,6) AS LONGITUDE, T.GEOMETRY AS GEOMETRY FROM TOPOLOGYNODE T, TOPNODEASSOCIATION TNA, NETWORKNODE NN, NETWORK N, PLACE_NETWORKNODEREL PLREL, GEOGRAPHICPLACE PL WHERE T.BUSINESSOBJECTTYPEID = ''6'' AND TNA.TOPOLOGYNODE = T.ENTITYID AND TNA.REFERENCEID = NN.ENTITYID AND NN.NETWORK = N.ENTITYID AND PLREL.NETWORKNODE(+) = NN.ENTITYID AND PLREL.GEOGRAPHICPLACE = PL.ENTITYID(+) AND T.GEOMETRY IS NOT NULL AND PL.ID IN (:1) AND NN.NETWORK = :2 AND ROWNUM = 1
 </features>
    <label column="NODE_NAME" style="T.TEXT"> 1 </label>
  </rule>
</styling_rules>');

insert into user_sdo_themes (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) values ('EQUIPMENT','Base Equipment Theme','TOPOLOGYNODE','GEOMETRY','<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="KEYCOLUMN">
  <hidden_info>
    <field column="NODE_ID" name="Node Id"/>
    <field column="RES_ID" name="Equipment Id"/>
    <field column="RES_NAME" name="Equipment Name"/>
    <field column="PLACE_ID" name="Place Id"/>
    <field column="PLACE_NAME" name="Place Name"/>
    <field column="LATITUDE" name="Latitude"/>
    <field column="LONGITUDE" name="Longitude"/>
  </hidden_info>
  <rule>
    <features asis="true" style="M.EQUIPMENT"> SELECT NN.ID AS NODE_ID, RES.ENTITYCLASS || ''-'' || RES.ENTITYID || ''::'' || PL.ENTITYCLASS || ''-'' || PL.ENTITYID AS KEYCOLUMN, NN.NAME AS NODE_NAME, PL.ID AS PLACE_ID, PL.NAME AS PLACE_NAME, ROUND(T.LATITUDE,6) AS LATITUDE, ROUND(T.LONGITUDE,6) AS LONGITUDE, RES.ID AS RES_ID, RES.NAME AS RES_NAME, T.GEOMETRY AS GEOMETRY FROM TOPOLOGYNODE T, TOPNODEASSOCIATION TNA, NETWORKNODE NN, NETWORK N, PLACE_NETWORKNODEREL PLREL, GEOGRAPHICPLACE PL ,NETNODE_EQUIPREL NNREL, EQUIPMENT RES WHERE T.BUSINESSOBJECTTYPEID = ''6'' AND TNA.TOPOLOGYNODE = T.ENTITYID AND TNA.REFERENCEID = NN.ENTITYID AND NN.NETWORK = N.ENTITYID AND PLREL.NETWORKNODE(+) = NN.ENTITYID AND PLREL.GEOGRAPHICPLACE = PL.ENTITYID(+) AND T.GEOMETRY IS NOT NULL AND NNREL.NETWORKNODE = NN.ENTITYID AND NNREL.EQUIPMENT = RES.ENTITYID AND NN.NODETYPE = ''EQUIPMENT'' AND N.ENTITYID = :1 </features>
    <label column="NODE_NAME" style="T.TEXT"> 1 </label>
  </rule>
</styling_rules>');

insert into user_sdo_themes (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) values ('LOGICAL_DEVICE','Base Logical Device Theme','TOPOLOGYNODE','GEOMETRY','<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="KEYCOLUMN">
  <hidden_info>
    <field column="NODE_ID" name="Node Id"/>
    <field column="RES_ID" name="Logical Device Id"/>
    <field column="RES_NAME" name="Logical Device Name"/>
    <field column="PLACE_ID" name="Place Id"/>
    <field column="PLACE_NAME" name="Place Name"/>
    <field column="LATITUDE" name="Latitude"/>
    <field column="LONGITUDE" name="Longitude"/>
  </hidden_info>
  <rule>
    <features asis="true" style="M.LOGICAL_DEVICE"> SELECT NN.ID AS NODE_ID, RES.ENTITYCLASS || ''-'' || RES.ENTITYID || ''::'' || PL.ENTITYCLASS || ''-'' || PL.ENTITYID AS KEYCOLUMN, NN.NAME AS NODE_NAME, PL.ID AS PLACE_ID, PL.NAME AS PLACE_NAME, ROUND(T.LATITUDE,6) AS LATITUDE, ROUND(T.LONGITUDE,6) AS LONGITUDE, RES.ID AS RES_ID, RES.NAME AS RES_NAME, T.GEOMETRY AS GEOMETRY FROM TOPOLOGYNODE T, TOPNODEASSOCIATION TNA, NETWORKNODE NN, NETWORK N, PLACE_NETWORKNODEREL PLREL, GEOGRAPHICPLACE PL ,NETNODE_LOGDEVREL NNREL, LOGICALDEVICE RES WHERE T.BUSINESSOBJECTTYPEID = ''6'' AND TNA.TOPOLOGYNODE = T.ENTITYID AND TNA.REFERENCEID = NN.ENTITYID AND NN.NETWORK = N.ENTITYID AND PLREL.NETWORKNODE(+) = NN.ENTITYID AND PLREL.GEOGRAPHICPLACE = PL.ENTITYID(+) AND T.GEOMETRY IS NOT NULL AND NNREL.NETWORKNODE = NN.ENTITYID AND NNREL.LOGICALDEVICE = RES.ENTITYID AND NN.NODETYPE = ''LOGICAL_DEVICE'' AND N.ENTITYID = :1 </features>
    <label column="NODE_NAME" style="T.TEXT"> 1 </label>
  </rule>
</styling_rules>');

insert into user_sdo_themes (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) values ('CUSTOM_NETWORK_ADDRESS','Base Custom Network Address Theme','TOPOLOGYNODE','GEOMETRY','<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="KEYCOLUMN">
  <hidden_info>
    <field column="NODE_ID" name="Node Id"/>
    <field column="RES_ID" name="Custom Network Address Id"/>
    <field column="RES_NAME" name="Custom Network Address Name"/>
    <field column="PLACE_ID" name="Place Id"/>
    <field column="PLACE_NAME" name="Place Name"/>
    <field column="LATITUDE" name="Latitude"/>
    <field column="LONGITUDE" name="Longitude"/>
  </hidden_info>
  <rule>
    <features asis="true" style="M.CUSTOM_NETWORK_ADDRESS"> SELECT NN.ID AS NODE_ID, RES.ENTITYCLASS || ''-'' || RES.ENTITYID || ''::'' || PL.ENTITYCLASS || ''-'' || PL.ENTITYID AS KEYCOLUMN, NN.NAME AS NODE_NAME, PL.ID AS PLACE_ID, PL.NAME AS PLACE_NAME, ROUND(T.LATITUDE,6) AS LATITUDE, ROUND(T.LONGITUDE,6) AS LONGITUDE, RES.ID AS RES_ID, RES.NAME AS RES_NAME, T.GEOMETRY AS GEOMETRY FROM TOPOLOGYNODE T, TOPNODEASSOCIATION TNA, NETWORKNODE NN, NETWORK N, PLACE_NETWORKNODEREL PLREL, GEOGRAPHICPLACE PL ,NETNODE_CUSTNETWORKADDRESSREL NNREL, CUSTOMNETWORKADDRESS RES WHERE T.BUSINESSOBJECTTYPEID = ''6'' AND TNA.TOPOLOGYNODE = T.ENTITYID AND TNA.REFERENCEID = NN.ENTITYID AND NN.NETWORK = N.ENTITYID AND PLREL.NETWORKNODE(+) = NN.ENTITYID AND PLREL.GEOGRAPHICPLACE = PL.ENTITYID(+) AND T.GEOMETRY IS NOT NULL AND NNREL.NETWORKNODE = NN.ENTITYID AND NNREL.CUSTOMNETWORKADDRESS = RES.ENTITYID AND NN.NODETYPE = ''CUSTOM_NETWORK_ADDRESS'' AND N.ENTITYID = :1 </features>
    <label column="NODE_NAME" style="T.TEXT"> 1 </label>
  </rule>
</styling_rules>');

insert into user_sdo_themes (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) values ('PLACE','Base Place Theme','TOPOLOGYNODE','GEOMETRY','<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="KEYCOLUMN">
  <hidden_info>
    <field column="NODE_ID" name="Node Id"/>
    <field column="PLACE_ID" name="Place Id"/>
    <field column="PLACE_NAME" name="Place Name"/>
    <field column="LATITUDE" name="Latitude"/>
    <field column="LONGITUDE" name="Longitude"/>
  </hidden_info>
  <rule>
    <features asis="true" style="M.PLACE"> SELECT NN.ID AS NODE_ID, PL.ENTITYCLASS || ''-'' || PL.ENTITYID AS KEYCOLUMN, NN.NAME AS NODE_NAME, PL.ID AS PLACE_ID, PL.NAME AS PLACE_NAME, ROUND(T.LATITUDE,6) AS LATITUDE, ROUND(T.LONGITUDE,6) AS LONGITUDE, T.GEOMETRY AS GEOMETRY FROM TOPOLOGYNODE T, TOPNODEASSOCIATION TNA, NETWORKNODE NN, NETWORK N, PLACE_NETWORKNODEREL PLREL, GEOGRAPHICPLACE PL WHERE T.BUSINESSOBJECTTYPEID = ''6'' AND TNA.TOPOLOGYNODE = T.ENTITYID AND TNA.REFERENCEID = NN.ENTITYID AND NN.NETWORK = N.ENTITYID AND PLREL.NETWORKNODE(+) = NN.ENTITYID AND PLREL.GEOGRAPHICPLACE = PL.ENTITYID(+) AND T.GEOMETRY IS NOT NULL AND NN.NODETYPE = ''PLACE'' AND N.ENTITYID = :1  </features>
    <label column="NODE_NAME" style="T.TEXT"> 1 </label>
  </rule>
</styling_rules>');

insert into user_sdo_themes (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) values ('NETWORK','Base Network Theme','TOPOLOGYNODE','GEOMETRY','<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="KEYCOLUMN">
  <hidden_info>
    <field column="NODE_ID" name="Node Id"/>
    <field column="RES_ID" name="Network Id"/>
    <field column="RES_NAME" name="Network Name"/>
    <field column="PLACE_ID" name="Place Id"/>
    <field column="PLACE_NAME" name="Place Name"/>
    <field column="LATITUDE" name="Latitude"/>
    <field column="LONGITUDE" name="Longitude"/>
  </hidden_info>
  <rule>
    <features asis="true" style="M.NETWORK"> SELECT NN.ID AS NODE_ID, RES.ENTITYCLASS || ''-'' || RES.ENTITYID || ''::'' || PL.ENTITYCLASS || ''-'' || PL.ENTITYID AS KEYCOLUMN, NN.NAME AS NODE_NAME, PL.ID AS PLACE_ID, PL.NAME AS PLACE_NAME, ROUND(T.LATITUDE,6) AS LATITUDE, ROUND(T.LONGITUDE,6) AS LONGITUDE, RES.ID AS RES_ID, RES.NAME AS RES_NAME, T.GEOMETRY AS GEOMETRY FROM TOPOLOGYNODE T, TOPNODEASSOCIATION TNA, NETWORKNODE NN, NETWORK N, PLACE_NETWORKNODEREL PLREL, GEOGRAPHICPLACE PL ,NETNODE_NETWORKREL NNREL, NETWORK RES WHERE T.BUSINESSOBJECTTYPEID = ''6'' AND TNA.TOPOLOGYNODE = T.ENTITYID AND TNA.REFERENCEID = NN.ENTITYID AND NN.NETWORK = N.ENTITYID AND PLREL.NETWORKNODE(+) = NN.ENTITYID AND PLREL.GEOGRAPHICPLACE = PL.ENTITYID(+) AND T.GEOMETRY IS NOT NULL AND NNREL.NETWORKNODE = NN.ENTITYID AND NNREL.NETWORK = RES.ENTITYID AND NN.NODETYPE = ''NETWORK'' AND NN.NETWORK = :1 </features>
    <label column="NODE_NAME" style="T.TEXT"> 1 </label>
  </rule>
</styling_rules>');

insert into user_sdo_themes (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) values ('PHYSICAL_DEVICE','Base Physical Device Theme','TOPOLOGYNODE','GEOMETRY','<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="KEYCOLUMN">
  <hidden_info>
    <field column="NODE_ID" name="Node Id"/>
    <field column="RES_ID" name="Physical Device Id"/>
    <field column="RES_NAME" name="Physical Device Name"/>
    <field column="PLACE_ID" name="Place Id"/>
    <field column="PLACE_NAME" name="Place Name"/>
    <field column="LATITUDE" name="Latitude"/>
    <field column="LONGITUDE" name="Longitude"/>
  </hidden_info>
  <rule>
    <features asis="true" style="M.PHYSICAL_DEVICE"> SELECT NN.ID AS NODE_ID, RES.ENTITYCLASS || ''-'' || RES.ENTITYID || ''::'' || PL.ENTITYCLASS || ''-'' || PL.ENTITYID AS KEYCOLUMN, NN.NAME AS NODE_NAME, PL.ID AS PLACE_ID, PL.NAME AS PLACE_NAME, ROUND(T.LATITUDE,6) AS LATITUDE, ROUND(T.LONGITUDE,6) AS LONGITUDE, RES.ID AS RES_ID, RES.NAME AS RES_NAME, T.GEOMETRY AS GEOMETRY FROM TOPOLOGYNODE T, TOPNODEASSOCIATION TNA, NETWORKNODE NN, NETWORK N, PLACE_NETWORKNODEREL PLREL, GEOGRAPHICPLACE PL ,NETNODE_PHYDEVREL NNREL, PHYSICALDEVICE RES WHERE T.BUSINESSOBJECTTYPEID = ''6'' AND TNA.TOPOLOGYNODE = T.ENTITYID AND TNA.REFERENCEID = NN.ENTITYID AND NN.NETWORK = N.ENTITYID AND PLREL.NETWORKNODE(+) = NN.ENTITYID AND PLREL.GEOGRAPHICPLACE = PL.ENTITYID(+) AND T.GEOMETRY IS NOT NULL AND NNREL.NETWORKNODE = NN.ENTITYID AND NNREL.PHYSICALDEVICE = RES.ENTITYID AND NN.NODETYPE = ''PHYSICAL_DEVICE'' AND N.ENTITYID = :1 </features>
    <label column="NODE_NAME" style="T.TEXT"> 1 </label>
  </rule>
</styling_rules>');

insert into user_sdo_themes (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) values ('CUSTOM_OBJECT','Base Custom Object Theme','TOPOLOGYNODE','GEOMETRY','<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="KEYCOLUMN">
  <hidden_info>
    <field column="NODE_ID" name="Node Id"/>
    <field column="RES_ID" name="Custom Object Id"/>
    <field column="RES_NAME" name="Custom Object Name"/>
    <field column="PLACE_ID" name="Place Id"/>
    <field column="PLACE_NAME" name="Place Name"/>
    <field column="LATITUDE" name="Latitude"/>
    <field column="LONGITUDE" name="Longitude"/>
  </hidden_info>
  <rule>
    <features asis="true" style="M.CUSTOM_OBJECT"> SELECT NN.ID AS NODE_ID, RES.ENTITYCLASS || ''-'' || RES.ENTITYID || ''::'' || PL.ENTITYCLASS || ''-'' || PL.ENTITYID AS KEYCOLUMN, NN.NAME AS NODE_NAME, PL.ID AS PLACE_ID, PL.NAME AS PLACE_NAME, ROUND(T.LATITUDE,6) AS LATITUDE, ROUND(T.LONGITUDE,6) AS LONGITUDE, RES.ID AS RES_ID, RES.NAME AS RES_NAME, T.GEOMETRY AS GEOMETRY FROM TOPOLOGYNODE T, TOPNODEASSOCIATION TNA, NETWORKNODE NN, NETWORK N, PLACE_NETWORKNODEREL PLREL, GEOGRAPHICPLACE PL ,NETNODE_CUSTOBJREL NNREL, CUSTOMOBJECT RES WHERE T.BUSINESSOBJECTTYPEID = ''6'' AND TNA.TOPOLOGYNODE = T.ENTITYID AND TNA.REFERENCEID = NN.ENTITYID AND NN.NETWORK = N.ENTITYID AND PLREL.NETWORKNODE(+) = NN.ENTITYID AND PLREL.GEOGRAPHICPLACE = PL.ENTITYID(+) AND T.GEOMETRY IS NOT NULL AND NNREL.NETWORKNODE = NN.ENTITYID AND NNREL.CUSTOMOBJECT = RES.ENTITYID AND NN.NODETYPE = ''CUSTOM_OBJECT'' AND N.ENTITYID = :1 </features>
    <label column="NODE_NAME" style="T.TEXT"> 1 </label>
  </rule>
</styling_rules>');

insert into user_sdo_themes (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) values ('DEVICE_INTERFACE','Base Device Interface Theme','TOPOLOGYNODE','GEOMETRY','<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="KEYCOLUMN">
  <hidden_info>
    <field column="NODE_ID" name="Node Id"/>
    <field column="RES_ID" name="Device Interface Id"/>
    <field column="RES_NAME" name="Device Interface Name"/>
    <field column="PLACE_ID" name="Place Id"/>
    <field column="PLACE_NAME" name="Place Name"/>
    <field column="LATITUDE" name="Latitude"/>
    <field column="LONGITUDE" name="Longitude"/>
  </hidden_info>
  <rule>
    <features asis="true" style="M.DEVICE_INTERFACE"> SELECT NN.ID AS NODE_ID, RES.ENTITYCLASS || ''-'' || RES.ENTITYID || ''::'' || PL.ENTITYCLASS || ''-'' || PL.ENTITYID AS KEYCOLUMN, NN.NAME AS NODE_NAME, PL.ID AS PLACE_ID, PL.NAME AS PLACE_NAME, ROUND(T.LATITUDE,6) AS LATITUDE, ROUND(T.LONGITUDE,6) AS LONGITUDE, RES.ID AS RES_ID, RES.NAME AS RES_NAME, T.GEOMETRY AS GEOMETRY FROM TOPOLOGYNODE T, TOPNODEASSOCIATION TNA, NETWORKNODE NN, NETWORK N, PLACE_NETWORKNODEREL PLREL, GEOGRAPHICPLACE PL ,NETNODE_DEVINTREL NNREL, DEVICEINTERFACE RES WHERE T.BUSINESSOBJECTTYPEID = ''6'' AND TNA.TOPOLOGYNODE = T.ENTITYID AND TNA.REFERENCEID = NN.ENTITYID AND NN.NETWORK = N.ENTITYID AND PLREL.NETWORKNODE(+) = NN.ENTITYID AND PLREL.GEOGRAPHICPLACE = PL.ENTITYID(+) AND T.GEOMETRY IS NOT NULL AND NNREL.NETWORKNODE = NN.ENTITYID AND NNREL.DEVICEINTERFACE = RES.ENTITYID AND NN.NODETYPE = ''DEVICE_INTERFACE'' AND N.ENTITYID = :1 </features>
    <label column="NODE_NAME" style="T.TEXT"> 1 </label>
  </rule>
</styling_rules>');

insert into user_sdo_themes (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) values ('PARTY','Base Party Theme','TOPOLOGYNODE','GEOMETRY','<?xml version="1.0" standalone="yes"?>
<styling_rules key_column="KEYCOLUMN">
  <hidden_info>
    <field column="NODE_ID" name="Node Id"/>
    <field column="RES_ID" name="Party Id"/>
    <field column="RES_NAME" name="Party Name"/>
    <field column="PLACE_ID" name="Place Id"/>
    <field column="PLACE_NAME" name="Place Name"/>
    <field column="LATITUDE" name="Latitude"/>
    <field column="LONGITUDE" name="Longitude"/>
  </hidden_info>
  <rule>
    <features asis="true" style="M.PARTY"> SELECT NN.ID AS NODE_ID, RES.ENTITYCLASS || ''-'' || RES.ENTITYID || ''::'' || PL.ENTITYCLASS || ''-'' || PL.ENTITYID AS KEYCOLUMN, NN.NAME AS NODE_NAME, PL.ID AS PLACE_ID, PL.NAME AS PLACE_NAME, ROUND(T.LATITUDE,6) AS LATITUDE, ROUND(T.LONGITUDE,6) AS LONGITUDE, RES.ID AS RES_ID, RES.NAME AS RES_NAME, T.GEOMETRY AS GEOMETRY FROM TOPOLOGYNODE T, TOPNODEASSOCIATION TNA, NETWORKNODE NN, NETWORK N, PLACE_NETWORKNODEREL PLREL, GEOGRAPHICPLACE PL ,PARTY_NETWORKNODEREL NNREL, PARTY RES WHERE T.BUSINESSOBJECTTYPEID = ''6'' AND TNA.TOPOLOGYNODE = T.ENTITYID AND TNA.REFERENCEID = NN.ENTITYID AND NN.NETWORK = N.ENTITYID AND PLREL.NETWORKNODE(+) = NN.ENTITYID AND PLREL.GEOGRAPHICPLACE = PL.ENTITYID(+) AND T.GEOMETRY IS NOT NULL AND NNREL.NETWORKNODE = NN.ENTITYID AND NNREL.PARTY = RES.ENTITYID AND NN.NODETYPE = ''PARTY'' AND N.ENTITYID = :1 </features>
    <label column="NODE_NAME" style="T.TEXT"> 1 </label>
  </rule>
</styling_rules>');
 END; 