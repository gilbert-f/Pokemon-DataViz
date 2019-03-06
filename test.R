library(radarchart)
library(tidyr)
suppressMessages(library(dplyr))

ds <- read.csv('Pokemon.csv')

colnames(ds) <- c('ID', 'Name', 'Type 1', 'Type 2', 'Total', 
                  'HP', 'Attack', 'Defense', 'Attack Speed',
                  'Defense Speed', 'Speed', 'Generation', 
                  'Legendary')

radarDF <- ds %>% select(Name, 6:11) %>% as.data.frame()

radarDF <- gather(radarDF[1:2,], key=Label, value=Score, -Name) %>%
  spread(key=Name, value=Score)

chartJSRadar(radarDF, maxScale = 100, showToolTipLabel=TRUE)