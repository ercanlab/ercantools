#' Find overlapping peaks between two peak sets
#'
#' @description
#' Expands each peak to a window of `mid ± bp_distance` (where
#' `mid = (start + end) / 2`) and uses [GenomicRanges::findOverlaps()]
#' to identify which peaks in each set overlap with the other.
#' A logical `has_overlap_peak` column is appended to both data frames.
#'
#' @param df1 A `data.frame` with at least `seqnames`, `start`, and `end` columns.
#' @param df2 A `data.frame` with the same requirements as `df1`.
#' @param bp_distance Numeric. Half-width in base pairs of the window around
#'   each peak midpoint used for overlap detection.
#'
#' @return A named list with three elements:
#'   * `df1`: input `df1` with an added `has_overlap_peak` logical column.
#'   * `df2`: input `df2` with an added `has_overlap_peak` logical column.
#'   * `df2_percentage`: Character string reporting the percentage of `df2`
#'     peaks that overlap `df1` (e.g., `"72.34% (362/500)"`).
#'
#' @examples
#' \dontrun{
#' data(example_peaks)
#' peaks_a <- example_peaks[example_peaks$seqnames == "chrX", ]
#' peaks_b <- example_peaks[example_peaks$seqnames %in% c("chrX", "chrI"), ]
#'
#' res <- find_overlap_peaks(peaks_a, peaks_b, bp_distance = 100)
#' cat(res$df2_percentage)
#' head(res$df1)
#' }
#'
#' @export
find_overlap_peaks <- function(df1, df2, bp_distance) {

  if (!requireNamespace("GenomicRanges", quietly = TRUE)) {
    stop(
      "Package 'GenomicRanges' is required.\nInstall with: BiocManager::install('GenomicRanges')",
      call. = FALSE
    )
  }
  if (!requireNamespace("S4Vectors", quietly = TRUE)) {
    stop(
      "Package 'S4Vectors' is required.\nInstall with: BiocManager::install('S4Vectors')",
      call. = FALSE
    )
  }

  .check_cols(df1, c("seqnames", "start", "end"))
  .check_cols(df2, c("seqnames", "start", "end"))

  # Calcular midpoint si no existe
  if (!"mid" %in% colnames(df1))
    df1 <- dplyr::mutate(df1, mid = (start + end) / 2)
  if (!"mid" %in% colnames(df2))
    df2 <- dplyr::mutate(df2, mid = (start + end) / 2)

  make_gr <- function(df) {
    GenomicRanges::GRanges(
      seqnames = df$seqnames,
      ranges   = IRanges::IRanges(
        start = floor(df$mid   - bp_distance),
        end   = ceiling(df$mid + bp_distance)
      )
    )
  }

  gr1 <- make_gr(df1)
  gr2 <- make_gr(df2)

  df1_idx <- unique(S4Vectors::queryHits(GenomicRanges::findOverlaps(gr1, gr2)))
  df2_idx <- unique(S4Vectors::queryHits(GenomicRanges::findOverlaps(gr2, gr1)))

  df1 <- dplyr::mutate(df1, has_overlap_peak = seq_len(dplyr::n()) %in% df1_idx)
  df2 <- dplyr::mutate(df2, has_overlap_peak = seq_len(dplyr::n()) %in% df2_idx)

  n_overlap  <- sum(df2$has_overlap_peak)
  n_total    <- nrow(df2)
  pct_string <- sprintf("%.2f%% (%d/%d)",
                        n_overlap / n_total * 100,
                        n_overlap,
                        n_total)

  list(df1 = df1, df2 = df2, df2_percentage = pct_string)
}


#' UpSet plot for peak category overlaps
#'
#' @description
#' Creates an [UpSetR::upset()] plot from a peak data frame containing
#' logical `has_overlap_*` columns produced by repeated calls to
#' [find_overlap_peaks()]. Any column matching `has_overlap_` is
#' automatically detected if `sets` is `NULL`.
#'
#' @param object A `data.frame` with logical columns named `has_overlap_*`.
#' @param sets Character vector. Column names to include. If `NULL` (default),
#'   all `has_overlap_*` columns are used automatically.
#' @param set_labels Character vector. Display labels for each set.
#'   If `NULL`, labels are derived by removing the `has_overlap_` prefix.
#' @param order_by Character. `"freq"` (default) or `"degree"`.
#' @param set_colors Character vector. Bar colours for each set.
#' @param title Character. Optional title above the plot. Default `NULL`.
#' @param output_pdf Character. Optional path to save PDF. Default `NULL`.
#' @param width Numeric. Plot width in inches. Default `12`.
#' @param height Numeric. Plot height in inches. Default `8`.
#'
#' @return Invisibly returns the UpSet plot object.
#'
#' @examples
#' \dontrun{
#' data(example_peaks)
#' example_peaks$has_overlap_promoter <- sample(c(TRUE, FALSE),
#'                                              nrow(example_peaks),
#'                                              replace = TRUE)
#' example_peaks$has_overlap_enhancer <- sample(c(TRUE, FALSE),
#'                                              nrow(example_peaks),
#'                                              replace = TRUE)
#' upset_peaks(example_peaks, title = "Peak category overlaps")
#' }
#'
#' @export
upset_peaks <- function(object,
                        sets        = NULL,
                        set_labels  = NULL,
                        order_by    = "freq",
                        set_colors  = c("#E41A1C", "#377EB8", "#4DAF4A",
                                        "#984EA3", "#FF7F00", "#A65628"),
                        title       = NULL,
                        output_pdf  = NULL,
                        width       = 12,
                        height      = 8) {

  if (!requireNamespace("UpSetR", quietly = TRUE)) {
    stop(
      "Package 'UpSetR' is required.\nInstall with: install.packages('UpSetR')",
      call. = FALSE
    )
  }

  # Auto-detectar columnas has_overlap_*
  if (is.null(sets)) {
    sets <- grep("^has_overlap_", colnames(object), value = TRUE)
  }
  if (length(sets) < 2) {
    stop("Se necesitan al menos 2 columnas 'has_overlap_*'.", call. = FALSE)
  }

  # Labels: remover prefijo has_overlap_
  if (is.null(set_labels)) {
    set_labels <- tools::toTitleCase(
      gsub("_", " ", gsub("^has_overlap_", "", sets))
    )
  }

  upset_df <- as.data.frame(
    lapply(dplyr::select(object, dplyr::all_of(sets)), as.integer)
  )
  colnames(upset_df) <- set_labels

  used_colors <- rep_len(set_colors, length(set_labels))

  p <- UpSetR::upset(
    upset_df,
    sets            = set_labels,
    order.by        = order_by,
    decreasing      = TRUE,
    mb.ratio        = c(0.6, 0.4),
    number.angles   = 0,
    text.scale      = 1.2,
    point.size      = 3,
    line.size       = 1,
    mainbar.y.label = "Number of intersections",
    sets.x.label    = "n",
    sets.bar.color  = used_colors,
    main.bar.color  = "grey40"
  )

  print(p)
  if (!is.null(title)) graphics::title(main = title, line = -0.5)

  if (!is.null(output_pdf)) {
    grDevices::pdf(output_pdf, width = width, height = height)
    print(p)
    if (!is.null(title)) graphics::title(main = title)
    grDevices::dev.off()
    message(sprintf("PDF guardado en: %s", output_pdf))
  }

  invisible(p)
}
