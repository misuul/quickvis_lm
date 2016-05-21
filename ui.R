# Uuser interface:
# The user can select a dataset from some of the standard ones packaged with R
# The fields of that dataset are presented in a second drop-down box, 
# where the user selects one variable for which a linear model is built


library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Quick-fit linear models"),

  # Instructions
  p("Visual interface for trying out simple linear models"),
    
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
    selectInput('dataset', '1) Choose a dataset', c('mtcars', 'iris', 'airquality', 'ChickWeight')),
    selectInput('var', '2) Choose the variable to explain', ""),
    selectInput('pred', '3) Choose the predictor', ""),
    
    # Explanations
    p("Predictors are ordered according to the strength of their linear model (lowest p-value first)")
    
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("lmPlot")
    )
  )
))
