suppressMessages(library(shiny))
library(scatterD3)
library(radarchart)
ds <- read.csv('Pokemon.csv')
types <- c('Normal', 'Fire', 'Water', 'Electric', 'Grass', 'Ice', 'Fighting', 'Poison', 'Ground', 'Flying', 'Psychic', 'Bug', 'Rock', 'Ghost', 'Dragon', 'Dark', 'Steel', 'Fairy')
fluidPage(
  navbarPage("Pokemon Dataset",
             tabPanel("Pokemon Match Up",
                      sidebarLayout(
                        position = "right",
                        sidebarPanel(
                          selectInput("matchUp_pokemon_1", "1st Pokemon: ", 
                                    ds[,"Name"]),
                          selectInput("matchUp_pokemon_2", "2nd Pokemon: ", 
                                    ds[, "Name"], selected = "Pikachu"),
                          actionButton("matchUp_go", "Enter"),
                          h5(uiOutput('matchUp'))
                        ),
                        mainPanel(
                          chartJSRadarOutput("radar", width = "600", height = "600"), width = 8
                        )
                      )
             ),
             tabPanel("Stats vs. Stats",
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("scatter_obs", "number of observations:",
                                      value = c(1,10), min = 1, max = 800,
                                      step = 1),
                          uiOutput("scatter_x_axis"),
                          uiOutput("scatter_y_axis"),
                          uiOutput("scatter_symbol"),
                          uiOutput("scatter_color"),
                          selectInput("type", "type:", 
                                      choices = types, selected = NULL
                                      ),
                          sliderInput("scatter_pointSize", "point size:",
                                      value = 50, min = 0, max = 100,
                                      step = 0.1),
                          sliderInput("scatter_pointAlpha", "point alpha:",
                                      value = 0.7, min = 0, max = 1,
                                      step = 0.1),
                          sliderInput("scatter_labelSize", "label size:",
                                      value = 11, min = 0, max = 25,
                                      step = 1),
                          checkboxInput("scatter_transitions", "use transitions:", 
                                        value = TRUE)
                        ),
                        
                        mainPanel(
                          scatterD3Output("stats", width = "600", height = "600")
                        )
                      )
             ),
             tabPanel("Top Stats Distribution",
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("top_obs", "Top quantity:",
                                      value = 10, min = 1, max = 800,
                                      step = 1)
                        ),
                        
                        mainPanel(
                          chartJSRadarOutput("topRadar", width = "600", height = "600")
                        )
                      )
             ),
             
             tabPanel("About The Project",
                      includeMarkdown("about.Rmd"))

  )
)
