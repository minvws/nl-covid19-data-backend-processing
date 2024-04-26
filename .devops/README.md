# **BUILD AND RELEASE IMPLEMENTATIONS**

---

The build pipeline currently produces a dacpac artifact, used for deploying the database structure, and an artifact that is obsolete (originally making use of pybooks). The deploy-configs.yml template will instead pull the relevant configs directly from the git repo to fill the configuration tables of the database. 
