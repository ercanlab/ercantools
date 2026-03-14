#' Example ChIP-seq differential binding peaks
#'
#' @description
#' A synthetic dataset of 2000 ChIP-seq peaks designed to mimic the output of
#' `DiffBind::dba.report(dba, th = 1, bCounts = TRUE)` for a *C. elegans*
#' dosage compensation experiment.
#'
#' Peaks on chrX are simulated to have higher fold change under the degron
#' condition, reflecting dosage compensation loss when the relevant factor
#' is degraded.
#'
#' @format A `data.frame` with 2000 rows and 11 columns:
#' \describe{
#'   \item{seqnames}{Character. Chromosome name (`chrI`-`chrV`, `chrX`).}
#'   \item{start}{Integer. Peak start position (bp).}
#'   \item{end}{Integer. Peak end position (bp).}
#'   \item{width}{Integer. Peak width in bp (always 501).}
#'   \item{strand}{Character. Always `"*"` (unstranded ChIP-seq).}
#'   \item{Conc}{Numeric. Average normalized binding count across conditions.}
#'   \item{Conc_degron}{Numeric. Normalized counts for the degron condition.}
#'   \item{Conc_notag}{Numeric. Normalized counts for the no-tag baseline.}
#'   \item{Fold}{Numeric. log2 fold change (degron / notag).}
#'   \item{p.value}{Numeric. Raw p-value from DiffBind.}
#'   \item{FDR}{Numeric. Benjamini-Hochberg adjusted p-value.}
#' }
#'
#' @source Generated synthetically via `data-raw/example_peaks.R`.
#'   Proportions and effect sizes are based on a real *C. elegans*
#'   dosage compensation ChIP-seq experiment.
#'
#' @examples
#' data(example_peaks)
#' head(example_peaks)
#' table(example_peaks$seqnames)
#'
#' # Quick violin plot
#' violin_log2FC(
#'   object = example_peaks,
#'   title  = "log2FC: chrX vs autosomes"
#' )
"example_peaks"
