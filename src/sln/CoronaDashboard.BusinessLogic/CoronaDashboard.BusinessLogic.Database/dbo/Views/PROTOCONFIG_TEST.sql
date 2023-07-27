/****** Script for SelectTopNRows command from SSMS  ******/
CREATE    VIEW [PROTOCONFIG_TEST] AS

select
	   [ID]
      ,[PROTO_ID]
      ,[PROTO_NAME]
      ,[ITEM_NAME]
	  ,  REPLACE( 
				REPLACE ( 
					REPLACE([VIEW_NAME], ']', '') 
					, '[', '')  
		, 'VWSDEST.', '')  AS [VIEW_NAME]
      ,[LAST_UPDATE_NAME]
      ,[CONSTRAINT]
      ,[CONSTRAINT_KEY_NAME]
      ,[CONSTRAINT_VALUE]
      ,[GROUPED]
      ,[GROUPED_KEY_NAME]
      ,[GROUPED_LAST_UPDATE_NAME]
      ,[LAYOUT_ID]
      ,[ACTIVE]
      ,[COLUMNS]
      ,[MOCKABLE]
      ,[MOCK_NAME]
      ,[MOCK_COLUMNS]
      ,[DATA_TYPES]
  FROM [DATATINO_PROTO].[V_PROTO_CONFIGURATIONS]