# **BUILD AND RELEASE IMPLEMENTATIONS**

---

## Build

The build pipeline currently produces a dacpac artifact, used for deploying the database structure, and an artifact that is obsolete (originally making use of pybooks). The deploy-configs.yml template will instead pull the relevant configs directly from the git repo to fill the configuration tables of the database.

## Release

* The release pipeline will first deploy the dacpac from the business-logic-database artifact
* The load-protos-script.ps1 will replace the current protos configuration as stored in the database with whatever is currently in the .devops/configs/protos directory. 
* The load-workflow-configs.ps1 will replace the current orchestrator configuration with whatever is configured in the .devops/configs/dataflows directory.
  * It will match the ID's of the dataflows to update current Dataflows, so be careful when changing IDs. This is done to retain compatibility with the logging that is currently in place. 

