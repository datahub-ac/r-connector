#' R connector for DataHub.ac
#'
#' Function getDataHubCon(dbname, schemaname)
#' Creates a new connection to schema dbname.schemaname
#'
#' @param dbname The database (organization + space) to connect to
#' @param schemaname The schema (instance + state) to connect to
#' @export
getDataHubCon <- function(dbname, schemaname) {
  require(DBI)

  if (file.exists("~/.odbc.ini")) {
    inifile <- ini::read.ini('~/.odbc.ini')

    username <- inifile$datahub$uid
    password <- inifile$datahub$pwd
  } else {
    username <- rstudioapi::askForSecret("DataHub Username:")
    password <- rstudioapi::askForSecret("DataHub Token (not your password!):")
  }
  sysname  <- Sys.info()["sysname"]

  if (sysname == "Linux") {
    con <- odbc::dbConnect(odbc::odbc(),
                           uid=username,
                           pwd=password,
                           driver="SnowflakeDSIIDriver",
                           server="alphacruncher.eu-central-1.snowflakecomputing.com",
                           database=dbname,
                           schema=schemaname,
                           warehouse=username,
                           role=username,
                           tracing=0)

  } else if (sysname == "Windows") {
    con <- odbc::dbConnect(odbc::odbc(),
                           uid = username,
                           pwd = password,
                           driver = "SnowflakeDSIIDriver",
                           server = "alphacruncher.eu-central-1.snowflakecomputing.com",
                           database = dbname,
                           schema = schemaname,
                           warehouse = username,
                           role = username,
                           tracing = 0)

  } else if (sysname == "Darwin") {
    con <- odbc::dbConnect(odbc::odbc(),
                           uid=username,
                           pwd=password,
                           driver="/opt/snowflake/snowflakeodbc/lib/universal/libSnowflake.dylib",
                           server="alphacruncher.eu-central-1.snowflakecomputing.com",
                           database=dbname,
                           schema=schemaname,
                           warehouse=username,
                           role=username,
                           tracing=0)
  }
  return(con)
}
