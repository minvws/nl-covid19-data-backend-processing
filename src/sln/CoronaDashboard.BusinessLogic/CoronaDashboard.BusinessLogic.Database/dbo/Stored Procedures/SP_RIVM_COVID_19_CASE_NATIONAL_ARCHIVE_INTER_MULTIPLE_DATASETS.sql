CREATE PROCEDURE dbo.SP_RIVM_COVID_19_CASE_NATIONAL_ARCHIVE_INTER_MULTIPLE_DATASETS (@Max_Datasets As INT = 0)
AS
BEGIN
    IF @Max_Datasets = 0 PRINT 'Maximum number of Datasets set to 0, no Datasets moved to VWSARCHIVE.'

    -- Variable to hold the Date_Last_Inserted of the oldest dataset in the INTER-table
    DECLARE @Date_Last_Inserted DateTime;

    -- Number of datasets in the INTER-table
    DECLARE @Number INT = (SELECT Count(Distinct Date_Last_Inserted) FROM VWSINTER.RIVM_COVID_19_CASE_NATIONAL)
    IF @Number = 0 PRINT 'No Datasets present in VWSINTER table for Archiving.'

    -- Limit the number of Dataset to be moved to @Max_Datasets
    IF @Number > @Max_Datasets SET @Number = @Max_Datasets


    -- Archive-loop: loops @Number times to Archive the oldest dataset from VWSINTER to VWSArchive
    WHILE @Number > 0
    BEGIN

        SET @Date_Last_Inserted = ( SELECT TOP (1) DATE_LAST_INSERTED
                                    FROM (
                                        SELECT Distinct DATE_LAST_INSERTED
                                        FROM VWSINTER.RIVM_COVID_19_CASE_NATIONAL
                                    ) A
                                    ORDER BY DATE_LAST_INSERTED
                                    )

        IF @Date_Last_Inserted IS NOT NULL 
        BEGIN
            EXECUTE dbo.SP_RIVM_COVID_19_CASE_NATIONAL_ARCHIVE_INTER_DATASET @Date_Last_Inserted                            
        END

        SET @Number = @Number - 1

    END

END