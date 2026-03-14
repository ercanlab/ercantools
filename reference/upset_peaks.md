# UpSet plot for peak category overlaps

Creates an
[`UpSetR::upset()`](https://rdrr.io/pkg/UpSetR/man/upset.html) plot from
a peak data frame containing logical `has_overlap_*` columns produced by
repeated calls to
[`find_overlap_peaks()`](https://ercanlab.github.io/ercantools/reference/find_overlap_peaks.md).
Any column matching `has_overlap_` is automatically detected if `sets`
is `NULL`.

## Usage

``` r
upset_peaks(
  object,
  sets = NULL,
  set_labels = NULL,
  order_by = "freq",
  set_colors = c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#A65628"),
  title = NULL,
  output_pdf = NULL,
  width = 12,
  height = 8
)
```

## Arguments

- object:

  A `data.frame` with logical columns named `has_overlap_*`.

- sets:

  Character vector. Column names to include. If `NULL` (default), all
  `has_overlap_*` columns are used automatically.

- set_labels:

  Character vector. Display labels for each set. If `NULL`, labels are
  derived by removing the `has_overlap_` prefix.

- order_by:

  Character. `"freq"` (default) or `"degree"`.

- set_colors:

  Character vector. Bar colours for each set.

- title:

  Character. Optional title above the plot. Default `NULL`.

- output_pdf:

  Character. Optional path to save PDF. Default `NULL`.

- width:

  Numeric. Plot width in inches. Default `12`.

- height:

  Numeric. Plot height in inches. Default `8`.

## Value

Invisibly returns the UpSet plot object.

## Examples

``` r
if (FALSE) { # \dontrun{
data(example_peaks)
example_peaks$has_overlap_promoter <- sample(c(TRUE, FALSE),
                                             nrow(example_peaks),
                                             replace = TRUE)
example_peaks$has_overlap_enhancer <- sample(c(TRUE, FALSE),
                                             nrow(example_peaks),
                                             replace = TRUE)
upset_peaks(example_peaks, title = "Peak category overlaps")
} # }
```
