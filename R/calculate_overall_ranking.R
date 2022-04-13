#' @title Calculate the Overall SOM Ranking
#' @description Calculate the overall ranking for all units in a Squadron of Merit Listing.
#' @details
#' Each of the component scores are calculated and the scores are ranked from 1 to N, using
#' standard competition ranking (SCR). The individual ranks are summed and then the overall ranking
#' is determined.
#'
#' You can pass a different growth focus area through using `growth_focus_area`. Similarly, you can
#' pass a different set of award weights to the achievement score using `achv_award_weights`.
#' @param som_report_path A path to the Squadron of Merit Listing report in CSV format.
#' @param growth_focus_area The focus area for growth scoring, which defaults to "balanced".
#' @param achv_award_weights Weights for the major cadet awards, from Wright Brothers to Spaatz.
#' @return A data.table containing unit charter number, the component scores and rankings,
#' and the overall ranking.
#' @export

calculate_overall_ranking <- function(
    som_report_path,
    growth_focus_area = "balanced",
    achv_award_weights = c(1, 2, 2, 3, 3)
) {
    som_data <- CAP.SOMCalc::load_som_report(som_report_path)

    # Calculate the five scores
    strength_score <- CAP.SOMCalc::calculate_strength_score(som_data)
    growth_score <- CAP.SOMCalc::calculate_growth_score(som_data, focus_area = growth_focus_area)
    achv_score <- CAP.SOMCalc::calculate_achv_score(som_data, award_weights = achv_award_weights)
    enc_score <- CAP.SOMCalc::calculate_enc_score(som_data)
    flight_score <- CAP.SOMCalc::calculate_flight_score(som_data)

    # Next, add the rankings
    strength_score[j = strength_rank := rank(-strength_score, ties.method = "min")]
    growth_score[j = growth_rank := rank(-growth_score, ties.method = "min")]
    achv_score[j = achv_rank := rank(-achv_score, ties.method = "min")]
    enc_score[j = enc_rank := rank(-enc_score, ties.method = "min")]
    flight_score[j = flight_rank := rank(-flight_score, ties.method = "min")]

    # Merge them together
    result <- merge(strength_score, growth_score, by = "RWU")
    result <- merge(result, achv_score, by = "RWU")
    result <- merge(result, enc_score, by = "RWU")
    result <- merge(result, flight_score, by = "RWU")

    # Get ranking
    result[j = rank_sum := (
        strength_rank
        + growth_rank
        + achv_rank
        + enc_rank
        + flight_rank
    )]
    result[j = overall_ranking := rank(rank_sum, ties.method = "min")]
    result[]
    return(result)
}
