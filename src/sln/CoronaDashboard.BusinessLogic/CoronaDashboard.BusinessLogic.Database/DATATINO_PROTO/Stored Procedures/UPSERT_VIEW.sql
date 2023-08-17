CREATE   PROCEDURE DATATINO_PROTO.UPSERT_VIEW(
    @id BIGINT NULL,
    @view_name VARCHAR(200),
    @last_update_name VARCHAR(200)
) AS
    IF @id IS NULL
      INSERT DATATINO_PROTO.VIEWS (VIEW_NAME, LAST_UPDATE_NAME) 
      VALUES (@view_name,
              @last_update_name);
    ELSE
      IF @view_name IS NULL
              SET @view_name = (SELECT VIEW_NAME FROM DATATINO_PROTO.VIEWS WHERE ID = @id)
      IF @last_update_name IS NULL
              SET @last_update_name = (SELECT LAST_UPDATE_NAME FROM DATATINO_PROTO.VIEWS WHERE ID = @id)
      UPDATE DATATINO_PROTO.VIEWS SET 
        VIEW_NAME = @view_name,
        LAST_UPDATE_NAME = @last_update_name
      WHERE ID = @id