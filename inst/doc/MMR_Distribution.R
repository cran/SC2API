## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
knitr::opts_chunk$set(fig.width=10, fig.height=8,fig.align = 'center') 

library(httptest)
httptest::start_vignette("MMR_Distribution")

## ----Setup--------------------------------------------------------------------
library(SC2API)
library(ggplot2)

## ----Authorization, eval=FALSE------------------------------------------------
#  set_token("YOUR CLIENT ID", "YOUR CLIENT SECRET")

## -----------------------------------------------------------------------------
data <- get_league_data(season_id = 43, 
                        queue_id = 201, 
                        team_type = 0, 
                        league_id = 6, 
                        host_region = "eu")

## ----indexing-----------------------------------------------------------------
ladder_id <- data$tier$division[[1]]$ladder_id
ladder_id

## -----------------------------------------------------------------------------
ladder_data <- get_ladder_data(ladder_id = ladder_id, host_region = "eu")

## ----Overall------------------------------------------------------------------
mmr <- ladder_data$team$rating
head(mmr)

## -----------------------------------------------------------------------------
ladder_data_current <- get_gm_leaderboard(2, host_region = "us")
mmrCurrent <- ladder_data_current$mmr
head(mmrCurrent)

## -----------------------------------------------------------------------------
ladder_data_current2 <- get_gm_leaderboard(2, host_region = "kr")
mmrCurrent2 <- ladder_data_current$mmr

identical(mmrCurrent,mmrCurrent2)

## -----------------------------------------------------------------------------
ggplot() +
  geom_histogram(aes(x=mmr)) +
  theme_light()

## ----ByRace-------------------------------------------------------------------
races <- sapply(ladder_data$team$member, 
                function(x) x$played_race_count[[1]]$race$en_US)
df <- data.frame(mmr,races)
df <- df[df$races!='Random',]
head(df)

## -----------------------------------------------------------------------------
ggplot(df,aes(x = mmr, group = races, fill = races)) +
  geom_histogram() + 
  scale_fill_manual(values = c('Orange','Blue','Red')) +
  facet_wrap(~races) + 
  theme_light()

## ----Plotting-----------------------------------------------------------------
ggplot(df,aes(x = mmr)) +
  geom_density(aes(y = ..density.., group = races, colour = races), 
               kernel=c("gaussian"),
               adjust = 1.5,
               position = "identity", 
               lwd = 1) +
  scale_color_manual(values = c('Orange','Blue','Red')) +
  theme_light()

## ---- include=FALSE-----------------------------------------------------------
httptest::end_vignette()

