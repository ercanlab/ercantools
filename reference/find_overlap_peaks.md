# Find overlapping peaks between two peak sets

Expands each peak to a window of `mid ± bp_distance` (where
`mid = (start + end) / 2`) and uses
[`GenomicRanges::findOverlaps()`](https://rdrr.io/pkg/GenomicRanges/man/findOverlaps-methods.html)
to identify which peaks in each set overlap with the other. A logical
`has_overlap_peak` column is appended to both data frames.

## Usage

``` r
find_overlap_peaks(df1, df2, bp_distance)
```

## Arguments

- df1:

  A `data.frame` with at least `seqnames`, `start`, and `end` columns.

- df2:

  A `data.frame` with the same requirements as `df1`.

- bp_distance:

  Numeric. Half-width in base pairs of the window around each peak
  midpoint used for overlap detection.

## Value

A named list with three elements:

- `df1`: input `df1` with an added `has_overlap_peak` logical column.

- `df2`: input `df2` with an added `has_overlap_peak` logical column.

- `df2_percentage`: Character string reporting the percentage of `df2`
  peaks that overlap `df1` (e.g., `"72.34% (362/500)"`).

## Examples

``` r
if (FALSE) { # \dontrun{
data(example_peaks)
peaks_a <- example_peaks[example_peaks$seqnames == "chrX", ]
peaks_b <- example_peaks[example_peaks$seqnames %in% c("chrX", "chrI"), ]

res <- find_overlap_peaks(peaks_a, peaks_b, bp_distance = 100)
cat(res$df2_percentage)
head(res$df1)
} # }
```
