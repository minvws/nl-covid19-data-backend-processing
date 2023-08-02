CREATE   PROCEDURE DATATINO_ORCHESTRATOR.UPSERT_SOURCE (
    @id BIGINT NULL,
    @source_name VARCHAR(MAX),
    @description VARCHAR(MAX),
    @source VARCHAR(MAX),
    @source_columns VARCHAR(MAX),
    @target_columns VARCHAR(MAX),
    @target_name VARCHAR(MAX),
    @source_type VARCHAR(200),
    @location_type VARCHAR(200),
    @delimiter_type VARCHAR(200),
    @security_profile VARCHAR(200)
) AS
    DECLARE @source_type_id bigint = ( SELECT [ID] FROM DATATINO_ORCHESTRATOR.SOURCE_TYPES WHERE [NAME] = @source_type)
    DECLARE @location_type_id bigint = ( SELECT [ID] FROM DATATINO_ORCHESTRATOR.LOCATION_TYPES WHERE [NAME] = @location_type)
    DECLARE @delimiter_type_id bigint = ( SELECT [ID] FROM DATATINO_ORCHESTRATOR.DELIMITER_TYPES WHERE [NAME] = @delimiter_type)
    DECLARE @sp_id bigint = ( SELECT [ID] FROM DATATINO_ORCHESTRATOR.SECURITY_PROFILES WHERE [VALUE] = @security_profile)
    IF @id IS NULL
    INSERT DATATINO_ORCHESTRATOR.SOURCES ([SOURCE_NAME], [DESCRIPTION], [SOURCE], [SOURCE_COLUMNS], 
    [TARGET_COLUMNS], [TARGET_NAME], [SOURCE_TYPE_ID], [LOCATION_TYPE_ID], [DELIMITER_TYPE_ID], [SP_ID]) 
    VALUES (
            @source_name,
            @description,
            @source,
            @source_columns,
            @target_columns,
            @target_name,
            @source_type_id,
            @location_type_id,
            @delimiter_type_id,
            @sp_id)
    ELSE
        UPDATE DATATINO_ORCHESTRATOR.SOURCES SET 
            [SOURCE_NAME] = @source_name, 
            [DESCRIPTION] = @description, 
            [SOURCE] = @source, 
            [SOURCE_COLUMNS] = @source_columns, 
            [TARGET_COLUMNS] = @target_columns, 
            [TARGET_NAME] = @target_name, 
            [SOURCE_TYPE_ID] = @source_type_id, 
            [LOCATION_TYPE_ID] = @location_type_id, 
            [DELIMITER_TYPE_ID] = @delimiter_type_id, 
            [SP_ID] = @sp_id
        WHERE ID = @id