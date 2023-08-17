
--

CREATE   PROCEDURE [DATATINO_PROTO_1].[UPSERT_VIEW](
    @id BIGINT NULL,
    @view_name VARCHAR(MAX),
    @description VARCHAR(MAX),
    @last_update_name VARCHAR(200),
    @constraint_key_name VARCHAR(MAX),
    @constraint_value VARCHAR(MAX),
    @grouped_key_name VARCHAR(MAX),
    @grouped_last_update_name VARCHAR(MAX)
) AS
    IF @id IS NULL
      INSERT DATATINO_PROTO_1.VIEWS ([NAME], LAST_UPDATE_NAME, CONSTRAINT_KEY_NAME, CONSTRAINT_VALUE, GROUPED_KEY_NAME, GROUPED_LAST_UPDATE_NAME, [DESCRIPTION]) 
      VALUES (TRIM(@view_name),
              @last_update_name,
              @constraint_key_name,
              @constraint_value,
              @grouped_key_name,
              @grouped_last_update_name,
              @description);
    ELSE
      IF @view_name IS NULL
              SET @view_name = (SELECT [NAME] FROM DATATINO_PROTO_1.VIEWS WHERE ID = @id)
      IF @last_update_name IS NULL
              SET @last_update_name = (SELECT LAST_UPDATE_NAME FROM DATATINO_PROTO_1.VIEWS WHERE ID = @id)
      IF @constraint_key_name IS NULL
              SET @constraint_key_name = (SELECT CONSTRAINT_KEY_NAME FROM DATATINO_PROTO_1.VIEWS WHERE ID = @id)
      IF @constraint_value IS NULL
              SET @constraint_value = (SELECT CONSTRAINT_VALUE FROM DATATINO_PROTO_1.VIEWS WHERE ID = @id)
      IF @grouped_key_name IS NULL
              SET @grouped_key_name = (SELECT GROUPED_KEY_NAME FROM DATATINO_PROTO_1.VIEWS WHERE ID = @id)
      IF @grouped_last_update_name IS NULL
              SET @grouped_last_update_name = (SELECT GROUPED_LAST_UPDATE_NAME FROM DATATINO_PROTO_1.VIEWS WHERE ID = @id)
      IF @description IS NULL
              SET @description = (SELECT [DESCRIPTION] FROM DATATINO_PROTO_1.VIEWS WHERE ID = @id)
      UPDATE DATATINO_PROTO_1.VIEWS SET 
        [NAME] = TRIM(@view_name),
        LAST_UPDATE_NAME = @last_update_name,
        CONSTRAINT_KEY_NAME = @constraint_key_name,
        CONSTRAINT_VALUE = @constraint_value,
        GROUPED_KEY_NAME = @grouped_key_name,
        GROUPED_LAST_UPDATE_NAME = @grouped_last_update_name,
        [DESCRIPTION] = @description
      WHERE ID = @id