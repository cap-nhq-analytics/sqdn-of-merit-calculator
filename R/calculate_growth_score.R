#' @title Calculate the Growth Score
#' @description Calculate the growth score for all units in a Squadron of Merit Listing.
#' @details
#' The default growth score is calculated by awarding 2 points for every cadet who joins or renews,
#' giving equal weighting to both recruiting and retention. The `focus_area` variable can be used to
#' change this.
#'
#' Use `recruiting` to award 3 points for every new cadet and 1 point for every renewal.
#' Use `retention` to award 1 point for every new cadet and 3 points for every renewal.
#'
#' The final result is then standardized using the distribution of the scores to have a mean of 1
#' and standard deviation of 1.
#' @param som_report A data.table containing the Squadron of Merit Listing data.
#' @param focus_area The focus area for scoring, which defaults to "balanced".
#' @return A data.table containing the unit charter number and the growth score.
#' @export

calculate_growth_score <- function(som_report, focus_area = "balanced") {
    result <- som_report[j = list(RWU, NewCdt, TotalRenewed)]
    if (focus_area == "recruiting") {
        print("Using recruiting weights")
        weights <- c(3, 1)
    } else if (focus_area == "retention") {
        print("Using retention weights")
        weights <- c(1, 3)
    } else {
        print("Using balanced weights")
        weights <- c(2, 2)
    }
    result[j = growth_score := scale(NewCdt * weights[1] + TotalRenewed * weights[2]) + 1]
    result <- result[j = list(RWU, growth_score)]
    result[]
    return(result)
}
