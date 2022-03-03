#' @title Calculate the Flight Metric
#' @description Calculate the flight metric for all units in a Squadron of Merit Listing.
#' @details
#' This metric is calculated by multiplying the Flight99 measure by 1, awarding 1 point for a value
#' of 100% on the Flight99 measure. The point value is doubled if the orientation flights flag
#' is set to Yes.
#'
#' The final result is then standardized using the distribution of the scores to have a mean of 1
#' and standard deviation of 1.
#' @param som_report A data.table containing the Squadron of Merit Listing data.
#' @return A data.table containing the unit charter number and the flight metric.
#' @export

calculate_flight_metric <- function(som_report) {
    result <- som_report[j = list(RWU, OFlights, Flight99)]
    result[j = multiplier := 1]
    result[OFlights == "YES", multiplier := 2]
    result[j = flight_metric := scale((Flight99 * multiplier) / 100) + 1]
    result <- result[j = list(RWU, flight_metric)]
    result[]
    return(result)
}
