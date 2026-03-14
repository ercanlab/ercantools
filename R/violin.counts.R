##############################################
# Create violin-box plots for binding counts #
##############################################


#' Creates violin-box plots to compare normalized binding counts values between
#' different conditions and chromosomes, typically comparing X chromosome vs autosomes.
#' @param object Data frame containing chromosomal and normalized binding counts, concentration from diffbind report output.
#' @param title Plot title
#' @param subtitle Plot subtitle
#' @param ylab Y-axis label (if NULL, a default will be created)
#' @param xlab X-axis label
#' @param conc_condition Column name for condition concentration values
#' @param condition_name Name to use for the condition in labels
#' @param conc_baseline Column name for baseline concentration values
#' @param baseline_name Name to use for the baseline in labels
#' @param chr_col Column name containing chromosome information
#' @param chr_of_interest Chromosome of interest to separate (e.g., "chrX")
#' @param label.y_plot Y positions for statistical test labels
#' @param ylim Y-axis limits
#' @param colors Vector of colors for the different groups
#' @param pvalue_y_position Y position for sample size labels
#' @importFrom stats median
#' @importFrom magrittr %>%
#' @importFrom dplyr bind_rows filter mutate count
#' @importFrom tibble tibble
#' @importFrom ggplot2 ggplot aes geom_violin geom_boxplot stat_summary
#'   scale_fill_manual scale_x_discrete coord_cartesian labs theme_bw
#'   geom_text geom_hline theme element_text
#' @importFrom ggpubr stat_compare_means
#'
#' @return A ggplot object containing the violin and box plots
#'
#' @examples
#' # Example usage:
#' # violin_box_conc(df, title = "Concentration Comparison", chr_of_interest = "chrX")
#'
#' @export

violin_counts <- function(object = NULL,
                            title = NULL,
                            subtitle = NULL,
                            ylab = NULL,
                            xlab = NULL,
                            conc_condition = "Conc_degron",
                            condition_name = "degron",
                            conc_baseline = "Conc_notag",
                            baseline_name = "notag",
                            chr_col = "seqnames",
                            chr_of_interest = "chrX",
                            label.y_plot = c(9, 10, 11, 12),
                            ylim = c(0, 12),
                            colors = c("#4682b4ff", "#ff6347ff", "#4682b4ff", "#ff6347ff"),
                            pvalue_y_position = 1.5) {
  # Input validation
  stopifnot(!is.null(object))
  stopifnot(chr_col %in% colnames(object))
  stopifnot(conc_condition %in% colnames(object))
  stopifnot(conc_baseline %in% colnames(object))

  # Extract concentration values
  conc_cond_x <- object[[conc_condition]][object[[chr_col]] == chr_of_interest]
  conc_cond_a <- object[[conc_condition]][object[[chr_col]] != chr_of_interest]
  conc_base_x <- object[[conc_baseline]][object[[chr_col]] == chr_of_interest]
  conc_base_a <- object[[conc_baseline]][object[[chr_col]] != chr_of_interest]

  # Create long data frame
  fc_chrX <- bind_rows(
    tibble(Condition = paste0("Conc_", baseline_name, "_A"), Conc = conc_base_a),
    tibble(Condition = paste0("Conc_", baseline_name, "_X"), Conc = conc_base_x),
    tibble(Condition = paste0("Conc_", condition_name, "_A"), Conc = conc_cond_a),
    tibble(Condition = paste0("Conc_", condition_name, "_X"), Conc = conc_cond_x)
  ) %>%
    filter(!is.na(Conc)) %>%
    mutate(
      Condition = factor(
        Condition,
        levels = c(
          paste0("Conc_", baseline_name, "_A"),
          paste0("Conc_", baseline_name, "_X"),
          paste0("Conc_", condition_name, "_A"),
          paste0("Conc_", condition_name, "_X")
        )
      )
    )

  # Count peaks by chromosomes
  fc_chrX <- fc_chrX %>% mutate(label = as.character(Condition))
  n_by_label <- fc_chrX %>% dplyr::count(label)
  n_by_label <- n_by_label %>%
    mutate(n = paste0("n = ", n))

  # Create pairwise comparisons
  comparisons <- list(
    c(paste0("Conc_", baseline_name, "_A"), paste0("Conc_", baseline_name, "_X")),
    c(paste0("Conc_", condition_name, "_A"), paste0("Conc_", condition_name, "_X")),
    c(paste0("Conc_", baseline_name, "_A"), paste0("Conc_", condition_name, "_A")),
    c(paste0("Conc_", baseline_name, "_X"), paste0("Conc_", condition_name, "_X"))
  )

  # Create plot
  p <- ggplot(fc_chrX, aes(x = Condition, y = Conc, fill = Condition)) +
    geom_violin(trim = FALSE, scale = "width", color = "black", alpha = 0.5) +
    geom_boxplot(width = 0.1, outlier.shape = NA, color = "black") +
    stat_summary(fun = median, geom = "crossbar", width = 0.3, size = 0.5, color = "black") +
    stat_compare_means(
      method = "t.test",
      comparisons = comparisons,
      label.y = label.y_plot
    ) +
    coord_cartesian(ylim = ylim) +
    scale_fill_manual(values = colors) +
    labs(
      title = title,
      subtitle = subtitle,
      y = if(!is.null(ylab)) ylab else paste0("log2(Normalized Binding Counts) [1 hr auxin: ",
                                              condition_name, " & ", baseline_name, "]"),
      x = xlab
    ) +
    scale_x_discrete(labels = setNames(
      c(paste0(baseline_name, " ChrA"),
        paste0(baseline_name, " ChrX"),
        paste0(condition_name, " ChrA"),
        paste0(condition_name, " ChrX")),
      c(paste0("Conc_", baseline_name, "_A"),
        paste0("Conc_", baseline_name, "_X"),
        paste0("Conc_", condition_name, "_A"),
        paste0("Conc_", condition_name, "_X"))
    )) +
    theme_bw() +
    geom_text(data = n_by_label, aes(x = label, y = pvalue_y_position, label = n),
              inherit.aes = FALSE, size = 5) +
    geom_hline(yintercept = median(fc_chrX$Conc[fc_chrX$Condition == paste0("Conc_", baseline_name, "_A")]),
               linetype = "dashed", color = "grey50") +
    theme(
      legend.position = "none",
      axis.text.x = element_text(angle = 45, hjust = 1)
    )

  return(p)
}
