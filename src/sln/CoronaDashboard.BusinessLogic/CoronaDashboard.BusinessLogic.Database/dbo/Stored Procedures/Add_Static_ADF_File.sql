CREATE PROCEDURE [dbo].[Add_Static_ADF_File] (@Source_content_url nvarchar(200)
                                        , @Source_content_document nvarchar(200)
                                        , @Target_name_schema nvarchar(200)
                                        , @Target_name_table nvarchar(200)
                                        , @ColumnMappingSource nvarchar(1024)
                                        , @ColumnMappingTarget nvarchar(1024))
AS
BEGIN
    IF NOT EXISTS (SELECT Id FROM [VWSSTATIC].[SPLIT_FILE_SOURCES] WHERE [BASE_URL] = @Source_content_url AND [DOCUMENT_NAME] =  @Source_content_document)
        INSERT INTO [VWSSTATIC].[SPLIT_FILE_SOURCES] ([BASE_URL], [DOCUMENT_NAME], [TABLE_SCHEMA], [TABLE_NAME], [SOURCE_COLUMNS], [TARGET_COLUMNS]) 
        VALUES (@Source_content_url, @Source_content_document, @Target_name_schema, @Target_name_table, @ColumnMappingSource, @ColumnMappingTarget)

END
