#This avoid notes or warning about import utils and variables called by functions (eg.ggplot)
utils::globalVariables(c(
  "players_m",
  "players_m_archive",
  "pts_rk_m",
  "grille_classements_m",
  "classement_lettre",
  "classement_chiffre"
))
