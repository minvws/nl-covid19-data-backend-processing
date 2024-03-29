﻿



CREATE   VIEW [DATATINO_PROTO_1].[V_PROTO_CONFIGURATIONS] AS
SELECT T2.ID
     ,T1.ID AS PROTO_ID
     ,T1.NAME AS PROTO_NAME
     ,T2.NAME AS ITEM_NAME
     ,T3.NAME AS VIEW_NAME
     ,T3.LAST_UPDATE_NAME
     ,T2.[CONSTRAINED]
     ,T3.CONSTRAINT_KEY_NAME
     ,T3.CONSTRAINT_VALUE
     ,T2.GROUPED
     ,T3.GROUPED_KEY_NAME
     ,T3.GROUPED_LAST_UPDATE_NAME
     ,T4.ID AS LAYOUT_ID
     ,T2.[ACTIVE]
     ,T2.COLUMNS
     ,T2.MOCK_ID
FROM DATATINO_PROTO_1.PROTOS T1
JOIN DATATINO_PROTO_1.CONFIGURATIONS T2 ON T1.ID = T2.PROTO_ID
JOIN DATATINO_PROTO_1.VIEWS T3 ON T2.VIEW_ID = T3.ID
JOIN DATATINO_PROTO_1.LAYOUT_TYPES T4 ON T2.LAYOUT_TYPE_ID = T4.ID
where T2.ACTIVE =1