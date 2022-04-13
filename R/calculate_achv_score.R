#' @title Calculate the Achievement Score
#' @description Calculate the achievement score for all units in a Squadron of Merit Listing.
#' @details
#' By default, the achievement score awards 1 point for every Wright Brothers Award, 2 points for
#' every Mitchell and Earhart Award, and 3 points for every Eaker and Spaatz Award.
#'
#' You can pass an alternative vector of weights in to `award_weights` if you want to change these
#' weightings.
#'
#' The final result is then standardized using the distribution of the scores to have a mean of 1
#' and standard deviation of 1.
#' @param som_report A data.table containing the Squadron of Merit Listing data.
#' @param award_weights Weights for the five major awards, from Wright Brothers to Spaatz.
#' @return A data.table containing the unit charter number and the achievement score.
#' @export

calculate_achv_score <- function(som_report, award_weights = c(1, 2, 2, 3, 3)) {
    result <- som_report[j = list(RWU, WrightBrosCnt, MitchCnt, EarhCnt, EakerCnt, SpaatzCnt)]
    result[j = raw_score := (
        WrightBrosCnt * award_weights[1]
        + MitchCnt * award_weights[2]
        + EarhCnt * award_weights[3]
        + EakerCnt * award_weights[4]
        + SpaatzCnt * award_weights[5]
    )]
    result[j = achv_score := scale(raw_score) + 1]
    result <- result[j = list(RWU, achv_score)]
    result[]
    return(result)
}
