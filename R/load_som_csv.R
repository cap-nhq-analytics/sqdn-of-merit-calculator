#' @title Load the Squadron of Merit Listing from CSV
#' @description Loads the CSV of the Squadron of Merit Listing report from eServices into R.
#' @param report_path The path to the CSV report file. Local paths are acceptable.
#' @return A data.table containing the Squadron of Merit Listing, with excess fields stripped.
#' @export

load_som_report <- function(report_path) {
    som_report <- data.table::fread(report_path)
    desired_cols <- c(
        "RWU", "StartStr", "EndStr", "NewCdt", "TotalRenewed",
        "MitchCnt", "EarhCnt", "EakerCnt", "SpaatzCnt", "WrightBrosCnt",
        "FrstEncCnt", "OFlights", "Flight99"
    )
    return(som_report[j = ..desired_cols])
}
