# MA / MD plot for differential binding results

Plots log2 fold-change (y-axis) against average abundance/normalized
binding counts (x-axis), with points coloured by significance status.
Optionally labels a user-provided set of peaks with
[`ggrepel::geom_label_repel()`](https://ggrepel.slowkow.com/reference/geom_text_repel.html).

## Usage

``` r
plot_md(
  object,
  x_var = "Conc",
  y_var = "Fold",
  fdr_var = "FDR",
  cutoff_y = 1,
  cutoff_FDR = 0.05,
  y_max = 3,
  y_min = -3,
  label_var = NULL,
  peaks = NULL,
  title = "MD Plot",
  colors = c("red", "grey70", "blue")
)
```

## Arguments

- object:

  A `data.frame` or `tibble` — typically the output of
  `DiffBind::dba.report()` coerced to a data frame.

- x_var:

  Character. Column with average abundance(normalized binding counts).
  Default `"Conc"`.

- y_var:

  Character. Column with log2 fold-change. Default `"Fold"`.

- fdr_var:

  Character. Column with FDR values. Default `"FDR"`.

- cutoff_y:

  Numeric. log2FC threshold for coloring. Default `1`.

- cutoff_FDR:

  Numeric. FDR threshold for coloring. Default `0.05`.

- y_max:

  Numeric. Upper y-axis limit. Default `3`.

- y_min:

  Numeric. Lower y-axis limit. Default `-3`.

- label_var:

  Character. Column used for peak labels. Default `NULL`.

- peaks:

  Character vector. Peak IDs to label. Default `NULL`.

- title:

  Character. Plot title. Default `"MD Plot"`.

- colors:

  Character vector of length 3. Colors for up-regulated, no-change, and
  down-regulated points. Default `c("red", "grey70", "blue")`.

## Value

A [ggplot2::ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html)
object.

## Examples

``` r
if (FALSE) { # \dontrun{
plot_md(
  object  = my_peaks,
  x_var   = "Conc",
  y_var   = "Fold",
  fdr_var = "FDR",
  title   = "MD plot — degron vs notag"
)
} # }
```
