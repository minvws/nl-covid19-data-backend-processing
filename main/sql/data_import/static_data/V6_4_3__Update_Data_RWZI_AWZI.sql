-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- upon request some RWZI installation names need to be updated
UPDATE [VWSSTATIC].[RWZI_AWZI] SET
    [RWZI_AWZI_name] = 'Damwâld'
WHERE [RWZI_AWZI_name] = 'Damwoude'

UPDATE [VWSSTATIC].[RWZI_AWZI] SET
    [RWZI_AWZI_name] = 'Burdaard'
WHERE [RWZI_AWZI_name] = 'Birdaard'

UPDATE [VWSSTATIC].[RWZI_AWZI] SET
    [RWZI_AWZI_name] = 'Grou'
WHERE [RWZI_AWZI_name] = 'Grouw'
