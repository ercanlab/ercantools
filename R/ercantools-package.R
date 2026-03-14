#' ercantools: Visualization and Analysis Tools for ChIP-seq Differential Binding Data
#'
#' @description
#' `ercantools` provides a suite of plotting and statistical analysis functions
#' for ChIP-seq differential binding data, designed to work directly with
#' [DiffBind](https://bioconductor.org/packages/DiffBind/) output.
#'
#' ## Function families
#'
#' - **Violin plots**: [violin_log2FC()], [violin_counts()],
#'   [violin_log2FC_all_chr()], [violin_counts_all_chr()]
#' - **T-test scatter plots**: [ttest_scatter()]
#' - **DiffBind diagnostic plots**: [plot_md()], [plot_distributions()]
#' - **Peak utilities**: [find_overlap_peaks()], [upset_peaks()]
#'
#' ## Organism defaults
#'
#' Functions are designed for *C. elegans* (chrI-V + chrX) by default,
#' but all chromosome parameters are fully configurable for other organisms.
#'
#' ## Example data
#'
#' A synthetic dataset mimicking DiffBind output is included:
#' ```r
#' data(example_peaks)
#' ```
#'
#' @keywords internal
"_PACKAGE"
