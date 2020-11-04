-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- upon request of 20-10-2020, update the gmcode of 3023 from GM0173 to GM1681
IF EXISTS ( SELECT RWZI_CODE FROM VWSSTATIC.RWZI_GMCODE WHERE RWZI_CODE = '3023' )
    UPDATE VWSSTATIC.RWZI_GMCODE SET GM_CODE = 'GM1681' WHERE RWZI_CODE = '3023'
ELSE
    INSERT INTO VWSSTATIC.RWZI_GMCODE (RWZI_CODE, GM_CODE) VALUES ('3023' , 'GM1681')

