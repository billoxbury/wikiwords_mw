
ui <- list()

####################################################################
ui[["control"]] <- fluidPage(
  
  titlePanel("Controls"),
  sidebarLayout(
    sidebarPanel(
      helpText("Optionally, enter a word for highlighting, or two words to highlight shortest paths between them:"),
      textInput("word1", 
                label = "First word:", 
                value = ""),
      textInput("word2", 
                label = "Second word:", 
                value = ""),
      checkboxInput("giant", label = "Restrict to giant component?", value = FALSE),
      selectInput("layout", 
                            label = "Zoom graph layout:",
                            choices = c("As in main plot above",
                                        "Fruchterman-Reingold",
                                        "Kamada-Kawai",
                                        "Reingold-Tilford"),
                            selected = "Fruchterman-Reingold")
    ),
    mainPanel()
  )
)

####################################################################
ui[["global"]] <- fluidPage(
  
  titlePanel("Global view"),
  plotOutput("mainplot",
             brush = brushOpts(id = "plot_brush"),
             width = "100%",
             height = "800px"
  )
)

####################################################################
ui[["zoom"]] <- fluidPage(
  
  titlePanel("Zoom view"),
  plotOutput("subplot", 
             dblclick = "subplot_dblclick",
             brush = brushOpts(id = "subplot_brush", resetOnNew = TRUE),
             hover = hoverOpts(id = "plot_hover", delayType="throttle"),
             width = "100%"
  )
)

####################################################################
ui[["point"]] <- fluidPage(
  
  titlePanel("Point view"),
  plotOutput("plot_hover",
             width = "100%"
  )
)

####################################################################
ui[["links"]] <- fluidPage(
  titlePanel("Useful links"),
  HTML('
       <ol>
  <li>Google <a href="https://code.google.com/p/word2vec/" target="_blank">word2vec</a></li>
  <li>Laurens van der Maaten, Geoffrey Hinton: <a href="https://www.cs.toronto.edu/~hinton/absps/tsne.pdf" target="_blank">Visualizing Data using t-SNE</a>, Journal of Machine Learning Research 1 (2008).</li>
  <li>Gunnar Carlsson: <a href="https://www.ams.org/journals/bull/2009-46-02/S0273-0979-09-01249-X/S0273-0979-09-01249-X.pdf">Topology and Data</a>, Bull. Amer. Math. Soc. 46 (2009)</li>
  <li>Bill Oxbury: <a href="https://billoxbury.github.io/data_science/wikiwords/">Using topology to help visualise word vectors</a> blog post (2018) 
</ol>
       ')
)



####################################################################
ui[["debug"]] <- fluidPage(
  titlePanel("Debugging page"),
  verbatimTextOutput(outputId = "verb")
)

