# Violin + box plot for all chromosomes separately (log2 fold change)

Draws one violin + boxplot per chromosome and compares each autosome
against the chromosome of interest using
[`ggpubr::stat_compare_means()`](https://rpkgs.datanovia.com/ggpubr/reference/stat_compare_means.html).

## Usage

``` r
violin_log2FC_all_chr(
  object = NULL,
  title = NULL,
  subtitle = NULL,
  ylab = "log2 Fold Change",
  xlab = NULL,
  log2FC_col = "Fold",
  chr_col = "seqnames",
  chr_of_interest = "chrX",
  color_chr_of_interest = "#EF9A9A",
  color_other_chr = c("#4DB6AC", "#4DB6AC", "#4DB6AC", "#4DB6AC", "#4DB6AC"),
  ylim = c(-2, 2),
  chromosomes = .elegans_chr_order(),
  output_pdf = NULL,
  pdf_width = 12,
  pdf_height = 6
)
```

## Arguments

- object:

  A `data.frame` or `tibble` from `DiffBind::dba.report()`.

- title:

  Character. Main plot title. Default `NULL`.

- subtitle:

  Character. Plot subtitle. Default `NULL`.

- ylab:

  Character. Y-axis label. Default `log2 Fold Change`.

- xlab:

  Character. X-axis label. Default `NULL`.

- log2FC_col:

  Character. Column name for log2 fold-change. Default `"Fold"`.

- chr_col:

  Character. Column name for chromosome identifiers. Default
  `"seqnames"`.

- chr_of_interest:

  Character. Chromosome to highlight. Default `"chrX"`.

- color_chr_of_interest:

  Character. Fill colour for chrX. Default `"#EF9A9A"`.

- color_other_chr:

  Character. Fill colour for autosomes. Default `"#4DB6AC"`.

- ylim:

  Numeric vector of length 2. Y-axis limits. Default `c(-2, 2)`.

- chromosomes:

  Character vector. Chromosomes to include and their order. Default
  is C. elegans order:
  `c("chrI","chrII","chrIII","chrIV","chrV","chrX")`.

- output_pdf:

  Character. Optional path to save plot as PDF. Default `NULL`.

- pdf_width:

  Numeric. PDF width in inches. Default `12`.

- pdf_height:

  Numeric. PDF height in inches. Default `6`.

## Value

A [ggplot2::ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)
object.

## Examples

``` r
if (FALSE) { # \dontrun{
violin_log2FC_all_chr(
  object          = my_peaks,
  title           = "log2FC per chromosome",
  chr_of_interest = "chrX",
  ylim            = c(-2, 2)
)
} # }
```
