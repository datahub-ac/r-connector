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

#' Function getDBPath()
#' In AAP applications returns the database name and schema name
#'
#' @export
getDBPath <- function() {
  path_filename <- Sys.getenv("ACLIB_DBPATH_FILE", "/lifecycle/.dbpath")
  if (!file.exists(path_filename))
    stop(paste0('Could not find dbpath file ', path_filename, '.'))

  con = file(path_filename, "r")
  line = readLines(con, n = 1)
  close(con)

  if (length(line) == 0)
    stop(paste0('Could not parse dbpath file, first line of ', path_filename, ' is empty.'))

  split_arr <- unlist(strsplit(line, "\".\""))
  if (length(split_arr) != 2 )
    stop(paste0("Invalid path format in dbpath file ", path_filename, '.'))

  db_name <- paste0(split_arr[1],"\"")
  schema_name <- paste0("\"",split_arr[2])
  sprintf("Found database = %s, schema = %s in dbpath file %s.", db_name, schema_name, path_filename)

  return(list(dbname = db_name, schemaname = schema_name))
}
