
CREATE   PROCEDURE [DATATINO_PROTO_1].[UPSERT_CONFIGURATION](
    @id BIGINT NULL,
    @proto_name VARCHAR(MAX) NULL,
    @description VARCHAR(MAX) NULL,
    @view_name VARCHAR(MAX) NULL,
    @item_name VARCHAR(MAX) NULL, 
    @constrained BIGINT NULL, 
    @grouped BIGINT NULL, 
    @columns VARCHAR(MAX) NULL,
    @mapping VARCHAR(MAX) NULL,
    @layout_type_id BIGINT NULL,
    @active BIGINT,
    @constraint_key_name VARCHAR(MAX) NULL = NULL,
    @constraint_value VARCHAR(MAX) NULL = NULL,
    @grouped_key_name VARCHAR(MAX) NULL = NULL,
    @grouped_last_update_name VARCHAR(MAX) NULL = NULL
) AS
    DECLARE @proto_id bigint = (SELECT [ID] FROM [DATATINO_PROTO_1].[PROTOS] WHERE [NAME] = @proto_name)
    DECLARE @view_id BIGINT,
            @config_id BIGINT;

    SELECT 
        @view_id = [ID]
    FROM [DATATINO_PROTO_1].[VIEWS]
    WHERE ISNULL([CONSTRAINT_VALUE], 'X') = ISNULL(@constraint_value, 'X')
        AND ISNULL([CONSTRAINT_KEY_NAME], 'X') = ISNULL(@constraint_key_name, 'X')
        AND ISNULL([GROUPED_KEY_NAME], 'X') = ISNULL(@grouped_key_name, 'X')
        AND ISNULL([GROUPED_LAST_UPDATE_NAME], 'X') = ISNULL(@grouped_last_update_name, 'X')
        AND [NAME] = @view_name

    SELECT
        @config_id = configs.[ID]
    FROM [DATATINO_PROTO_1].[VIEWS] views
    INNER JOIN [DATATINO_PROTO_1].[CONFIGURATIONS] AS configs ON views.[ID] = configs.[VIEW_ID]
        AND configs.[NAME] = @item_name
        AND configs.[VIEW_ID] = @view_id
    INNER JOIN [DATATINO_PROTO_1].[PROTOS] AS protos ON protos.[ID] = configs.[PROTO_ID]
        AND protos.[NAME] = @proto_name
    WHERE views.[NAME] = @view_name;

    IF @id IS NULL
    BEGIN
        INSERT INTO DATATINO_PROTO_1.CONFIGURATIONS(
            [PROTO_ID], 
            [NAME], 
            [DESCRIPTION], 
            [VIEW_ID], 
            [CONSTRAINED], 
            [GROUPED], 
            [COLUMNS], 
            [MAPPING], 
            [LAYOUT_TYPE_ID], 
            [ACTIVE]
        ) 
        VALUES (
            @proto_id,
            @item_name,
            @description,
            @view_id, 
            @constrained, 
            @grouped, 
            @columns,
            @mapping, 
            @layout_type_id, 
            @active
        )
    END
    ELSE
    BEGIN
        IF @proto_name IS NULL
              SET @proto_id = (SELECT PROTO_ID FROM DATATINO_PROTO_1.CONFIGURATIONS WHERE ID = @id)
        IF @item_name IS NULL
              SET @item_name = (SELECT [NAME] FROM DATATINO_PROTO_1.CONFIGURATIONS WHERE ID = @id)
        if @description IS NULL
              SET @description = (SELECT [DESCRIPTION] FROM DATATINO_PROTO_1.CONFIGURATIONS WHERE ID = @id)
        IF @view_name IS NULL
              SET @view_id = (SELECT VIEW_ID FROM DATATINO_PROTO_1.CONFIGURATIONS WHERE ID = @id)
        IF @constrained IS NULL
              SET @constrained = (SELECT [CONSTRAINED] FROM DATATINO_PROTO_1.CONFIGURATIONS  WHERE ID = @id)
        IF @grouped IS NULL
              SET @grouped = (SELECT GROUPED FROM DATATINO_PROTO_1.CONFIGURATIONS  WHERE ID = @id)
        IF @layout_type_id IS NULL
              SET @layout_type_id = (SELECT LAYOUT_TYPE_ID FROM DATATINO_PROTO_1.CONFIGURATIONS WHERE ID = @id)
        IF @mapping IS NULL
              SET @mapping = (SELECT MAPPING FROM DATATINO_PROTO_1.CONFIGURATIONS WHERE ID = @id)
        IF @columns IS NULL
              SET @columns = (SELECT COLUMNS FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
        IF @active IS NULL
              SET @active = (SELECT ACTIVE FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)

        UPDATE [DATATINO_PROTO_1].[CONFIGURATIONS] SET
          [PROTO_ID] = @proto_id,
          [NAME] = @item_name,
          [DESCRIPTION] = @description,
          [VIEW_ID] = @view_id, 
          [CONSTRAINED] = @constrained, 
          [GROUPED] = @grouped,
          [LAYOUT_TYPE_ID] = @layout_type_id,
          [COLUMNS] = @columns,
          [ACTIVE] = @active,
          [MAPPING] = @mapping
        WHERE [ID] = @id
    END;