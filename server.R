# Server logic:
# The dataset selection determines the field list in the second drop-down box
# Acknowledgement: the reactive drop-down lists of variables use a method posted by Ramnath for dynamic dropdown selectors
# which can be found here: http://stackoverflow.com/questions/21465411/r-shiny-passing-reactive-to-selectinput-choices
# The ordering of predictors is inspired from Prof. Roger Peng's "topten" example.



library(shiny)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  outVar = reactive({
    names(get(input$dataset))
  })
  observe({
    updateSelectInput(session, "var", choices = outVar())
    })
  
  predVar = reactive({
      dt <- get(input$dataset)
      v <- input$var
      cols <- names(dt)
      predictors <- cols[cols != v]
      if(v %in% cols){
          y <- dt[,v]
          p <- ncol(dt)
          pvalues <- numeric(p)
          for(i in seq_len(p)) {
              fit <- lm(y ~ dt[, i])
              pvalues[i] <- summary(fit)$coefficients[2, 4]
          }
          ord <- order(pvalues)
          ranked <- dt[, ord]
          ranked <- ranked[,2:dim(ranked)[2]]
      } else {
          return (NULL)
      }      
      names(ranked)
  })
  observe({
      updateSelectInput(session, "pred", choices = predVar())
  })
 
  
  output$lmPlot <- renderPlot({
      dt <- get(input$dataset)
      vr <- input$var
      pr <- input$pred
      if(vr %in% names(dt) && pr %in% names(dt) && vr != pr){
          x <- dt[, pr] 
          y <- dt[, vr]
          if(is.null(x)) {return()}
          fit <- lm(y ~ x)
          intercept <- round(summary(fit)$coefficients[1,1],3)
          slope <- round(summary(fit)$coefficients[2,1],3)
          if(as.numeric(slope) >0) { slope = paste("+", slope, collapse=NULL)}
          pval <- summary(fit)$coefficients[2,4]
          rsq <- summary(fit)$r.squared
          g <- ggplot(data=get(input$dataset), aes(x, y))
          g <- g + geom_point()
          g <- g + ggtitle(paste(input$var, "=", intercept, slope, "*", input$pred, "\n [p-value:", pval, ", r-squared:", rsq, "]"))
          g <- g + stat_smooth(method='lm')
          g
      } else {
          return()
      }
  })
  
})


