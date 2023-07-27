CREATE   VIEW VWSREPORT.V_DateLineage_nodes
AS

    SELECT NODE_CATEGORY, NODE
    FROM 
        (SELECT 
                NODE1_CATEGORY                                                  AS [NODE_CATEGORY]
                ,NODE1                                                          AS [NODE]                
        FROM VWSREPORT.V_DateLineage_edges

        UNION
        SELECT 
                NODE2_CATEGORY                                                  AS [NODE_CATEGORY]
                ,NODE2                                                          AS [NODE]            
                
        FROM
            VWSREPORT.V_DateLineage_edges

                ) CombinedNodes