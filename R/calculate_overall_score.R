#' @title Calculate the Overall SOM Score
#' @description Calculate the overall score for all units in a Squadron of Merit Listing.
#' @details
#' Each of the component scores are calculated and a total score is obtained by weighting these
#' scores equally. If you want to change the weights, pass a named vector to `score_weights`.
#'
#' You can pass a different growth focus area through using `growth_focus_area`. Similarly, you can
#' pass a different set of award weights to the achievement score using `achv_award_weights`.
#' @param som_report_path A path to the Squadron of Merit Listing report in CSV format.
#' @param score_weights Weights for the five component scores.
#' @param growth_focus_area The focus area for growth scoring, which defaults to "balanced".
#' @param achv_award_weights Weights for the major cadet awards, from Wright Brothers to Spaatz.
#' @return A data.table containing unit charter number, the component scores, and the overall score.
#' @export

calculate_overall_score <- function(
    som_report_path,
    score_weights = c(strength = 1,
                      growth = 1,
                      achv = 1,
                      enc = 1,
                      flight = 1),
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

    # Merge them together
    result <- merge(strength_score, growth_score, by = "RWU")
    result <- merge(result, achv_score, by = "RWU")
    result <- merge(result, enc_score, by = "RWU")
    result <- merge(result, flight_score, by = "RWU")

    # Apply weights
    result[j = weighted_strength_score := strength_score * score_weights["strength"]]
    result[j = weighted_growth_score := growth_score * score_weights["growth"]]
    result[j = weighted_achv_score := achv_score * score_weights["achv"]]
    result[j = weighted_enc_score := enc_score * score_weights["enc"]]
    result[j = weighted_flight_score := flight_score * score_weights["flight"]]

    # Get score
    result[j = overall_score := (
        weighted_strength_score
        + weighted_growth_score
        + weighted_achv_score
        + weighted_enc_score
        + weighted_flight_score
    )]
    result[]
    return(result)
}
