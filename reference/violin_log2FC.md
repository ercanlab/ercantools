# A function to generate violin-box plot to compare binding changes (log2FoldChange) between chromosome X and autosomes (A) based on ChIPseq data It also performs a t-test to assess statistical significance.

A function to generate violin-box plot to compare binding changes
(log2FoldChange) between chromosome X and autosomes (A) based on ChIPseq
data It also performs a t-test to assess statistical significance.

## Usage

``` r
violin_log2FC(
  object = NULL,
  title = NULL,
  subtitle = NULL,
  ylab = "log2 Fold Change",
  xlab = NULL,
  log2FC_col = "Fold",
  chr_col = "seqnames",
  chr_of_interest = "chrX",
  color_chr_of_interest = "#EF9A9A",
  color_other_chr = "#4DB6AC",
  ylim = c(-1, 1),
  pvalue_y_position = 0.9
)
```

## Arguments

- object:

  Data frame containing chromosomal and fold change data (diffbind
  report output)

- title:

  Plot title (optional)

- subtitle:

  Plot subtitle (optional)

- ylab:

  Character. Y-axis label. (default: "log2 Fold Change")

- xlab:

  X-axis label (optional)

- log2FC_col:

  Column name containing log2FoldChange values (default: "Fold")

- chr_col:

  Column name containing chromosome identifiers (default: "seqnames")

- chr_of_interest:

  Chromosome of interest to highlight (default: "chrX")

- color_chr_of_interest:

  Color for chromosome of interest (default: "#EF9A9A")

- color_other_chr:

  Color for other chromosomes (default: "#4DB6AC")

- ylim:

  Y-axis limits (default: c(-1,1))

- pvalue_y_position:

  Vertical position for p-value text (default: 0.9)

## Value

A ggplot object containing the violin and box plots

## Examples

``` r
if (FALSE) { # \dontrun{
# Basic usage with a data frame
violin_box(my_peaks, title = "Expression comparison", ylab = "log2FoldChange")

# Custom chromosome and colors
violin_box(my_peaks, chr_of_interest = "chr1",
          color_chr_of_interest = "red", color_other_chr = "blue")
} # }
```
