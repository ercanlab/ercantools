# ercantools: Visualization and Analysis Tools for ChIP-seq Differential Binding Data

`ercantools` provides a suite of plotting and statistical analysis
functions for ChIP-seq differential binding data, designed to work
directly with [DiffBind](https://bioconductor.org/packages/DiffBind/)
output.

### Function families

- **Violin plots**:
  [`violin_log2FC()`](https://ercanlab.github.io/ercantools/reference/violin_log2FC.md),
  [`violin_counts()`](https://ercanlab.github.io/ercantools/reference/violin_counts.md),
  [`violin_log2FC_all_chr()`](https://ercanlab.github.io/ercantools/reference/violin_log2FC_all_chr.md),
  [`violin_counts_all_chr()`](https://ercanlab.github.io/ercantools/reference/violin_counts_all_chr.md)

- **T-test scatter plots**:
  [`ttest_scatter()`](https://ercanlab.github.io/ercantools/reference/ttest_scatter.md)

- **DiffBind diagnostic plots**:
  [`plot_md()`](https://ercanlab.github.io/ercantools/reference/plot_md.md),
  [`plot_distributions()`](https://ercanlab.github.io/ercantools/reference/plot_distributions.md)

- **Peak utilities**:
  [`find_overlap_peaks()`](https://ercanlab.github.io/ercantools/reference/find_overlap_peaks.md),
  [`upset_peaks()`](https://ercanlab.github.io/ercantools/reference/upset_peaks.md)

### Organism defaults

Functions are designed for *C. elegans* (chrI-V + chrX) by default, but
all chromosome parameters are fully configurable for other organisms.

### Example data

A synthetic dataset mimicking DiffBind output is included:

    data(example_peaks)

## See also

Useful links:

- <https://github.com/ercanlab/ercantools>

- <https://ercanlab.github.io/ercantools>

- Report bugs at <https://github.com/ercanlab/ercantools/issues>

## Author

**Maintainer**: Daniel Garbozo <dg4739@nyu.edu>

Other contributors:

- Sevinc Ercan <sercan@nyu.edu> \[contributor\]
