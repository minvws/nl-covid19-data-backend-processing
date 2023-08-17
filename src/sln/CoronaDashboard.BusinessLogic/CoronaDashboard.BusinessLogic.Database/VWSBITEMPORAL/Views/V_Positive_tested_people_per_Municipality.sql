CREATE   VIEW VWSBITEMPORAL.V_Positive_tested_people_per_Municipality AS
    SELECT A.*
    FROM VWSBITEMPORAL.Positive_tested_People_per_municipality A WITH(NOLOCK)
        INNER JOIN VWSSTATIC.ACTIVE_MUNICIPALITIES B ON A.MUNICIPALITY_CODE=B.Gemeente_CODE
    WHERE A.END_DATE=convert(Datetime,'9999-12-31',120)