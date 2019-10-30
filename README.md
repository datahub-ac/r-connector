# Installation

```
install.packages("remotes")
remotes::install_github("datahub-ac/r-connector")
```

# Usage

```
con <- datahub::getDataHubCon("DM", "SAMPLE_DB")
```

# Usage in AAP applications

```
connection_info <- datahub::getDBPath()
con <- datahub::getDataHubCon(connection_info$dbname, connection_info$schemaname)
```
