# Density or histogram of normalized binding counts per chromosome

Plots the distribution of normalized binding counts for two experimental
conditions, faceted by chromosome. Supports density and histogram
geometries, as well as overlaid or grid facetting.

## Usage

``` r
plot_distributions(
  object,
  title = NULL,
  subtitle = NULL,
  chromosomes = .elegans_chr_order(),
  conc_cols = c(Conc_base = "Conc_notag", Conc_condition = "Conc_degron"),
  condition = "Degron",
  baseline = "NoTag",
  type = c("density", "hist"),
  overlay = TRUE,
  ncol = 3,
  free_y = TRUE,
  add_rug = FALSE
)
```

## Arguments

- object:

  A `data.frame` or `tibble`. Must contain a `seqnames` column.

- title:

  Character. Plot title. Default `NULL`.

- subtitle:

  Character. Plot subtitle. Default `NULL`.

- chromosomes:

  Character vector. Chromosomes to include. Default is C. elegans order.

- conc_cols:

  Named character vector mapping role to column name. Default
  `c(Conc_base = "Conc_notag", Conc_condition = "Conc_degron")`.

- condition:

  Character. Display name for condition. Default `"Degron"`.

- baseline:

  Character. Display name for baseline. Default `"NoTag"`.

- type:

  Character. `"density"` (default) or `"hist"`.

- overlay:

  Logical. If `TRUE` (default), conditions are overlaid within each
  chromosome facet. If `FALSE`, a `Condition ~ seqnames` grid is used.

- ncol:

  Integer. Number of facet columns. Default `3`.

- free_y:

  Logical. If `TRUE` (default), facet y-axes are free.

- add_rug:

  Logical. Add a rug to the x-axis? Default `FALSE`.

## Value

A [ggplot2::ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)
object.

## Examples

``` r
if (FALSE) { # \dontrun{
plot_distributions(
  object    = my_peaks,
  title     = "Binding count distributions",
  condition = "Degron",
  baseline  = "NoTag"
)
} # }
```
