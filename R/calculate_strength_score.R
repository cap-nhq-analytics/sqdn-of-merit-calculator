#' @title Calculate the Strength Score
#' @description Calculate the strength score for all units in a Squadron of Merit Listing.
#' @details
#' The strength score is calculated by dividing the starting strength by 12, which assigns 1 point
#' for the minimum strength as described in CAPR 39-3.
#'
#' The final result is then standardized using the distribution of the scores to have a mean of 1
#' and standard deviation of 1.
#' @param som_report A data.table containing the Squadron of Merit Listing data.
#' @return A data.table containing the unit charter number and the strength score.
#' @export

calculate_strength_score <- function(som_report) {
    result <- som_report[j = list(RWU, StartStr)]
    result[j = strength_score := scale(StartStr / 12) + 1]
    result[j = StartStr := NULL]
    result[]
    return(result)
}
