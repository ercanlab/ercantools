# Violin + box plot for all chromosomes separately (normalized binding counts)

For each chromosome, draws paired violins for two experimental
conditions (ex. degron/notag) and compares them with
[`ggpubr::stat_compare_means()`](https://rpkgs.datanovia.com/ggpubr/reference/stat_compare_means.html).

## Usage

``` r
violin_counts_all_chr(
  object = NULL,
  title = NULL,
  subtitle = NULL,
  ylab = "log2(Normalized binding counts)",
  xlab = NULL,
  conc_condition = "Conc_degron",
  condition_name = "degron",
  conc_baseline = "Conc_notag",
  baseline_name = "notag",
  chr_col = "seqnames",
  chr_of_interest = "chrX",
  ylim = c(0, 12),
  chromosomes = .elegans_chr_order(),
  color_condition = "#ff6347ff",
  color_baseline = "#4682b4ff",
  output_pdf = NULL,
  pdf_width = 14,
  pdf_height = 7
)
```

## Arguments

- object:

  A `data.frame` or `tibble`.

- title:

  Character. Main plot title. Default `NULL`.

- subtitle:

  Character. Plot subtitle. Default `NULL`.

- ylab:

  Character. Y-axis label. Default `log2(Normalized binding counts)`.

- xlab:

  Character. X-axis label. Default `NULL`.

- conc_condition:

  Character. Column name for condition counts. Default `"Conc_degron"`.

- condition_name:

  Character. Display name for condition. Default `"degron"`.

- conc_baseline:

  Character. Column name for baseline counts. Default `"Conc_notag"`.

- baseline_name:

  Character. Display name for baseline. Default `"notag"`.

- chr_col:

  Character. Chromosome column name. Default `"seqnames"`.

- chr_of_interest:

  Character. Chromosome to highlight. Default `"chrX"`.

- ylim:

  Numeric vector of length 2. Default `c(0, 12)`.

- chromosomes:

  Character vector. Chromosomes included and their order.

- color_condition:

  Character. Fill colour for condition. Default `"#ff6347ff"`.

- color_baseline:

  Character. Fill colour for baseline. Default `"#4682b4ff"`.

- output_pdf:

  Character. Optional path to save plot as PDF. Default `NULL`.

- pdf_width:

  Numeric. Default `14`.

- pdf_height:

  Numeric. Default `7`.

## Value

A [ggplot2::ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)
object.

## Examples

``` r
if (FALSE) { # \dontrun{
violin_counts_all_chr(
  object           = my_peaks,
  title            = "Normalized counts per chromosome",
  conc_condition   = "Conc_degron",
  conc_baseline    = "Conc_notag"
)
} # }
```
