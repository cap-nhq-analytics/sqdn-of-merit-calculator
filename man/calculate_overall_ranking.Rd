% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calculate_overall_ranking.R
\name{calculate_overall_ranking}
\alias{calculate_overall_ranking}
\title{Calculate the Overall SOM Ranking}
\usage{
calculate_overall_ranking(
  som_report_path,
  growth_focus_area = "balanced",
  achv_award_weights = c(1, 2, 2, 3, 3)
)
}
\arguments{
\item{som_report_path}{A path to the Squadron of Merit Listing report in CSV format.}

\item{growth_focus_area}{The focus area for growth scoring, which defaults to "balanced".}

\item{achv_award_weights}{Weights for the major cadet awards, from Wright Brothers to Spaatz.}
}
\value{
A data.table containing unit charter number, the component scores and rankings,
and the overall ranking.
}
\description{
Calculate the overall ranking for all units in a Squadron of Merit Listing.
}
\details{
Each of the component scores are calculated and the scores are ranked from 1 to N, using
standard competition ranking (SCR). The individual ranks are summed and then the overall ranking
is determined.

You can pass a different growth focus area through using \code{growth_focus_area}. Similarly, you can
pass a different set of award weights to the achievement score using \code{achv_award_weights}.
}
