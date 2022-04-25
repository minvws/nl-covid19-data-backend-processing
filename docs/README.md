# **INTRODUCTION**

---

The coronavirus dashboard gives up-to-date information about the development of the coronavirus in the Netherlands. It was launched 5 june 2020. Read more about the dashboard: **[link](https://coronadashboard.rijksoverheid.nl/over)**.

With the information on the dashboard, early signs that the rate of infection is increasing can be picked up. This project describes the definitions and calculations on various indicators to that purpose. For more information on data calculation and presentation for the corona dashboard: **[link](https://coronadashboard.rijksoverheid.nl/verantwoording)**.

## **TABLE OF CONTENTS**

---

1. **[About](#**about**)**
2. **[Technical And Functional Requirements](#**technical-and-functional-requirements**)**
3. **[Indicators](#**indicators**)**
4. **[Static Indicators](#**static-indicators**)**
5. **[Release Notes](#**release-notes**)**

## **ABOUT**

---

In this section,the different indicators are listed that the dashboard uses, where the numbers of these indicators originate from, certain design and technological choices in order to visuals to the data on the **[dashboard](https://coronadashboard.rijksoverheid.nl/)**. 

|**#**|**Indicator**|**Translation (NLD)**|**Abbr.**|
|:---|:----------|:----------|:----------|
|1|Intensive Care admissions|IC opnames|
|2|Hospital Admissions|Ziekenhuis opnames|LCPS|
|3|Positive Tested People|Positief Geteste Personen|
|4|Positive Tested People Per Region (i.e VR)|Positief Geteste Personen Per Regio| 
|5|Positive Tested Per Age Group|Positief Geteste Personen Per Leeftijdscategorie|
|6|Infectious People|Besmettelijke Personen|
|7|Nursinghomes|Verpleeghuizen|
|8|Sewer Measurements|Rioolwater Metingen|
|9|Sewage Treatment Plant|Rioolwaterzuiveringsinstallatie|RWZI|
|10|Growth number|Groeigetal|G-Number|


## **TECHNICAL AND FUNCTIONAL REQUIREMENTS**

---


The backend was made in assignment of the Ministry of Healthcare and Sports of the Netherlands (i.e. Volksgezondheid, Welzijn en Sport; **VWS**). The backend application must be as robust as possible hence the choice was made to export the the processed data from the **[indicators](#**indicators**)** in JSON format and to be made available for the **[frontend application](https://github.com/minvws/nl-covid19-data-dashboard)**.   

The requirements for the back-end and front-end are all according to the **[RIVM](https://www.rivm.nl/en)** standards, since the requirement was to be able to migrate the *Corona Dashboard* to the RIVM infrastructure. In addition, for the architecture design of the back-end, robustness was the choice over speed to minimize the loss of data integrity and minimize security risk. Hence, before the data is published online the data is checked by RIVM and the Ministery.

For most figures, we simply take the source data and apply little to no transformations to it. At most, we would add an extra date or replace a date with its **[UNIX](https://en.wikipedia.org/wiki/Unix_time)** counterpart. However, for some indicators we need to make a calculation, e.g. to calculate the 3 or 7 days averages. In this section we try to explain as much as possible what we have done in that case. In addition to the source code, we have also supplied the locations where you can find the data yourself. We are working on getting these sources available to the general public. In general, any user should be able to recreate the figures that are shown in the dashboard.

## **INDICATORS**

---

1. **[Administered Boostershots](../src/rivm/booster_shots_administered_nl.ipynb)**
2. **[Planned Boostershots](../src/rivm/booster_shots_planned_nl.ipynb)**
3. **[Third Vaccinations Administered](../src/rivm/third_vaccinations_administered_nl.ipynb)**

|**#**|**Indicator**|**Source**|**Data Supplier**|**Definition**|
|:---|:----------|:----------|:----------|:----------|
|1|**[Administered Boostershots](../src/rivm/booster_shots_administered_nl.ipynb)**|**[VWS_COVID-19_Booster_gezette_prikken.csv](https://data.rivm.nl/data/vws/covid-19/VWS_COVID-19_Booster_gezette_prikken.csv)**|**[RIVM](https://www.rivm.nl/en)**/**[GGD](https://www.ggd.nl/)**|*t.b.d.*|
|2|**[Planned Boostershots](../src/rivm/booster_shots_planned_nl.ipynb)**|**[VWS_COVID-19_geplande_afspraken.csv](https://data.rivm.nl/data/vws/covid-19/VWS_COVID-19_geplande_afspraken.csv)**|**[RIVM](https://www.rivm.nl/en)**/**[GGD](https://www.ggd.nl/)**|*t.b.d.*|
|3|**[Third Vaccinations Administered](../src/rivm/third_vaccinations_administered_nl.ipynb)**|**[3e_vaccinaties_IC.csv](https://data.rivm.nl/data/vws/covid-19/3e_vaccinaties_IC.csv)**|**[RIVM](https://www.rivm.nl/en)**|*t.b.d.*|

## **STATIC INDICATORS**

---

Static data is used by linking sporadic changing transactional data and expand more insights, e.g. percentages per total citizens. In the below table an overview is created of the static table,  which stored procedures process them and which destination tables they impact.

1. **[Inhabitants Per Municipality](#)**
2. **[Inhabitants Per Safety Region](#)**
3. **[Sewage Treatment Plant AWZI](#)**
4. **[Sewage Treatment Plant Per Municipality Code](#)**
5. **[Safety Regions Per Municipality](#)**
6. **[Nursing Home Locations Per Region](#)**

|**#**|**Indicator**|**Source**|**Used By**|**Impact On**|**Definition**|
|:---|:----------|:----------|:----------|:----------|:----------|
|1|**[Inhabitants Per Municipality](#)**|**[VWSSTATIC.INHABITANTS_PER_MUNICIPALITY](#)**|**[DBO.SP_POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY](#)**|**[VWSDEST.POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY]()**|*t.b.d.*|
|2|**[Inhabitants Per Safety Region](#)**|**[VWSSTATIC.INHABITANTS_PER_SAFETY_REGION](#)**|**[DBO.SP_RESULTS_PER_REGION](#)**|**[VWSDEST.RESULTS_PER_REGION]()**|The number of citizens per security region; these numbers originate from 01-01-2020. In the current version, this will not (yet) get updated on a regular basis.|
|3|**[Sewage Treatment Plant AWZI](#)**|**[VWSSTATIC.RWZI_AWZI](#)**|**[DBO.SP_SEWER_MEASUREMENTS_PER_RWZI](#)**|**[VWSDEST.SEWER_MEASUREMENTS_PER_RWZI]()**|A list of the combination between the code and the name of the sewage treatment plant (*RWZI_AWZI_CODE* and *RWZI_AWZI_NAME*).|
|4|**[Sewage Treatment Plant Per Municipality Code](#)**|**[VWSSTATIC.RWZI_GMCODE](#)**|**[DBO.SP_SEWER_MEASUREMENTS_PER_MUNICIPALITY](#)**|**[VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY]()**|A matrix containing the coverage of sewege treatment plants (amount of people) and the coverage in the regions and municipalities (percentage).|
|5|**[Safety Regions Per Municipality](#)**|**[VWSSTATIC.SAFETY_REGIONS_PER_MUNICIPAL](#)**|**[DBO.SP_SEWER_MEASUREMENTS_PER_RWZI](#)**|**[VWSDEST.SEWER_MEASUREMENTS_PER_RWZI]()**|A list of which municipalities belong to a specific security region. This is currently a static data set, which is not updated.|
|6|**[Nursing Home Locations Per Region](#)**|**[VWSSTATIC.V_NURSING_HOME_LOCATIONS_PER_REGION]()**|**[DBO.SP_NURSING_HOMES_PER_REGION]()**|**[VWSDEST.NURSING_HOMES_PER_REGION]()**|A list with the total amount of nursing home locations per security region.|

## **RELEASE NOTES**

---

**<a style="color:red">NOTE! Including the tracked and planned releases on the *README.md* started on 2022-04-05!</a>**

Hereby the tracked and planned changes that are implemented on the Acceptance and Production environments.

|Date of release|Source|Change|Environments|
|:---|:---|:---|:--|
|2022-04-06|[vws_vaccine_deliveries_administered.ipynb](./src/dataflows/vws_vaccine_deliveries_administered.ipynb)|Added "Novavax" within the JSON-object *[vaccine_administered](https://github.com/minvws/nl-covid19-data-dashboard/blob/develop/packages/app/schema/nl/vaccine_administered.json)*.| <input type="checkbox" disabled checked /> Acceptance<br/><input type="checkbox" disabled checked /> Production|
|2022-04-05|[vws_manual_input_vaccine_shots_planned.ipynb](./src/dataflows/vws_manual_input_vaccine_shots_planned.ipynb)|Replaces a workflow to populate the JSON-object *[vaccine_administered_planned](https://github.com/minvws/nl-covid19-data-dashboard/blob/develop/packages/app/schema/nl/vaccine_administered_planned.json)*. Previously the JSON-object was populated by [vws_vaccine_deliveries_administered.ipynb](./src/dataflows/vws_vaccine_deliveries_administered.ipynb).| <input type="checkbox" disabled checked/> Acceptance|
|2022-04-06|[vws_behavior_annotations_nl.ipynb](./src/dataflows/vws_behavior_annotations_nl.ipynb)|Temporary workflow to include annotations to the **[Behavior Graphs](https://coronadashboard.rijksoverheid.nl/landelijk/gedrag)** within the JSON-object *[behavior_annotation](https://github.com/minvws/nl-covid19-data-dashboard/blob/develop/packages/app/schema/nl/behavior_annotations.json)*.| <input type="checkbox" disabled checked /> Acceptance<br/><input type="checkbox" disabled checked /> Production|
