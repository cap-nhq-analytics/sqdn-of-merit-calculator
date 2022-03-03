#' @title Calculate the Encampment Metric
#' @description Calculate the encampment metric for all units in a Squadron of Merit Listing.
#' @details
#' This metric awards 1 point for every first-time Encampment attendee.
#'
#' The final result is then standardized using the distribution of the scores to have a mean of 1
#' and standard deviation of 1.
#' @param som_report A data.table containing the Squadron of Merit Listing data.
#' @return A data.table containing the unit charter number and the encampment metric.
#' @export

calculate_enc_metric <- function(som_report) {
    result <- som_report[j = list(RWU, FrstEncCnt)]
    result[j = enc_metric := scale(FrstEncCnt) + 1]
    result <- result[j = list(RWU, enc_metric)]
    result[]
    return(result)
}
