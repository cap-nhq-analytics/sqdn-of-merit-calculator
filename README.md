# Overview

The package `CAP.SOMCalc` is intended to assist wings and regions in
calculating the Squadron of Merit / Squadron of Distinction every year.
It provides a consistent, documented, and repeatable process for
interpreting the statistical information published through eServices.

# Regulatory Guidance & Approach

[CAP Regulation
60-1](https://www.gocivilairpatrol.com/media/cms/R_601_D19B3E261AA1D.pdf)
provides some guidance on how to determine the Squadron of Merit. It
specifies:

> **6.6.1. Squadron of Merit.** The Squadron of Merit (SOM) is selected
> annually by the wing commander based on the unit’s performance during
> the preceding calendar year. Performance metrics are available in
> eServices to assist the commander in making the selection, but
> commanders may consider subjective matters in making their decisions.

[CAP Regulation
39-3](https://www.gocivilairpatrol.com/media/cms/R039_003_83459660D4F44.pdf)
provides additional information. It states:

> **a.** Each January, National Headquarters will make a statistical
> report available through the Member Reports restricted application in
> eServices to assist the commander in making a selection. The Squadron
> of Distinction selection should be based on the following criteria,
> but ultimately the selection is the commander’s prerogative:
>
> > **(1)** Squadron Strength - A minimum of 12 cadets at the beginning
> > of the calendar year.
> >
> > **(2)** Squadron Growth Rate - Reflected by an active recruiting and
> > retention program.
> >
> > **(3)** Cadet Achievement - Reflected by Mitchell, Earhart, Phase IV
> > and Spaatz awards earned during the calendar year.
> >
> > **(4)** Cadet Encampment Attendance - Reflected by first-time
> > encampment attendance of squadron cadets.
> >
> > **(5)** Cadet Orientation Flight Participation - Reflected by the
> > participation of squadron cadets in the Flight Orientation Program.

The metrics are provided via a report in eServices titled
`Squadron of Merit Listing`. This report provides the following
information:

-   Starting strength (`StartStr`) and ending strength (`EndStr`)
-   Number of new cadets (`NewCdt`) and total renewals (`TotalRenewed`)
-   The number of cadets receiving milestone awards (`WrightBrosCnt`,
    `MitchCnt`, `EarhCnt`, `EakerCnt`, `SpaatzCnt`)
-   The number of cadets attending their first Encampment (`FrstEncCnt`)
-   Orientation flights (`OFlights`)
    -   This metric is unclear - it is a categorical variable, either
        `YES` or `NO`, but it’s not clear what it represents
-   Syllabus 99 flights (`Flight99`)
    -   As with the previous metric, it’s not clear what this
        represents, but a reasonable assumption could be the number of
        syllabus 99 flights

*Note that when the report is exported in CSV format, several additional
ghost fields are present, titled Textbox119 to Textbox128. This appears
to be a formatting issue.*

Based on this guidance, five components can be identified to be used in
identifying the Squadron of Merit / Squadron of Distinction. These are:

-   strength, represented by the starting strength `StartStr`;
-   growth, represented by the `NewCdt` (for recruiting) and
    `TotalRenewed` (for retention) metrics;
-   achievement, represented by the milestone award counts;
-   encampment, represented by the `FrstEncCnt` metric, and;
-   flight, represented by `OFlights` and `Flight99`.

`CAP.SOMCalc` implements these five areas as **scores** calculated from
the `Squadron of Merit Listing` report. These five scores can be
combined to determine a Squadron of Merit selectee. There are two
methods available to combine the scores into a final result: the
**overall score** and the **overall ranking**.

-   The **overall score** is a weighted sum of the five scores; it
    defaults to weighting the five areas equally, but the weights can be
    customized. Since each score is standardized, large values in a
    specific score are less likely to skew the final results. However,
    the standardization is done using the mean and standard deviation of
    the specific score; extreme outliers in a specific area may still
    result in skewed results.
-   The **overall ranking** is created by generating the ranking from 1
    to N for each of the scores, and then summing all five rankings. The
    lowest sum is ranked first, the next lowest sum is second, and so
    on. In all cases involving ranking, the algorithm assigns ties the
    same rank, and then assigns the next lowest value to the rank that
    it would have received if there was no tie. For instance, the values
    of 2, 3, 3, 3, 6 would be ranked as 1, 2, 2, 2, 5. This is sometimes
    known as “Standard Competition Ranking” (SCR).

# Limitations

This package assumes that the data available through the
`Squadron of Merit Listing` report is valid, consistent, and free from
errors and anomalies. This is probably not the case in reality, but it
is not possible for most units to determine whether this data is
accurate or not - it would require consistent data from eServices over a
long period of time, which is not available for most users. In
particular, it is not clear how the report handles members who transfer
throughout the year - are they counted only once, or in each charter
they were in throughout the year? In addition, the flight metrics are
not obviously defined in any fashion, making it hard to determine how
best to interpret them.
