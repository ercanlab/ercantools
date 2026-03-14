#' Density or histogram of normalized binding counts per chromosome
#'
#' @description
#' Plots the distribution of normalized binding counts for two experimental
#' conditions, faceted by chromosome. Supports density and histogram
#' geometries, as well as overlaid or grid facetting.
#'
#' @param object A `data.frame` or `tibble`. Must contain a `seqnames` column.
#' @param title Character. Plot title. Default `NULL`.
#' @param subtitle Character. Plot subtitle. Default `NULL`.
#' @param chromosomes Character vector. Chromosomes to include.
#'   Default is C. elegans order.
#' @param conc_cols Named character vector mapping role to column name.
#'   Default `c(Conc_base = "Conc_notag", Conc_condition = "Conc_degron")`.
#' @param condition Character. Display name for condition. Default `"Degron"`.
#' @param baseline Character. Display name for baseline. Default `"NoTag"`.
#' @param type Character. `"density"` (default) or `"hist"`.
#' @param overlay Logical. If `TRUE` (default), conditions are overlaid within
#'   each chromosome facet. If `FALSE`, a `Condition ~ seqnames` grid is used.
#' @param ncol Integer. Number of facet columns. Default `3`.
#' @param free_y Logical. If `TRUE` (default), facet y-axes are free.
#' @param add_rug Logical. Add a rug to the x-axis? Default `FALSE`.
#'
#' @return A [ggplot2::ggplot] object.
#'
#' @examples
#' \dontrun{
#' plot_distributions(
#'   object    = my_peaks,
#'   title     = "Binding count distributions",
#'   condition = "Degron",
#'   baseline  = "NoTag"
#' )
#' }
#'
#' @export
plot_distributions <- function(object,
                               title       = NULL,
                               subtitle    = NULL,
                               chromosomes = .elegans_chr_order(),
                               conc_cols   = c(Conc_base      = "Conc_notag",
                                               Conc_condition = "Conc_degron"),
                               condition   = "Degron",
                               baseline    = "NoTag",
                               type        = c("density", "hist"),
                               overlay     = TRUE,
                               ncol        = 3,
                               free_y      = TRUE,
                               add_rug     = FALSE) {

  type <- match.arg(type)

  stopifnot("seqnames" %in% names(object))
  .check_cols(object, unname(conc_cols),
              arg_names = paste0("conc_cols['", names(conc_cols), "']"))

  df_long <- object %>%
    dplyr::select(seqnames, dplyr::all_of(unname(conc_cols))) %>%
    tidyr::pivot_longer(
      cols      = dplyr::all_of(unname(conc_cols)),
      names_to  = "Condition_raw",
      values_to = "Conc"
    ) %>%
    dplyr::mutate(
      Condition = dplyr::recode(
        Condition_raw,
        !!conc_cols[1] := baseline,
        !!conc_cols[2] := condition
      ),
      seqnames  = factor(seqnames, levels = chromosomes),
      Conc_plot = Conc
    ) %>%
    dplyr::filter(!is.na(seqnames), is.finite(Conc))

  cond_cols        <- c("#1f77b4", "#ff7f0e")
  names(cond_cols) <- c(baseline, condition)

  p <- ggplot2::ggplot(
    df_long,
    ggplot2::aes(x = Conc_plot, color = Condition, fill = Condition)
  )

  if (type == "density") {
    p <- p + ggplot2::geom_density(alpha = 0.25, linewidth = 0.8, na.rm = TRUE)
  } else {
    p <- p + ggplot2::geom_histogram(
      position = "identity", alpha = 0.4, binwidth = 1,
      boundary = 0, closed = "left", na.rm = TRUE
    )
  }

  if (overlay) {
    p <- p + ggplot2::facet_wrap(
      ~ seqnames, ncol = ncol,
      scales = if (free_y) "free_y" else "fixed"
    )
  } else {
    p <- p + ggplot2::facet_grid(
      Condition ~ seqnames,
      scales = if (free_y) "free_y" else "fixed"
    )
  }

  if (add_rug) p <- p + ggplot2::geom_rug(alpha = 0.3, sides = "b")

  n_label <- df_long %>%
    dplyr::group_by(seqnames, Condition) %>%
    dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
    dplyr::mutate(label = paste0("n = ", n))

  p <- p +
    ggplot2::scale_color_manual(values = cond_cols) +
    ggplot2::scale_fill_manual(values = cond_cols) +
    ggplot2::labs(
      title    = title,
      subtitle = subtitle,
      x        = expression("log"[2] * "(Normalized Binding Counts)"),
      y        = if (type == "density") "Density" else "Frequency",
      color    = "Condition",
      fill     = "Condition",
      caption  = sprintf("n = %d peaks", nrow(object))
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      plot.title    = ggplot2::element_text(hjust = 0.5),
      plot.subtitle = ggplot2::element_text(hjust = 0.5)
    ) +
    ggplot2::geom_text(
      data        = n_label,
      ggplot2::aes(x = -Inf, y = Inf,
                   label = label, color = Condition),
      inherit.aes = FALSE,
      hjust = -0.1, vjust = 1.8, size = 3.5
    )
  return(p)
}
