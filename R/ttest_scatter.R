#' Dot plot of -log10(p-value) for log2 fold-change comparisons along chromosomes
#'
#' @description
#' For each chromosome, runs a Welch t-test on log2 fold-change values
#' ("Autosome vs Autosomes" and "X vs Autosomes") and displays results as a dot plot.
#'
#' @param object A `data.frame` or `tibble`.
#' @param title Character. Main plot title. Default `NULL`.
#' @param subtitle Character. Plot subtitle. Default `NULL`.
#' @param ylab Character. Y-axis label. Default `"-log10(p-value)"`.
#' @param fc_col Character. Column name for log2 fold-change. Default `"Fold"`.
#' @param chr_col Character. Chromosome column name. Default `"seqnames"`.
#' @param autosomes Character vector. Autosome names.
#' @param chr_X Character. Sex chromosome name. Default `"chrX"`.
#' @param chr_colors Named character vector. Colors per chromosome.
#' @param pvalue_threshold_y Numeric. Significance threshold on -log10 scale.
#'   Default `-log10(0.05)`.
#' @param pvalue_y_position_offset Numeric. Vertical offset (in plot units) for placing
#' the p-value threshold label above the horizontal reference line.  Default: `0.5`.
#' @param pvalue_x_position Numeric. Absolute X position (in plot units)
#' for p-value threshold label, right of the plot. Default `6`.
#' @param output_pdf Character. Optional PDF output path. Default `NULL`.
#' @param pdf_width Numeric. Default `8`.
#' @param pdf_height Numeric. Default `6`.
#'
#' @return A named list with `plot` and `results`.
#'
#' @examples
#' \dontrun{
#' res <- ttest_scatter(
#'   object = my_peaks,
#'   title  = "FC t-test (Autosome vs Autosomes" and "X vs Autosomes)"
#' )
#' res$plot
#' }
#'
#' @export
ttest_scatter <- function(object = NULL,
                                 title              = NULL,
                                 subtitle           = NULL,
                                 ylab               = "-log10(p-value)",
                                 fc_col             = "Fold",
                                 chr_col            = "seqnames",
                                 autosomes          = c("chrI", "chrII",
                                                        "chrIII", "chrIV",
                                                        "chrV"),
                                 chr_X              = "chrX",
                                 chr_colors         = c(chrI   = "#66C2A5",
                                                        chrII  = "#FC8D62",
                                                        chrIII = "#8DA0CB",
                                                        chrIV  = "#E78AC3",
                                                        chrV   = "#A6D854",
                                                        chrX   = "#EF9A9A"),
                                 pvalue_threshold_y = -log10(0.05),
                                 pvalue_y_position_offset= 0.5,
                                 pvalue_x_position  = 6,
                                 output_pdf         = NULL,
                                 pdf_width          = 8,
                                 pdf_height         = 6) {

  stopifnot(!is.null(object))
  .check_cols(object, c(fc_col, chr_col),
              arg_names = c("fc_col", "chr_col"))

  all_chr <- c(autosomes, chr_X)
  results <- data.frame()

  for (chr in autosomes) {
    target    <- object[[fc_col]][object[[chr_col]] == chr]
    reference <- object[[fc_col]][object[[chr_col]] %in% setdiff(autosomes, chr)]
    results   <- rbind(results,
                       .run_ttest_fc(target, reference, chr,
                                     "Autosome vs Autosomes"))
  }

  target    <- object[[fc_col]][object[[chr_col]] == chr_X]
  reference <- object[[fc_col]][object[[chr_col]] %in% autosomes]
  results   <- rbind(results,
                     .run_ttest_fc(target, reference, chr_X,
                                   "X vs Autosomes"))

  results$chr_to_evaluate  <- factor(results$chr_to_evaluate, levels = all_chr)
  results$neg_log10_pvalue <- -log10(results$p_value)
  results$is_significant   <- results$neg_log10_pvalue > pvalue_threshold_y

  p <- ggplot2::ggplot(
    results,
    ggplot2::aes(x = chr_to_evaluate, y = neg_log10_pvalue,
                 color = chr_to_evaluate)
  ) +
    ggplot2::geom_point(size = 4, alpha = 0.8) +
    ggplot2::scale_color_manual(values = chr_colors) +
    ggplot2::labs(
      title    = title,
      subtitle = subtitle,
      x        = "Chromosome",
      y        = ylab
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      plot.title      = ggplot2::element_text(hjust = 0.5, size = 14,
                                              face = "bold"),
      plot.subtitle   = ggplot2::element_text(hjust = 0.5, size = 11),
      axis.text.x     = ggplot2::element_text(angle = 45, hjust = 1,
                                              size = 11, face = "bold"),
      axis.text.y     = ggplot2::element_text(size = 10),
      legend.position = "none"
    ) +
    ggplot2::geom_hline(yintercept = pvalue_threshold_y,
                        linetype = "dashed", color = "blue",
                        linewidth = 0.7) +
    ggplot2::annotate(
      "text",
      x     = pvalue_x_position,
      y     = -log10(0.05) + pvalue_y_position_offset,
      label = paste0("pval = ", round(10^(-pvalue_threshold_y), 3)),
      color = "blue", size = 4
    )

  if (!is.null(output_pdf)) {
    grDevices::pdf(output_pdf, width = pdf_width, height = pdf_height)
    print(p)
    grDevices::dev.off()
    message(sprintf("Plot saved to: %s", output_pdf))
  }

  list(plot = p, results = results)
}
