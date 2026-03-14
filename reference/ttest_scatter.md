# Dot plot of -log10(p-value) for log2 fold-change comparisons along chromosomes

For each chromosome, runs a Welch t-test on log2 fold-change values
("Autosome vs Autosomes" and "X vs Autosomes") and displays results as a
dot plot.

## Usage

``` r
ttest_scatter(
  object = NULL,
  title = NULL,
  subtitle = NULL,
  ylab = "-log10(p-value)",
  fc_col = "Fold",
  chr_col = "seqnames",
  autosomes = c("chrI", "chrII", "chrIII", "chrIV", "chrV"),
  chr_X = "chrX",
  chr_colors = c(chrI = "#66C2A5", chrII = "#FC8D62", chrIII = "#8DA0CB", chrIV =
    "#E78AC3", chrV = "#A6D854", chrX = "#EF9A9A"),
  pvalue_threshold_y = -log10(0.05),
  pvalue_y_position_offset = 0.5,
  pvalue_x_position = 6,
  output_pdf = NULL,
  pdf_width = 8,
  pdf_height = 6
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

  Character. Y-axis label. Default `"-log10(p-value)"`.

- fc_col:

  Character. Column name for log2 fold-change. Default `"Fold"`.

- chr_col:

  Character. Chromosome column name. Default `"seqnames"`.

- autosomes:

  Character vector. Autosome names.

- chr_X:

  Character. Sex chromosome name. Default `"chrX"`.

- chr_colors:

  Named character vector. Colors per chromosome.

- pvalue_threshold_y:

  Numeric. Significance threshold on -log10 scale. Default
  `-log10(0.05)`.

- pvalue_y_position_offset:

  Numeric. Vertical offset (in plot units) for placing the p-value
  threshold label above the horizontal reference line. Default: `0.5`.

- pvalue_x_position:

  Numeric. Absolute X position (in plot units) for p-value threshold
  label, right of the plot. Default `6`.

- output_pdf:

  Character. Optional PDF output path. Default `NULL`.

- pdf_width:

  Numeric. Default `8`.

- pdf_height:

  Numeric. Default `6`.

## Value

A named list with `plot` and `results`.

## Examples

``` r
if (FALSE) { # \dontrun{
res <- ttest_scatter(
  object = my_peaks,
  title  = "FC t-test (Autosome vs Autosomes and X vs Autosomes)"
)
res$plot
} # }
```
