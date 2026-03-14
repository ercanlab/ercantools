#####################################
# Create violin-box plots of log2FC #
#####################################

#'
#' A function to generate violin-box plot to compare binding changes
#' (log2FoldChange) between chromosome X and autosomes (A) based on ChIPseq data
#' It also performs a t-test to assess statistical significance.
#'
#' @param object Data frame containing chromosomal and fold change data (diffbind report output)
#' @param title Plot title (optional)
#' @param ylab Y-axis label (optional)
#' @param xlab X-axis label (optional)
#' @param log2FC_col Column name containing log2FoldChange values (default: "Fold")
#' @param chr_col Column name containing chromosome identifiers (default: "seqnames")
#' @param chr_of_interest Chromosome of interest to highlight (default: "chrX")
#' @param color_chr_of_interest Color for chromosome of interest (default: "#EF9A9A")
#' @param color_other_chr Color for other chromosomes (default: "#4DB6AC")
#' @param ylim Y-axis limits (default: c(-1,1))
#' @param pvalue_y_position Vertical position for p-value text (default: 0.9)
#' @importFrom stats t.test median
#' @importFrom magrittr %>%
#' @importFrom dplyr group_by summarise bind_rows filter mutate
#' @importFrom tibble tibble
#' @importFrom ggplot2 ggplot aes geom_violin geom_boxplot scale_fill_manual
#'   labs theme_bw coord_cartesian theme geom_hline geom_text annotate
#'   element_text
#'
#' @return A ggplot object containing the violin and box plots
#' @export
#'
#' @examples
#' \dontrun{
#' # Basic usage with a data frame
#' violin_box(my_data, title = "Expression comparison", ylab = "log2FoldChange")
#'
#' # Custom chromosome and colors
#' violin_box(my_data, chr_of_interest = "chr1",
#'           color_chr_of_interest = "red", color_other_chr = "blue")
#' }
violin_log2FC <- function(object = NULL,
                       title = NULL,
                       ylab = NULL,
                       xlab = NULL,
                       log2FC_col = "Fold",
                       chr_col = "seqnames",
                       chr_of_interest = "chrX",
                       color_chr_of_interest = "#EF9A9A",
                       color_other_chr = "#4DB6AC",
                       ylim = c(-1, 1),
                       pvalue_y_position = 0.9) {

  # Input validation
  if (is.null(object)) {
    stop("Input data frame 'object' must be provided")
  }
  if (!log2FC_col %in% colnames(object)) {
    stop(paste("Column", log2FC_col, "not found in the data frame"))
  }
  if (!chr_col %in% colnames(object)) {
    stop(paste("Column", chr_col, "not found in the data frame"))
  }

  # Extract log2FoldChange values
  log2fc_x <- as.numeric(object[[log2FC_col]][object[[chr_col]] == chr_of_interest])
  log2fc_a <- as.numeric(object[[log2FC_col]][object[[chr_col]] != chr_of_interest])

  # Create a long format data frame for plotting
  fc_chrX <- bind_rows(
    tibble(Chromosome = paste0("Chr ", gsub("chr", "", chr_of_interest)), log2FC = log2fc_x),
    tibble(Chromosome = "Chr A", log2FC = log2fc_a)
  ) %>%
    filter(!is.na(log2FC)) %>%
    mutate(
      Chromosome = factor(Chromosome, levels = c("Chr A", paste0("Chr ", gsub("chr", "", chr_of_interest))))
    )

  # Perform t-test to compare the two groups
  t_test_result <- t.test(
    log2FC ~ Chromosome,
    data = fc_chrX,
    var.equal = FALSE
  )
  p_value <- t_test_result$p.value

  # Create violin plot with boxplot
  p <- ggplot(fc_chrX, aes(x = Chromosome, y = log2FC, fill = Chromosome)) +
    geom_violin(trim = FALSE, scale = "width", color = "black", alpha = 0.4) +
    geom_boxplot(width = 0.10, outlier.shape = NA, color = "black", fill = "white") +
    scale_fill_manual(values = c(color_other_chr, color_chr_of_interest)) +
    labs(
      title = title,
      y = ylab,
      x = xlab
    ) +
    theme_bw() +
    coord_cartesian(ylim = ylim) +
    theme(
      legend.position = "none",
      axis.text.x = element_text(angle = 45, hjust = 1)
    ) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "grey20") +
    geom_text(
      data = fc_chrX %>% group_by(Chromosome) %>% summarise(n = n()),
      aes(x = Chromosome, y = floor(min(fc_chrX$log2FC)) - 0.3, label = paste0("n = ", n)),
      inherit.aes = FALSE,
      size = 5
    ) +
    annotate(
      "text",
      x = 1.5,
      y = pvalue_y_position - 0.1,
      label = sprintf("p = %.4g", p_value)
    ) +
    geom_hline(
      yintercept = median(fc_chrX$log2FC[fc_chrX$Chromosome == "Chr A"]),
      linetype = "dashed",
      color = "grey50"
    )

  return(p)
}
