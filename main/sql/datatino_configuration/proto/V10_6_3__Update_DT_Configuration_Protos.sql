-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Update Municipal sewer proto names
    -- GM sewer_measurements => sewer
UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
    SET ITEM_NAME = 'sewer'
WHERE ITEM_NAME = 'sewer_measurements'
    AND CONSTRAINT_KEY_NAME='GMCODE'

    -- GM results_per_sewer_installation_per_municipality => sewer_per_installation
UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
    SET ITEM_NAME = 'sewer_per_installation'
WHERE ITEM_NAME = 'results_per_sewer_installation_per_municipality'
    AND CONSTRAINT_KEY_NAME='GMCODE'

-- Delete all duplicate proto configurations, some duplication was present for the sewer rows
DELETE FROM DATATINO_PROTO.PROTO_CONFIGURATIONS
WHERE ID IN (
    SELECT ID FROM (
        SELECT ID, PROTO_ID, ITEM_NAME, SUM(1) OVER (PARTITION BY PROTO_ID, ITEM_NAME ORDER BY ID ASC)RANKING
        FROM  DATATINO_PROTO.PROTO_CONFIGURATIONS
        WHERE ACTIVE = 'true') X
WHERE X.RANKING = 2)