-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.
 
 -- 1) CREATE STORE PROCEDURE(S) STAGE -> INTER
 CREATE   PROCEDURE [DBO].[SP_VWS_BEHAVIOR_ANNOTATIONS_NL_STAGE_TO_INTER]
 AS
 BEGIN
     INSERT INTO [VWSINTER].[VWS_BEHAVIOR_ANNOTATIONS_NL] (
         [VERSION],
         [DATE_OF_REPORT],
         [DATE_OF_CHANGE],
         [FIRST_WAVE],
         [DATE_OF_FIRST_MEASUREMENT],
         [MEASUREMENT_DURATION_IN_DAYS],
         [INDICATOR],
         [STATUS],
         [MESSAGE_TITLE_NL],
         [MESSAGE_TITLE_EN],
         [MESSAGE_TEXT_NL],
         [MESSAGE_TEXT_EN],
         [MESSAGE_RIVM]
     )
     SELECT
         CAST([VERSION] AS INT),
         CONVERT(DATETIME, [DATE_OF_REPORT], 105),
         CONVERT(DATETIME, [DATE_OF_CHANGE], 105),
         CAST([FIRST_WAVE] AS INT), 
         CONVERT(DATETIME, [DATE_OF_FIRST_MEASUREMENT], 105),
         CAST([MEASUREMENT_DURATION_IN_DAYS] AS INT),
         CASE REPLACE(REPLACE(TRIM(LOWER([INDICATOR])),' ', '_'), '__', '_') 
             WHEN 'was_vaak_je_handen' THEN 'wash_hands'
             WHEN 'was_je_handen' THEN 'wash_hands'
             WHEN 'avondklok' THEN 'curfew'
             WHEN 'afstand_houden' THEN 'keep_distance'
             WHEN 'houd_1_5m_afstand' THEN 'keep_distance'
             WHEN 'werk_thuis_als_het_kan' THEN 'work_from_home'
             WHEN 'werk_thuis' THEN 'work_from_home'
             WHEN 'werkt_thuis' THEN 'work_from_home'
             WHEN 'vermijd_drukke_plekken' THEN 'avoid_crowds'
             WHEN 'blijf_thuis_bij_klachten' THEN 'symptoms_stay_home_if_mandatory'
             WHEN 'laat_je_testen_bij_klachten' THEN 'symptoms_get_tested'
             WHEN 'draag_een_mondkapje_in_publieke_binnenruimtes' THEN 'wear_mask_public_indoors'
             WHEN 'draag_mondkapje_in_publieke_binnenruimtes' THEN 'wear_mask_public_indoors'
             WHEN 'draag_een_mondkapje_in_het_openbaar_vervoer' THEN 'wear_mask_public_transport'
             WHEN 'draag_een_mondkapje_in_het_ov' THEN 'wear_mask_public_transport'
             WHEN 'hoest_en_nies_in_je_elleboog' THEN 'sneeze_cough_elbow'
             WHEN 'hoest_niest_in_elleboog' THEN 'sneeze_cough_elbow'
             WHEN 'ontvang_het_maximaal_aantal_bezoekers_thuis' THEN 'max_visitors'
             WHEN 'ontvang_het_maximaal_aantal_bezoekers' THEN 'max_visitors'
             WHEN 'ontvang_max_bezoekers_thuis' THEN 'max_visitors'
             WHEN 'zorg_voor_voldoende_frisse_lucht' THEN 'ventilate_home'
             WHEN 'zorg_voor_frisse_lucht' THEN 'ventilate_home'
             WHEN 'ventileren_woning' THEN 'ventilate_home'
             WHEN 'doe_een_zelftest_voordat_je_op_zoek_gaat_bij_iemand' THEN 'selftest_visit'
             WHEN 'doe_een_zelftest' THEN 'selftest_visit'
             WHEN 'zelftest_bezoek' THEN 'selftest_visit'
             ELSE [INDICATOR]
         END,
         [STATUS],
         [MESSAGE_TITLE_NL],
         [MESSAGE_TITLE_EN],
         [MESSAGE_TEXT_NL],
         [MESSAGE_TEXT_EN],
         [MESSAGE_RIVM]
     FROM 
         [VWSSTAGE].[VWS_BEHAVIOR_ANNOTATIONS_NL]
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM  [VWSSTAGE].[VWS_BEHAVIOR_ANNOTATIONS_NL])
         AND TRIM(ISNULL([INDICATOR], '')) != ''
 END;