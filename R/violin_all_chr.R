#' Violin + box plot for all chromosomes separately (log2 fold change)
#'
#' @description
#' Draws one violin + boxplot per chromosome and compares each autosome against
#' the chromosome of interest using [ggpubr::stat_compare_means()].
#'
#' @param object A `data.frame` or `tibble` from `DiffBind::dba.report()`.
#' @param title Character. Main plot title. Default `NULL`.
#' @param subtitle Character. Plot subtitle. Default `NULL`.
#' @param ylab Character. Y-axis label. Default `log2 Fold Change`.
#' @param xlab Character. X-axis label. Default `NULL`.
#' @param log2FC_col Character. Column name for log2 fold-change. Default `"Fold"`.
#' @param chr_col Character. Column name for chromosome identifiers. Default `"seqnames"`.
#' @param chr_of_interest Character. Chromosome to highlight. Default `"chrX"`.
#' @param color_chr_of_interest Character. Fill colour for chrX. Default `"#EF9A9A"`.
#' @param color_other_chr Character. Fill colour for autosomes. Default `"#4DB6AC"`.
#' @param ylim Numeric vector of length 2. Y-axis limits. Default `c(-2, 2)`.
#' @param chromosomes Character vector. Chromosomes to include and their order.
#'   Default is C. elegans order: `c("chrI","chrII","chrIII","chrIV","chrV","chrX")`.
#' @param output_pdf Character. Optional path to save plot as PDF. Default `NULL`.
#' @param pdf_width Numeric. PDF width in inches. Default `12`.
#' @param pdf_height Numeric. PDF height in inches. Default `6`.
#'
#' @return A [ggplot2::ggplot] object.
#'
#' @examples
#' \dontrun{
#' violin_log2FC_all_chr(
#'   object          = my_peaks,
#'   title           = "log2FC per chromosome",
#'   chr_of_interest = "chrX",
#'   ylim            = c(-2, 2)
#' )
#' }
#'
#' @export
violin_log2FC_all_chr <- function(object = NULL,
                                  title                 = NULL,
                                  subtitle              = NULL,
                                  ylab                  = "log2 Fold Change",
                                  xlab                  = NULL,
                                  log2FC_col            = "Fold",
                                  chr_col               = "seqnames",
                                  chr_of_interest       = "chrX",
                                  color_chr_of_interest = "#EF9A9A",
                                  color_other_chr       = c("#4DB6AC", "#4DB6AC", "#4DB6AC", "#4DB6AC", "#4DB6AC"),
                                  ylim                  = c(-2, 2),
                                  chromosomes           = .elegans_chr_order(),
                                  output_pdf            = NULL,
                                  pdf_width             = 12,
                                  pdf_height            = 6) {

  stopifnot(!is.null(object))
  .check_cols(object, c(log2FC_col, chr_col),
              arg_names = c("log2FC_col", "chr_col"))

  fc_df <- object %>%
    dplyr::select(dplyr::all_of(c(chr_col, log2FC_col))) %>%
    dplyr::rename(Chromosome = !!chr_col, log2FC = !!log2FC_col) %>%
    dplyr::filter(!is.na(log2FC), Chromosome %in% chromosomes) %>%
    dplyr::mutate(
      Chromosome_clean   = .clean_chr_name(Chromosome),
      Chromosome_clean   = factor(Chromosome_clean,
                                  levels = .clean_chr_name(chromosomes))
    )

  n_by_chr <- fc_df %>%
    dplyr::group_by(Chromosome_clean) %>%
    dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
    dplyr::mutate(label = paste0("n = ", n))

  chr_of_interest_clean <- .clean_chr_name(chr_of_interest)
  chr_levels      <- levels(fc_df$Chromosome_clean)
  autosome_levels <- chr_levels[chr_levels != chr_of_interest_clean]
  color_autosomes <- rep_len(color_other_chr, length(autosome_levels))
  names(color_autosomes) <- autosome_levels
  color_vec <- c(color_autosomes,
                 stats::setNames(color_chr_of_interest, chr_of_interest_clean))
  color_vec <- color_vec[chr_levels]

  autosome_median <- stats::median(
    fc_df$log2FC[fc_df$Chromosome != chr_of_interest], na.rm = TRUE
  )

  autosomes_clean <- .clean_chr_name(chromosomes)
  autosomes_clean <- autosomes_clean[autosomes_clean != chr_of_interest_clean]
  comparisons     <- lapply(autosomes_clean, function(x) c(x, chr_of_interest_clean))

  y_range     <- ylim[2] - ylim[1]
  label_y_pos <- seq(ylim[2] - y_range * 0.1,
                     ylim[2] + y_range * 0.3,
                     length.out = length(comparisons))

  p <- ggplot2::ggplot(
    fc_df,
    ggplot2::aes(x = Chromosome_clean, y = log2FC, fill = Chromosome_clean)
  ) +
    ggplot2::geom_violin(trim = FALSE, scale = "width",
                         color = "black", alpha = 0.4) +
    ggplot2::geom_boxplot(width = 0.10, outlier.shape = NA,
                          color = "black", fill = "white") +
    ggplot2::scale_fill_manual(values = color_vec) +
    ggplot2::labs(title = title, subtitle = subtitle, y = ylab, x = xlab) +
    ggplot2::theme_bw() +
    ggplot2::coord_cartesian(ylim = ylim) +
    ggplot2::theme(
      legend.position = "none",
      axis.text.x     = ggplot2::element_text(angle = 45, hjust = 1, size = 10),
      plot.title      = ggplot2::element_text(size = 12)
    ) +
    ggplot2::geom_hline(yintercept = 0,
                        linetype = "dashed", color = "grey20") +
    ggplot2::geom_hline(yintercept = autosome_median,
                        linetype = "dashed", color = "grey50") +
    ggplot2::geom_text(
      data        = n_by_chr,
      ggplot2::aes(x = Chromosome_clean,
                   y = ylim[1] - y_range * 0.08,
                   label = label),
      inherit.aes = FALSE, size = 3
    ) +
    ggpubr::stat_compare_means(
      method      = "t.test",
      comparisons = comparisons,
      label       = "p.signif",
      label.y     = label_y_pos,
      tip.length  = 0.01,
      size        = 3
    )

  if (!is.null(output_pdf)) {
    grDevices::pdf(output_pdf, width = pdf_width, height = pdf_height)
    print(p)
    grDevices::dev.off()
    message(sprintf("Plot saved to: %s", output_pdf))
  }

  p
}


#' Violin + box plot for all chromosomes separately (normalized binding counts)
#'
#' @description
#' For each chromosome, draws paired violins for two experimental conditions (ex. degron/notag)
#' and compares them with [ggpubr::stat_compare_means()].
#'
#' @param object A `data.frame` or `tibble`.
#' @param title Character. Main plot title. Default `NULL`.
#' @param subtitle Character. Plot subtitle. Default `NULL`.
#' @param ylab Character. Y-axis label. Default `log2(Normalized binding counts)`.
#' @param xlab Character. X-axis label. Default `NULL`.
#' @param conc_condition Character. Column name for condition counts. Default `"Conc_degron"`.
#' @param condition_name Character. Display name for condition. Default `"degron"`.
#' @param conc_baseline Character. Column name for baseline counts. Default `"Conc_notag"`.
#' @param baseline_name Character. Display name for baseline. Default `"notag"`.
#' @param chr_col Character. Chromosome column name. Default `"seqnames"`.
#' @param chr_of_interest Character. Chromosome to highlight. Default `"chrX"`.
#' @param ylim Numeric vector of length 2. Default `c(0, 12)`.
#' @param chromosomes Character vector. Chromosomes included and their order.
#' @param color_condition Character. Fill colour for condition. Default `"#ff6347ff"`.
#' @param color_baseline Character. Fill colour for baseline. Default `"#4682b4ff"`.
#' @param output_pdf Character. Optional path to save plot as PDF. Default `NULL`.
#' @param pdf_width Numeric. Default `14`.
#' @param pdf_height Numeric. Default `7`.
#'
#' @return A [ggplot2::ggplot] object.
#'
#' @examples
#' \dontrun{
#' violin_counts_all_chr(
#'   object           = my_peaks,
#'   title            = "Normalized counts per chromosome",
#'   conc_condition   = "Conc_degron",
#'   conc_baseline    = "Conc_notag"
#' )
#' }
#'
#' @export
violin_counts_all_chr <- function(object = NULL,
                                  title             = NULL,
                                  subtitle          = NULL,
                                  ylab              = "log2(Normalized binding counts)",
                                  xlab              = NULL,
                                  conc_condition    = "Conc_degron",
                                  condition_name    = "degron",
                                  conc_baseline     = "Conc_notag",
                                  baseline_name     = "notag",
                                  chr_col           = "seqnames",
                                  chr_of_interest   = "chrX",
                                  ylim              = c(0, 12),
                                  chromosomes       = .elegans_chr_order(),
                                  color_condition   = "#ff6347ff",
                                  color_baseline    = "#4682b4ff",
                                  output_pdf        = NULL,
                                  pdf_width         = 14,
                                  pdf_height        = 7) {

  stopifnot(!is.null(object))
  .check_cols(object, c(chr_col, conc_condition, conc_baseline),
              arg_names = c("chr_col", "conc_condition", "conc_baseline"))

  chr_present   <- intersect(chromosomes, unique(object[[chr_col]]))
  chr_clean_vec <- .clean_chr_name(chr_present)

  data_list <- lapply(chr_present, function(chr) {
    chr_label <- .clean_chr_name(chr)
    dplyr::bind_rows(
      tibble::tibble(
        Chromosome       = chr,
        Chromosome_label = chr_label,
        Treatment        = condition_name,
        Conc             = object[[conc_condition]][object[[chr_col]] == chr]
      ),
      tibble::tibble(
        Chromosome       = chr,
        Chromosome_label = chr_label,
        Treatment        = baseline_name,
        Conc             = object[[conc_baseline]][object[[chr_col]] == chr]
      )
    )
  })

  fc_df <- dplyr::bind_rows(data_list) %>%
    dplyr::filter(!is.na(Conc)) %>%
    dplyr::mutate(
      Chromosome_label = factor(Chromosome_label, levels = chr_clean_vec),
      Treatment        = factor(Treatment,
                                levels = c(baseline_name, condition_name))
    )

  group_levels <- unlist(lapply(chr_clean_vec, function(c)
    c(paste0(c, "_", baseline_name), paste0(c, "_", condition_name))))

  fc_df <- dplyr::mutate(
    fc_df,
    Group = factor(paste0(Chromosome_label, "_", Treatment),
                   levels = group_levels)
  )

  n_by_group <- fc_df %>%
    dplyr::group_by(Group, Chromosome_label, Treatment) %>%
    dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
    dplyr::mutate(label = paste0("n=", n))

  color_vec        <- rep(c(color_baseline, color_condition), length(chr_clean_vec))
  names(color_vec) <- group_levels

  baseline_autosome_med <- stats::median(
    fc_df$Conc[fc_df$Treatment == baseline_name &
                 fc_df$Chromosome != chr_of_interest], na.rm = TRUE
  )

  comparisons_within <- lapply(chr_clean_vec, function(chr)
    c(paste0(chr, "_", baseline_name), paste0(chr, "_", condition_name)))

  y_range        <- ylim[2] - ylim[1]
  label_y_within <- ylim[2] - y_range * 0.05
  x_labels       <- stats::setNames(gsub("_", "\n", group_levels), group_levels)

  p <- ggplot2::ggplot(
    fc_df, ggplot2::aes(x = Group, y = Conc, fill = Group)
  ) +
    ggplot2::geom_violin(trim = FALSE, scale = "width",
                         color = "black", alpha = 0.5) +
    ggplot2::geom_boxplot(width = 0.1, outlier.shape = NA,
                          color = "black", fill = "white", alpha = 0.7) +
    ggplot2::stat_summary(fun = stats::median, geom = "crossbar",
                          width = 0.2, linewidth = 0.3, color = "black") +
    ggplot2::scale_fill_manual(values = color_vec) +
    ggplot2::scale_x_discrete(labels = x_labels) +
    ggplot2::coord_cartesian(ylim = ylim) +
    ggplot2::labs(
      title    = title,
      subtitle = subtitle,
      y        = if (!is.null(ylab)) ylab else "log2(Normalized Binding Counts)",
      x        = xlab
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      legend.position  = "none",
      axis.text.x      = ggplot2::element_text(angle = 45, hjust = 1, size = 8),
      plot.title       = ggplot2::element_text(size = 11),
      panel.grid.minor = ggplot2::element_blank()
    ) +
    ggplot2::geom_hline(yintercept = baseline_autosome_med,
                        linetype = "dashed", color = "grey50") +
    ggplot2::geom_text(
      data        = n_by_group,
      ggplot2::aes(x = Group,
                   y = ylim[1] + y_range * 0.02,
                   label = label),
      inherit.aes = FALSE, size = 2.5, hjust = 0.5
    ) +
    ggpubr::stat_compare_means(
      method      = "t.test",
      comparisons = comparisons_within,
      label       = "p.signif",
      label.y     = label_y_within,
      tip.length  = 0.01,
      size        = 2.5
    ) +
    ggplot2::geom_vline(
      xintercept = seq(2.5, length(group_levels) - 0.5, by = 2),
      linetype   = "dotted", color = "grey70", alpha = 0.7
    )

  if (!is.null(output_pdf)) {
    grDevices::pdf(output_pdf, width = pdf_width, height = pdf_height)
    print(p)
    grDevices::dev.off()
    message(sprintf("Plot saved to: %s", output_pdf))
  }

  p
}
