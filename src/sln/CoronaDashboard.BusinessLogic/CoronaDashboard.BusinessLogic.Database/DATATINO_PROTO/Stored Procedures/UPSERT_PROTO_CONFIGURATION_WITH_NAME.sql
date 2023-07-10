CREATE   PROCEDURE DATATINO_PROTO.UPSERT_PROTO_CONFIGURATION_WITH_NAME(
    @id BIGINT NULL,
    @proto_name VARCHAR(200) NULL,
    @item_name VARCHAR(200) NULL, 
    @view_name VARCHAR(MAX) NULL, 
    @constraint BIGINT NULL, 
    @constraint_key_name VARCHAR(200) NULL, 
    @constraint_value VARCHAR(200) NULL, 
    @grouped BIGINT NULL, 
    @grouped_key_name varchar(200) NULL, 
    @grouped_last_update_name varchar(200) NULL,
    @layout_id BIGINT NULL,
    @active BIGINT,
    @columns VARCHAR(MAX) NULL,
    @mockable BIGINT NULL,
    @mock_name VARCHAR(200) NULL
) AS
    DECLARE @proto_id bigint = ( SELECT ID FROM DATATINO_PROTO.PROTOS WHERE PROTO_NAME = @proto_name)
    DECLARE @view_id bigint = ( SELECT ID FROM DATATINO_PROTO.VIEWS WHERE VIEW_NAME = @view_name)
    DECLARE @mock_id bigint = ( SELECT ID FROM DATATINO_PROTO.MOCKS WHERE MOCK_NAME = @mock_name)

    IF @id IS NULL
      INSERT INTO DATATINO_PROTO.PROTO_CONFIGURATIONS(PROTO_ID, ITEM_NAME, VIEW_ID, [CONSTRAINT], CONSTRAINT_KEY_NAME, CONSTRAINT_VALUE, GROUPED, 
                                                      GROUPED_KEY_NAME, GROUPED_LAST_UPDATE_NAME, LAYOUT_ID, COLUMNS, ACTIVE, MOCKABLE, MOCK_ID) 
      VALUES (@proto_id,
              @item_name, 
              @view_id, 
              @constraint, 
              @constraint_key_name, 
              @constraint_value, 
              @grouped, 
              @grouped_key_name, 
              @grouped_last_update_name,
              @layout_id,
              @columns,
              @active,
              @mockable,
              @mock_id)
    ELSE
      IF @proto_name IS NULL
            SET @proto_id = (SELECT PROTO_ID FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
      IF @item_name IS NULL
            SET @item_name = (SELECT ITEM_NAME FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
      IF @view_name IS NULL
            SET @view_id = (SELECT VIEW_ID FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
      IF @constraint IS NULL
            SET @constraint = (SELECT [CONSTRAINT] FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
      IF @constraint_key_name IS NULL
            SET @constraint_key_name = (SELECT CONSTRAINT_KEY_NAME FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
      IF @constraint_value IS NULL
            SET @constraint_value = (SELECT CONSTRAINT_VALUE FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
      IF @grouped IS NULL
            SET @grouped = (SELECT GROUPED FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
      IF @grouped_key_name IS NULL
            SET @grouped_key_name = (SELECT GROUPED_KEY_NAME FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
      IF @grouped_last_update_name IS NULL
            SET @grouped_last_update_name = (SELECT GROUPED_LAST_UPDATE_NAME FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
      IF @layout_id IS NULL
            SET @layout_id = (SELECT LAYOUT_ID FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
      IF @columns IS NULL
            SET @columns = (SELECT COLUMNS FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
      IF @active IS NULL
            SET @active = (SELECT ACTIVE FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
      IF @mockable IS NULL
            SET @mockable = (SELECT MOCKABLE FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
      IF @mock_id IS NULL
            SET @mock_id = (SELECT MOCK_ID FROM DATATINO_PROTO.PROTO_CONFIGURATIONS WHERE ID = @id)
      UPDATE DATATINO_PROTO.PROTO_CONFIGURATIONS SET
        PROTO_ID = @proto_id,
        ITEM_NAME = @item_name,
        VIEW_ID = @view_id, 
        [CONSTRAINT] = @constraint, 
        CONSTRAINT_KEY_NAME = @constraint_key_name,
        CONSTRAINT_VALUE = @constraint_value,
        GROUPED = @grouped,
        GROUPED_KEY_NAME = @grouped_key_name,
        GROUPED_LAST_UPDATE_NAME = @grouped_last_update_name,
        LAYOUT_ID = @layout_id,
        COLUMNS = @columns,
        ACTIVE = @active,
        MOCKABLE = @mockable,
        MOCK_ID = @mock_id
      WHERE ID = @id