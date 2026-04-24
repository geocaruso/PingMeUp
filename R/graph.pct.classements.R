#' Plot (ggplot) the distribution of player classements
#'
#' Produces a bar chart showing the percentage of players in each classement by lettre 'A,B,C,D,E), with transparency varying by the classement chiffre (excpet for A and NC).
#' 
#' Can be restricted to active players only (default) or include all players.
#'
#' @param data A data frame containing player data.
#' @param col_lettre Character. Name of the column containing the classement letter 
#'   (e.g. A, B, C, D, E, NC). Default: \code{"classement_lettre"}.
#' @param col_chiffre Character. Name of the column containing the
#'   numeric part of the classement. Default: \code{"classement_chiffre"}.
#' @param col_rk_inactive Character. Name of the column used to identify
#'   inactive players. Only used when \code{actifs_only = TRUE}.
#'   Default: \code{"position_bis"}.
#' @param actifs_only Logical. If \code{TRUE} (default), filters out rows
#'   where \code{col_rk_inactive == "Inactive"} before plotting.
#' @param label_statut Character. Word displayed in the subtitle after the
#'   player count. Defaults to \code{"actifs"} when 
#'   \code{actifs_only = TRUE} and \code{"joueurs"} otherwise.
#'   Can be overridden with any character string.
#' @param title Character. Plot title. Default: \code{"AFTT - Part des classements"}.
#' @param x_label Character. X-axis label. Default: \code{"Classement"}.
#' @param y_label Character. Y-axis label. Default: \code{"Pourcentage des actifs"}.
#' @param ylim_max Numeric. Upper limit of the y-axis (as a proportion, not a
#'   percentage). Default: \code{0.4}.
#' @param fill_values Named character vector. Colours for each letter rank.
#'   Names must match the levels present in \code{col_lettre}.
#'   Default covers A, B, C, D, E, NC.
#' @param alpha_values Numeric vector. Alpha values mapped to
#'   \code{col_chiffre} levels, controlling bar transparency.
#'   Default: \code{c(1, 0.9, 0.8, 0.7, 1)} (no transparency for A and NC's,
#'   B6/C6/D6/E6 more transparent than B0/C0/D0/E0)
#'
#' @return A \code{ggplot} object.
#'
#' @examples
#' # Active players only (default)
#' graph.pct.classements(players_m)
#'
#' # Include inactive players
#' graph.pct.classements(players_m, actifs_only = FALSE)
#' 
#' @importFrom ggplot2 ggplot geom_bar aes after_stat scale_fill_manual
#'   scale_alpha_manual scale_y_continuous scale_x_discrete coord_cartesian
#'   theme_minimal labs geom_text
#'
#' @export
graph.pct.classements <- function(
    data,
    col_lettre   = "classement_lettre",
    col_chiffre  = "classement_chiffre",
    col_rk_inactive   = "position_bis",
    actifs_only  = TRUE,
    label_statut = if (actifs_only==TRUE) "actifs" else "joueurs",
    title        = "AFTT - Part des classements",
    x_label      = "Classement",
    y_label      = "Pourcentage des actifs",
    ylim_max     = 0.4,
    fill_values  = c(
      A  = "grey30",
      B  = "darkred",
      C  = "darkorange",
      D  = "goldenrod",
      E  = "olivedrab4",
      NC = "dodgerblue3"
    ),
    alpha_values = c(1, 0.9, 0.8, 0.7, 1)
) {

# Subsetting active/inactive
  if (actifs_only) {
    if (!col_rk_inactive %in% names(data)) {
      stop(paste0("Column '", col_rk_inactive, "' not found. Set actifs_only = FALSE or provide correct col_rk_inactive."))
    }
    df <- data[data[[col_rk_inactive]] != "Inactive", ]
  } else {
    df <- data
  }

# Rename columns with internal names
  names(df)[names(df) == col_lettre]  <- "classement_lettre"
  names(df)[names(df) == col_chiffre] <- "classement_chiffre"
  
# Build percentage labels (per letter)
  counts    <- table(df$classement_lettre)
  pct       <- as.numeric(counts) / sum(counts)
  pct_label <- paste0(round(pct * 100, 1), "%")
  
  df_labels <- data.frame(
    classement_lettre = names(counts),
    pct               = pct,
    pct_label         = pct_label,
    stringsAsFactors  = FALSE
  )
  
#ggplot
  ggplot2::ggplot(data = df) +
    ggplot2::geom_bar(
      ggplot2::aes(
        x     = classement_lettre,
        fill  = classement_lettre,
        alpha = classement_chiffre,
        y     = ggplot2::after_stat(count / sum(count))
      ),
      col         = "white",
      lwd         = 0.3,
      show.legend = FALSE
    ) +
    ggplot2::scale_fill_manual(values = fill_values,  drop = FALSE) +
    ggplot2::scale_alpha_manual(values = alpha_values) +
    ggplot2::scale_y_continuous(labels = function(x) paste0(round(x * 100), "%")) +
    ggplot2::scale_x_discrete(drop = FALSE) +
    ggplot2::coord_cartesian(ylim = c(0, ylim_max)) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      x        = x_label,
      y        = y_label,
      title    = title,
      subtitle = paste(nrow(df), label_statut)
    ) +
    ggplot2::geom_text(
      data = df_labels,
      ggplot2::aes(x = classement_lettre, y = pct, label = pct_label),
      vjust = -0.3,
      size  = 4
    )
}
