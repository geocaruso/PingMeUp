#assemble_club_playerslist.R

#Assemble lists per province and some analyses

library(ggplot2)
library(ggridges)

#Club list (for name)
club_list <- readRDS("rds/Clubs_indices.rds")

# Province----
provinces <- c("N", "BBW", "Lx", "L", "H")

for (prov in provinces) {
  message(prov)
  #Read and rbind players
  files <- list.files(
    path = "rds/players_club_list_rds",
    pattern = paste0("^", prov, "[^A-Za-z].*\\.rds"),
    full.names = TRUE
  )
  list_of_dfs <- lapply(files, readRDS)
  players_prov <- do.call(rbind, list_of_dfs)
  
  #Clean action attribute into "licence" (unique id of players)
  players_prov[, "licence"] <- sub('.*value="([0-9]+)".*', '\\1', players_prov[, "action"])
  players_prov <- subset(players_prov, select = -action)
  
  
  # Add/modify attributes
  players_prov[, "classement_lettre"] <- substring(players_prov[, "classement"], 1, 1)
  players_prov[players_prov[, "classement_lettre"] == "N", "classement_lettre"] <-
    "NC"
  players_prov[, "classement_lettre"] <- factor(players_prov[, "classement_lettre"], levels =
                                                  c("A", "B", "C", "D", "E", "NC"))
  
  players_prov[, "classement_chiffre"] <- 99
  BCDE <- players_prov[, "classement_lettre"] %in% c("B", "C", "D", "E")
  players_prov[BCDE, "classement_chiffre"] <- substring(players_prov[BCDE, "classement"], 2, 2)
  players_prov[, "classement_chiffre"] <- factor(players_prov[, "classement_chiffre"], levels = c("0", "2", "4", "6"))
  
  not_inactive <- players_prov[, "position_bis"] != "Inactive"
  #position bis (only actuve) within province
  players_prov[not_inactive, "position_bis_p"]  <- rank(-players_prov[not_inactive, "points"], ties.method = "min")
  #Add province attribute
  players_prov$prov <- prov
  
  # Save
  saveRDS(
    players_prov,
    paste0(
      "rds/players_club_list_rds/players_club_list_",
      prov,
      ".rds"
    )
  )
}

# AFTT (i.e. 5 provinces) ----
players_BBW <- readRDS("rds/players_club_list_rds/players_club_list_BBW.rds")
players_H <- readRDS("rds/players_club_list_rds/players_club_list_H.rds")
players_Lx <- readRDS("rds/players_club_list_rds/players_club_list_Lx.rds")
players_L <- readRDS("rds/players_club_list_rds/players_club_list_L.rds")
players_N <- readRDS("rds/players_club_list_rds/players_club_list_N.rds")
players_AFTT <- rbind(players_BBW, players_H, players_Lx, players_L, players_N)
saveRDS(players_AFTT,
        "rds/players_club_list_rds/players_club_list_AFTT.rds")


#Tables and graphs of classement----
players_AFTT <- readRDS("rds/players_club_list_rds/players_club_list_AFTT.rds")

##of AFTT----
Actifs_AFTT <- players_AFTT[players_AFTT[, "position_bis"] != "Inactive", ]
n_Actifs_AFTT <- nrow(Actifs_AFTT)#Nombre joeuurs actifs
n_Actifs_AFTT #Much less than on website ?!
tab_classement_Actifs_AFTT <- table(Actifs_AFTT[, "classement"])
tab_classement_Actifs_AFTT

pct_classement_AFTT <- tab_classement_Actifs_AFTT / n_Actifs_AFTT

df_class_AFTT <- data.frame(
  classement = names(tab_classement_Actifs_AFTT),
  pct_classement_AFTT = as.numeric(pct_classement_AFTT)
)
df_class_AFTT# Share of each classement in AFTT at download time

tab_lettre_Actifs_AFTT <- table(Actifs_AFTT[, "classement_lettre"])
pct_letter_AFTT <- tab_lettre_Actifs_AFTT / n_Actifs_AFTT
pct_label_AFTT <- paste0(round(100 * pct_letter_AFTT), "%")

df_labels_AFTT <- data.frame(
  classement_lettre = names(tab_lettre_Actifs_AFTT),
  pct_letter_AFTT = as.numeric(pct_letter_AFTT),
  pct_label_AFTT = pct_label_AFTT
)
df_labels_AFTT

AFTTplot <- ggplot(data = Actifs_AFTT) +
  geom_bar(
    aes(
      x = classement_lettre,
      fill = classement_lettre,
      alpha = classement_chiffre,
      y = after_stat(count / sum(count))
    ),
    col = "white",
    lwd = 0.3,
    show.legend = FALSE
  ) +
  scale_fill_manual(
    values = c(
      A  = "grey30",
      B  = "darkred",
      C  = "darkorange",
      D  = "goldenrod",
      E  = "olivedrab4",
      NC = "dodgerblue3"
    ),
    drop = FALSE
  ) +
  scale_alpha_manual(values = c(1, 0.9, 0.8, 0.7)) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_discrete(drop = FALSE) +
  coord_cartesian(ylim = c(0, 0.4)) +
  theme_minimal() +
  labs(
    x = "Classement",
    y = "Pourcentage des actifs",
    title = "AFTT",
    subtitle = paste(n_Actifs_AFTT, "actifs")
  ) +
  geom_text(
    data = df_labels_AFTT,
    aes(x = classement_lettre, y = pct_letter_AFTT, label = pct_label_AFTT),
    vjust = -0.3,
    size = 4
  )
AFTTplot

pdf("AFTT_classement.pdf")
print(AFTTplot)
dev.off()

##of province----
players_AFTT <- readRDS("rds/players_club_list_rds/players_club_list_AFTT.rds")

for (prov in provinces) {
  message(prov)
  players_prov <- players_AFTT[players_AFTT[, "prov"] == prov, ]
  
  Actifs_p <- players_prov[players_prov[, "position_bis"] != "Inactive", ]
  n_Actifs_p <- nrow(Actifs_p) #Nombre joeuurs actifs
  tab_classement_Actifs_p <- table(Actifs_p[, "classement"])
  tab_lettre_Actifs_p <- table(Actifs_p[, "classement_lettre"])
  pct_letter_p <- tab_lettre_Actifs_p / n_Actifs_p
  pct_label_p <- paste0(round(100 * pct_letter_p), "%")
  
  df_labels_prov <- data.frame(
    classement_lettre = names(tab_lettre_Actifs_p),
    pct_letter_p = as.numeric(pct_letter_p),
    pct_label_p = pct_label_p
  )
  df_labels_prov
  
  provplot <- ggplot(data = Actifs_p) +
    geom_bar(
      aes(
        x = classement_lettre,
        fill = classement_lettre,
        alpha = classement_chiffre,
        y = after_stat(count / sum(count))
      ),
      col = "white",
      lwd = 0.3,
      show.legend = FALSE
    ) +
    scale_fill_manual(
      values = c(
        A  = "grey30",
        B  = "darkred",
        C  = "darkorange",
        D  = "goldenrod",
        E  = "olivedrab4",
        NC = "dodgerblue3"
      ),
      drop = FALSE
    ) +
    scale_alpha_manual(values = c(1, 0.9, 0.8, 0.7)) +
    scale_y_continuous(labels = scales::percent) +
    scale_x_discrete(drop = FALSE) +
    coord_cartesian(ylim = c(0, 0.4)) +
    theme_minimal() +
    labs(
      x = "Classement",
      y = "Pourcentage des actifs",
      title = paste("Province", prov),
      subtitle = paste(n_Actifs_p, "actifs")
    ) +
    geom_text(
      data = df_labels_prov,
      aes(x = classement_lettre, y = pct_letter_p, label = pct_label_p),
      vjust = -0.3,
      size = 4
    )
  provplot
  
  pdf(paste0("prov_classement_", prov, ".pdf"))
  print(provplot)
  dev.off()
}

##of clubs per province----
for (prov in provinces) {
  message(prov)
  players_prov <- players_AFTT[players_AFTT[, "prov"] == prov, ]
  Actifs_p <- players_prov[players_prov[, "position_bis"] != "Inactive", ]
  
  table(Actifs_p[, "club"]) #some clubs don' t have any active players
  
  clubs_vec <- unique(Actifs_p[, "club"])
  
  pdf(paste0("clubs_classement_", prov, ".pdf"))
  
  for (i in 1:length(clubs_vec)) {
    club <- clubs_vec[i]
    club_label <- club_list[club_list[, "indice"] == club, "label"]
    
    players_club <- players_prov[players_prov[, "club"] == club, ]
    
    Actifs_c <- players_club[players_club[, "position_bis"] != "Inactive", ]
    
    n_Actifs_c <- nrow(Actifs_c) #Nombre joeurs actifs club
    tab_classement_Actifs_c <- table(Actifs_c[, "classement"])
    tab_classement_Actifs_c
    tab_lettre_Actifs_c <- table(Actifs_c[, "classement_lettre"])
    pct_letter_c <- tab_lettre_Actifs_c / n_Actifs_c
    pct_label_c <- paste0(round(100 * pct_letter_c), "%")
    
    df_labels_club <- data.frame(
      classement_lettre = names(tab_lettre_Actifs_c),
      pct_letter_c = as.numeric(pct_letter_c),
      pct_label_c = pct_label_c
    )
    df_labels_club
    
    library(ggplot2)
    clubplot <- ggplot(data = Actifs_c) +
      geom_bar(
        aes(
          x = classement_lettre,
          fill = classement_lettre,
          alpha = classement_chiffre,
          y = after_stat(count / sum(count))
        ),
        col = "white",
        lwd = 0.3,
        show.legend = FALSE
      ) +
      scale_fill_manual(
        values = c(
          A  = "grey30",
          B  = "darkred",
          C  = "darkorange",
          D  = "goldenrod",
          E  = "olivedrab4",
          NC = "dodgerblue3"
        ),
        drop = FALSE
      ) +
      scale_alpha_manual(values = c(1, 0.9, 0.8, 0.7)) +
      scale_y_continuous(labels = scales::percent) +
      scale_x_discrete(drop = FALSE) +
      coord_cartesian(ylim = c(0, 0.4)) +
      theme_minimal() +
      labs(
        x = "Classement",
        y = "Pourcentage des actifs",
        title = club_label,
        subtitle = paste(
          nrow(Actifs_c),
          "actifs (moy. points 1 mars 2026 = ",
          round(mean(Actifs_c$points)),
          ")"
        )
      ) +
      geom_errorbar(
        data = df_labels_prov,
        aes(x     = classement_lettre, ymin  = pct_letter_p, ymax  = pct_letter_p),
        width = 0.5,
        # controls horizontal length
        color = "deeppink1",
        linewidth = 1,
        alpha = 0.7,
        inherit.aes = FALSE
      ) +
      geom_text(
        data = df_labels_club,
        aes(x = classement_lettre, y = pct_letter_c, label = pct_label_c),
        vjust = -0.3,
        size = 4
      )
    print(clubplot)
  }
  
  dev.off()
}

#Average points per classement AFTT----
players_AFTT <- readRDS("rds/players_club_list_rds/players_club_list_AFTT.rds")
players_AFTT_noA <- players_AFTT[players_AFTT$classement_lettre != "A", ]
players_AFTT_noA$classement <- factor(players_AFTT_noA$classement)

Points_class_qt <- aggregate(points ~ classement, data = players_AFTT_noA, FUN = quantile)
Points_class_qt <- do.call(data.frame, Points_class_qt)

Points_class_mean <- aggregate(points ~ classement, data = players_AFTT_noA, FUN = mean)
Points_class <- merge(Points_class_mean, Points_class_qt, by = "classement")
names(Points_class) <- c("classement",
                         "mean_pts",
                         "min_pts",
                         "qt25_pts",
                         "median_pts",
                         "qt75_pts",
                         "max_pts")


classement_cols <- c(
  B0 = "darkred",
  B2 = "darkred",
  B4 = "darkred",
  B6 = "darkred",
  C0 = "darkorange",
  C2 = "darkorange",
  C4 = "darkorange",
  C6 = "darkorange",
  D0 = "goldenrod",
  D2 = "goldenrod",
  D4 = "goldenrod",
  D6 = "goldenrod",
  E0 = "olivedrab4",
  E2 = "olivedrab4",
  E4 = "olivedrab4",
  E6 = "olivedrab4",
  NC = "dodgerblue3"
)

ggplot(players_AFTT_noA, aes(x = points, y = classement)) +
  geom_density_ridges(scale = 2, rel_min_height = 0.01) +
  theme_minimal(base_size = 14)

ggplot(players_AFTT_noA,
       aes(
         x = points,
         y = classement,
         fill = classement,
         color = classement
       )) +
  geom_density_ridges(scale = 2,
                      rel_min_height = 0.01,
                      color = NA) +
  geom_vline(
    data = Points_class,
    aes(xintercept = mean_pts, color = classement),
    linewidth = 0.4,
    alpha = 0.5
  ) +
  scale_fill_manual(values = classement_cols) +
  scale_color_manual(values = classement_cols) +
  scale_x_continuous(breaks = Points_class$mean_pts,
                     labels = round(Points_class$mean_pts, 0)) +
  theme_minimal(base_size = 14) +
  xlab("points (1 mars 2026)") +
  theme(
    axis.text.x = element_text(
      angle = 90,
      vjust = 0.5,
      hjust = 1,
      color = classement_cols[Points_class$classement],
      face = "bold"
    ),
    legend.position = "none"
  )

#For each club compute sum of classements average points AFTT and compare this sum to the actual sum of points of the club. This measure performance of club compared to AFTT given the classements in the club. Only active hors classements A

#Sum of points of the club:
players_AFTT <- readRDS("rds/players_club_list_rds/players_club_list_AFTT.rds")
actives_AFTT_noA <- players_AFTT[players_AFTT$classement_lettre != "A" & players_AFTT$position_bis != "Inactive", ]

Points_class_mean_actives <- aggregate(points ~ classement, data = actives_AFTT_noA, FUN = mean)
names(Points_class_mean_actives)[2]<-"mean_points_classement_AFTT"

actives_AFTT_noA_extended <- merge(actives_AFTT_noA,
                                   Points_class_mean_actives,
                          by = "classement",
                          all.x = TRUE)

Points_expected_club<-aggregate(mean_points_classement_AFTT ~ club, data = actives_AFTT_noA_extended, FUN = sum) #Sum of expected points based on average points of classemnts(includes inactive)

Points_club<-aggregate(points ~ club, data = actives_AFTT_noA_extended, FUN = sum) #Sum of points (includes inactive)

club_points<-merge(Points_club,Points_expected_club,by="club")

#Performance Ratio of each club
club_points$Points_ratio_meanAFTT<-club_points$points/club_points$mean_points_classement_AFTT
View(club_points)

#Each individual position within his/her own classement----
players_AFTT$position_within_classement <- with(
  players_AFTT,
  ave(-points, classement, FUN = function(x) rank(x, ties.method = "first"))
)

players_AFTT$position_within_classement_pc <- with(
  players_AFTT,
  ave(position_within_classement, classement,
      FUN = function(x) ceiling(100 * x / length(x)))
)

#Exemple  Geoffrey Caruso est le 44eme  (position_within_classement) de son classement (E2) au sein AFTT, soit parmi les 4% meilleurs E2 de l'AFTT



