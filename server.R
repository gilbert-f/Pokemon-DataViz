library(radarchart)
library(tidyr)
library(scatterD3)
suppressMessages(library(dplyr))
suppressMessages(library(shiny))

ds <- read.csv('Pokemon.csv') %>%
  mutate(Type.2 = ifelse(Type.2 == '', '-', paste(Type.2)))

colnames(ds) <- c('ID', 'Name', 'Type 1', 'Type 2', 'Total', 
                  'HP', 'Attack', 'Defense', 'Special Attack',
                  'Special Defense', 'Speed', 'Generation', 
                  'Legendary')

function(input, output) {
  radarData <- reactive({
    input$matchUp_go
    
    pokemon_1_name <- isolate(input$matchUp_pokemon_1)
    pokemon_2_name <- isolate(input$matchUp_pokemon_2)
    pokemon_1 <- filter(ds, Name == pokemon_1_name)
    pokemon_2 <- filter(ds, Name == pokemon_2_name)
    
    df <- rbind(pokemon_1, pokemon_2)
  })
  
  output$matchUp <- renderText({
    if (nrow(radarData()) >= 2) {
      if (radarData()[1, 'Total'] > radarData()[2, 'Total']) {
        paste('Based on total stats:', radarData()[1, 'Name'], 'wins!')
      } else if (radarData()[1, 'Total'] < radarData()[2, 'Total']) {
        paste('Based on total stats:',radarData()[2, 'Name'], 'wins!')
      } else {
        paste("Based on total stats: It's a draw!")
      }
    }
  })
  
  output$radar <- renderChartJSRadar({
    ds <- radarData()
    
    maxVal <- max(ds[, 6:11])
    
    radarDF <- ds %>% select(Name, 6:11) %>% as.data.frame()
    
    radarDF <- gather(radarDF, key=Label, value=Score, -Name) %>%
      spread(key=Name, value=Score)
    chartJSRadar(radarDF, maxScale = maxVal, showToolTipLabel=TRUE)
  })
  
  output$scatter_x_axis <- renderUI({
    selectInput("scatter_x", "x variable:",
                choices=c(colnames(ds[5:12])),
                selected = "HP")
  })
  
  output$scatter_y_axis <- renderUI({
    selectInput("scatter_y", "y variable:", 
                choices=c(colnames(ds[5:12])),
                selected = "Attack")
  })
  
  output$scatter_symbol <- renderUI({
    selectInput("scatter_symbol", "symbol variable:", 
                choices=c('Generation', 'Legendary'),
                selected = "Generation")
  })
  
  output$scatter_color <- renderUI({
    selectInput("scatter_color", "color variable:", 
                choices=c(colnames(ds[3:13])),
                selected = "Type 1")
  })
  
  scatterData <- reactive({
    ds <- ds[input$scatter_obs[1]:input$scatter_obs[2],]
    ds <- filter(ds, ds[, 2] == input$type | ds[, 3] == input$type)
    
  })
  
  output$stats <- renderScatterD3({
    scatterD3(x = scatterData()[,input$scatter_x], 
              y = scatterData()[,input$scatter_y], 
              lab = scatterData()[,'Name'],
              xlab = input$scatter_x,
              ylab = input$scatter_y,
              col_var = scatterData()[,input$scatter_color], 
              col_lab = input$scatter_color,
              symbol_var = scatterData()[,input$scatter_symbol], 
              symbol_lab = input$scatter_symbol,
              point_opacity = input$scatter_pointAlpha,
              point_size = input$scatter_pointSize,
              labels_size = input$scatter_labelSize,
              transitions = input$scatter_transitions
    )
  })
  
  topData <- reactive({
    ds %>%
      arrange(desc(Total)) %>%
      head(n = input$top_obs)
  })
  
  output$topRadar <- renderChartJSRadar({
    ds <- topData()
    maxVal <- max(ds[, 6:11])
    
    radarDF <- ds %>% select(Name, 6:11) %>% as.data.frame()
    
    radarDF <- gather(radarDF, key=Label, value=Score, -Name) %>%
      spread(key=Name, value=Score)
    chartJSRadar(radarDF, maxScale = maxVal, showToolTipLabel=TRUE,
                 showLegend = FALSE, polyAlpha = 0.15, lineAlpha = 0.1)
  })
}

