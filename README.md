---
editor_options: 
  markdown: 
    wrap: 72
---

# Ping Me Up project

**Author:** [Geoffrey Caruso](mailto:geoffrey.caruso@uni.lu)

This repository explores AFTT table tennis data using R.

**Important: This is an independent, non‑official project.**

The project is not endorsed by, or produced for the AFTT. This
repository is made

-   for personal interest and methodological exploration,
-   as a teaching example for geography students at the University of
    Luxembourg,
-   to illustrate a reproducible workflow for scraping, cleaning,
    analysing, mapping data with R and making a package with functions,
    data and reports.

Please refer to the **AFTT Data Portal:** <https://data.aftt.be/> for
official rankings and datasets.

This said, I welcome comments, improvements and any suggestions!

**Ethics & responsible use**

-   Out of discretion, no player‑level outputs are produced here. Names
    are publicly visible on the official AFTT website, so they are kept
    here but can easily be reomved if that would be problematic. Licence
    number is a unique ID.
-   Anyone reusing these scripts is strongly encouraged to:
    -   acknowledge AFTT as the data source,
    -   scrape gently and responsibly to avoid unnecessary load on AFTT
        infrastructure

### Install and use

**Install from GitHub**
```
install.packages("devtools") #if needed

devtools::install_github("geocaruso/PingMeUp")
```

**Explore data (e.g. best 50 active players or best 20 in Namur province)**

```
library(PingMeUp)

data(players_m)

head(players_m[order(players_m$points, decreasing=TRUE), c("nom","points")], 50)

Namur_players_m <-players_m[players_m$prov=="N",]
head(Namur_players_m[order(Namur_players_m$points, decreasing=TRUE), c("nom","points")], 20)
```
See the Vignettes for more use and analytics (plots, etc.)

### Compute your classement from points app

The package repository includes a small web app (`points2classement.html`) located in
`inst/app/`.  
This app uses PHP to load the ranking tables (json file), so it **cannot** be opened by double‑clicking the HTML file.

To run it, you need to start a small local web server (or copy files to a real webserver)

On a mac/linux: open a terminal and go to the app folder

```bash
cd path/to/PingMeUp/inst/app
```

(If you installed the package from GitHub, the folder is inside your R library. Or just download the app folder from the repo)

```bash
php -S localhost:8000
```
Open the app in your browser by going to 

```bash
http://localhost:8000/points2classement.html

```
 Enjoy!
