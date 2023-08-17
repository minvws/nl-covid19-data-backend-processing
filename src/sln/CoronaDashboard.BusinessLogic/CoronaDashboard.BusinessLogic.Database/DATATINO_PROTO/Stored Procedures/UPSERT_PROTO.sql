CREATE   PROCEDURE DATATINO_PROTO.UPSERT_PROTO(
    @id BIGINT NULL,
    @proto_name VARCHAR(200) NULL,
    @header_names VARCHAR(200) NULL,
    @header_values VARCHAR(200) NULL,
    @active INT = 1
) AS
  IF @id IS NULL
    INSERT DATATINO_PROTO.PROTOS (PROTO_NAME, HEADER_NAMES, HEADER_VALUES, ACTIVE) 
    VALUES (@proto_name,
            @header_names,
            @header_values,
            @active);
  ELSE
    IF @proto_name IS NULL
              SET @proto_name = (SELECT PROTO_NAME FROM DATATINO_PROTO.PROTOS WHERE ID = @id)
    IF @header_names IS NULL
                  SET @header_names = (SELECT HEADER_NAMES FROM DATATINO_PROTO.PROTOS WHERE ID = @id)
    IF @header_values IS NULL
                  SET @header_values = (SELECT HEADER_VALUES FROM DATATINO_PROTO.PROTOS WHERE ID = @id)
    IF @active IS NULL
                  SET @active = (SELECT ACTIVE FROM DATATINO_PROTO.PROTOS WHERE ID = @id)
    UPDATE DATATINO_PROTO.PROTOS SET 
      PROTO_NAME = @proto_name,
      HEADER_NAMES = @header_names,
      HEADER_VALUES = @header_values,
      ACTIVE = @active
    WHERE ID = @id