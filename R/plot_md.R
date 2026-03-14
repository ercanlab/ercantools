#' MA / MD plot for differential binding results
#'
#' @description
#' Plots log2 fold-change (y-axis) against average abundance/normalized binding counts
#' (x-axis), with points coloured by significance status. Optionally labels
#' a user-provided set of peaks with [ggrepel::geom_label_repel()].
#'
#' @param object A `data.frame` or `tibble` — typically the output of
#'   `DiffBind::dba.report()` coerced to a data frame.
#' @param x_var Character. Column with average abundance(normalized binding counts). Default `"Conc"`.
#' @param y_var Character. Column with log2 fold-change. Default `"Fold"`.
#' @param fdr_var Character. Column with FDR values. Default `"FDR"`.
#' @param cutoff_y Numeric. log2FC threshold for coloring. Default `1`.
#' @param cutoff_FDR Numeric. FDR threshold for coloring. Default `0.05`.
#' @param y_max Numeric. Upper y-axis limit. Default `3`.
#' @param y_min Numeric. Lower y-axis limit. Default `-3`.
#' @param label_var Character. Column used for peak labels. Default `NULL`.
#' @param peaks Character vector. Peak IDs to label. Default `NULL`.
#' @param title Character. Plot title. Default `"MD Plot"`.
#' @param colors Character vector of length 3. Colors for up-regulated,
#'   no-change, and down-regulated points.
#'   Default `c("red", "grey70", "blue")`.
#'
#' @return A [ggplot2::ggplot] object.
#'
#' @examples
#' \dontrun{
#' plot_md(
#'   object  = my_peaks,
#'   x_var   = "Conc",
#'   y_var   = "Fold",
#'   fdr_var = "FDR",
#'   title   = "MD plot — degron vs notag"
#' )
#' }
#'
#' @export
plot_md <- function(object,
                    x_var     = "Conc",
                    y_var     = "Fold",
                    fdr_var   = "FDR",
                    cutoff_y   = 1,
                    cutoff_FDR = 0.05,
                    y_max      = 3,
                    y_min      = -3,
                    label_var  = NULL,
                    peaks      = NULL,
                    title      = "MD Plot",
                    colors     = c("red", "grey70", "blue")) {

  if (!requireNamespace("ggrepel", quietly = TRUE)) {
    stop("Package 'ggrepel' is required: install.packages('ggrepel')",
         call. = FALSE)
  }

  .check_cols(object, c(x_var, y_var, fdr_var),
              arg_names = c("x_var", "y_var", "fdr_var"))

  d <- data.frame(object)
  d <- d[!is.na(d[[y_var]]), ]

  d$sig_color <- "No significant"
  d$sig_color[d[[y_var]] >=  cutoff_y & d[[fdr_var]] < cutoff_FDR] <- "Up-regulated"
  d$sig_color[d[[y_var]] <= -cutoff_y & d[[fdr_var]] < cutoff_FDR] <- "Down-regulated"

  cond <- if (is.null(peaks) || is.null(label_var)) {
    rep(FALSE, nrow(d))
  } else {
    d[[label_var]] %in% peaks
  }

  y_limits <- c(min(y_min, -y_max), y_max)

  n_sig <- nrow(d[!is.na(d[[fdr_var]]) & d[[fdr_var]] < cutoff_FDR, ])

  p <- ggplot2::ggplot(d, ggplot2::aes(x = .data[[x_var]],
                                       y = .data[[y_var]])) +
    ggplot2::theme_bw() +
    ggplot2::geom_point(
      ggplot2::aes(fill = sig_color),
      shape = 21, color = "black", alpha = 0.6, size = 3
    ) +
    ggplot2::scale_fill_manual(
      values = c("Up-regulated"   = colors[1],
                 "No significant" = colors[2],
                 "Down-regulated" = colors[3]),
      name = "Expression"
    ) +
    ggplot2::geom_hline(yintercept = c(-cutoff_y, cutoff_y),
                        linetype = 2, color = "grey40") +
    ggplot2::geom_hline(yintercept = 0,
                        linetype = 1, color = "grey20", alpha = 0.5) +
    ggplot2::coord_cartesian(ylim = y_limits) +
    ggplot2::labs(
      x        = expression("log"[2] * "(Normalized Binding Counts)"),
      y        = expression("log"[2] * "(Fold Change)"),
      title    = title,
      subtitle = paste("n(FDR <", cutoff_FDR, "):", n_sig)
    ) +
    ggplot2::theme(
      plot.title    = ggplot2::element_text(size = 16, hjust = 0.5),
      plot.subtitle = ggplot2::element_text(size = 12, hjust = 0.5),
      axis.text     = ggplot2::element_text(size = 12),
      axis.title    = ggplot2::element_text(size = 14)
    )

  if (any(cond)) {
    p <- p + ggrepel::geom_label_repel(
      data        = d[cond, ],
      ggplot2::aes(label = .data[[label_var]]),
      size        = 4,
      box.padding = 0.5
    )
  }

  return(p)
}
