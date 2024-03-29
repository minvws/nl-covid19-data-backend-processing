﻿CREATE TABLE [VWSINTER].[RIVM_NURSING_HOMES_HANDICAPPED_INFECTED_LOCATIONS] (
    [ID]                                                                 INT      DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_RIVM_NURSING_HOMES_HANDICAPPED_INFECTED_LOCATIONS]) NOT NULL,
    [PUBLICATIEDATUMRIVM]                                                DATETIME NULL,
    [AANTAL_NIEUW_BESMETTE_GEHANDICAPTENZORGINSTELLING_LOCATIES]         INT      NULL,
    [AANTAL_NIEUW_BESMETTINGSVRIJE_GEHANDICAPTENZORGINSTELLING_LOCATIES] INT      NULL,
    [AANTAL_BESMETTE_GEHANDICAPTENZORGINSTELLING_LOCATIES]               INT      NULL,
    [DATE_LAST_INSERTED]                                                 DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

