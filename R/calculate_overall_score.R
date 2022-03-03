#' @title Calculate the Overall SOM Score
#' @description Calculate the overall score for all units in a Squadron of Merit Listing.
#' @details
#' Each of the metric scores are calculated and a total score is obtained by weighting these scores
#' equally. If you want to change the weights, pass a named vector to `metric_weights`.
#'
#' You can pass a different growth focus area through using `growth_focus_area`. Similarly, you can
#' pass a different set of award weights to the achievement meetric using `achv_award_weights`.
#' @param som_report_path A path to the Squadron of Merit Listing report in CSV format.
#' @param metric_weights Weights for the five metrics.
#' @param growth_focus_area The focus area for growth scoring, which defaults to "balanced".
#' @param achv_award_weights Weights for the major cadet awards, from Wright Brothers to Spaatz.
#' @return A data.table containing unit charter number, the metric scores, and the overall score.
#' @export

calculate_overall_score <- function(
    som_report_path,
    metric_weights = c(strength = 1,
                       growth = 1,
                       achv = 1,
                       enc = 1,
                       flight = 1),
    growth_focus_area = "balanced",
    achv_award_weights = c(1, 2, 2, 3, 3)
) {
    som_data <- CAP.SOMCalc::load_som_report(som_report_path)

    # Calculate the five metrics
    strength_metric <- CAP.SOMCalc::calculate_strength_metric(som_data)
    growth_metric <- CAP.SOMCalc::calculate_growth_metric(som_data, focus_area = growth_focus_area)
    achv_metric <- CAP.SOMCalc::calculate_achv_metric(som_data, award_weights = achv_award_weights)
    enc_metric <- CAP.SOMCalc::calculate_enc_metric(som_data)
    flight_metric <- CAP.SOMCalc::calculate_flight_metric(som_data)

    # Merge them together
    result <- merge(strength_metric, growth_metric, by = "RWU")
    result <- merge(result, achv_metric, by = "RWU")
    result <- merge(result, enc_metric, by = "RWU")
    result <- merge(result, flight_metric, by = "RWU")

    # Apply weights
    result[j = weighted_strength_metric := strength_metric * metric_weights["strength"]]
    result[j = weighted_growth_metric := growth_metric * metric_weights["growth"]]
    result[j = weighted_achv_metric := achv_metric * metric_weights["achv"]]
    result[j = weighted_enc_metric := enc_metric * metric_weights["enc"]]
    result[j = weighted_flight_metric := flight_metric * metric_weights["flight"]]

    # Get score
    result[j = overall_score := (
        weighted_strength_metric
        + weighted_growth_metric
        + weighted_achv_metric
        + weighted_enc_metric
        + weighted_flight_metric
    )]
    result[]
    return(result)
}
