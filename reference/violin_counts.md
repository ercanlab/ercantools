# Creates violin-box plots to compare normalized binding counts values between different conditions and chromosomes, typically comparing X chromosome vs autosomes.

Creates violin-box plots to compare normalized binding counts values
between different conditions and chromosomes, typically comparing X
chromosome vs autosomes.

## Usage

``` r
violin_counts(
  object = NULL,
  title = NULL,
  subtitle = NULL,
  ylab = NULL,
  xlab = NULL,
  conc_condition = "Conc_degron",
  condition_name = "degron",
  conc_baseline = "Conc_notag",
  baseline_name = "notag",
  chr_col = "seqnames",
  chr_of_interest = "chrX",
  label.y_plot = c(9, 10, 11, 12),
  ylim = c(0, 12),
  colors = c("#4682b4ff", "#ff6347ff", "#4682b4ff", "#ff6347ff"),
  pvalue_y_position = 1.5
)
```

## Arguments

- object:

  Data frame containing chromosomal and normalized binding counts,
  concentration from diffbind report output.

- title:

  Plot title

- subtitle:

  Plot subtitle

- ylab:

  Y-axis label (if NULL, a default will be created)

- xlab:

  X-axis label

- conc_condition:

  Column name for condition concentration values

- condition_name:

  Name to use for the condition in labels

- conc_baseline:

  Column name for baseline concentration values

- baseline_name:

  Name to use for the baseline in labels

- chr_col:

  Column name containing chromosome information

- chr_of_interest:

  Chromosome of interest to separate (e.g., "chrX")

- label.y_plot:

  Y positions for statistical test labels

- ylim:

  Y-axis limits

- colors:

  Vector of colors for the different groups

- pvalue_y_position:

  Y position for sample size labels

## Value

A ggplot object containing the violin and box plots

## Examples

``` r
# Example usage:
# violin_box_conc(df, title = "Concentration Comparison", chr_of_interest = "chrX")
```
