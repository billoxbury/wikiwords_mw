
server_calc <- list()
server_out <- list()

####################################################################
# server calculations

server_calc[["vset1"]] <- function(calc, sess){
  observeEvent(calc$word1, {
      w <- req(calc$word1)
      if(w=="") return()
      calc[["vset1"]] <- findnodes(w)
      })
}

server_calc[["vset2"]] <- function(calc, sess){
  observeEvent(calc$word2, {
    w <- req(calc$word2)
    if(w=="") return()
    calc[["vset2"]] <- findnodes(w)
  })
}

server_calc[["subv"]] <- function(calc, sess){
  observeEvent(calc$plot_brush, {
    res <- brushedPoints(lout, calc$plot_brush, "X", "Y")
    if (nrow(res) == 0){
      return()
    } else {
      calc[["subv"]] <- as.numeric(row.names(res))
    }
  })
}


server_calc[["currentgraph"]] <- function(calc, sess){
  observeEvent(calc$subv, {
    calc[["currentgraph"]] <- induced.subgraph(mg, req(calc$subv))
  })
}

server_calc[["subsetdf"]] <- function(calc, sess){
  observeEvent(list(calc$currentgraph,
                    calc$layout,
                    calc$subv), {
    g <- req(calc$currentgraph)
    df <- switch(req(calc$layout),
                 "As in main plot above" = lout[req(calc$subv),],
                 "Fruchterman-Reingold" = data.frame(layout.fruchterman.reingold(g)),
                 "Kamada-Kawai" = data.frame(layout.kamada.kawai(g)),
                 "Reingold-Tilford" = data.frame(layout.reingold.tilford(g))  )
    row.names(df) <- calc$subv
    names(df) <- c("X","Y")
    calc[["subsetdf"]] <- df
  })
}

server_calc[["zoomrange"]] <- function(calc, sess){
  observeEvent(list(calc$subplot_brush,
                    calc$subplot_dblclick), {
                      
                      observeEvent(calc$subplot_dblclick, {
                        brush <- calc$subplot_brush
                        dblclick <- calc$subplot_dblclick
                        if (!is.null(dblclick) & !is.null(brush)) {
                          calc[["zoomrange"]][['x']] <- c(brush$xmin, brush$xmax)
                          calc[["zoomrange"]][['y']] <- c(brush$ymin, brush$ymax)
                        } else {
                          calc[["zoomrange"]][['x']] <- NULL
                          calc[["zoomrange"]][['y']] <- NULL
                        }
                      })
                    })
}


server_calc[["pts"]] <- function(calc, sess){
  observeEvent(list(calc$plot_brush,
                    calc$plot_hover,
                    calc$subsetdf), {
    if(is.null(calc$plot_brush)) return()
    if(is.null(calc$plot_hover)) return()
    res <- nearPoints(calc$subsetdf, calc$plot_hover, 
                      "X", "Y", threshold=10, maxpoints=1)
    if (nrow(res) == 0)
      return()
    idx <- as.numeric(row.names(res))
    calc[["pts"]] <- cluster.set[[idx]]$cluster
  })
}


####################################################################
# plot outputs

server_out[["mainplot"]] <- function(calc, sess){
  renderPlot({
    if(calc$giant) handplot(giant, lout[giantv,])
    else handplot(mg, lout)
    # draw paths:
    overlay_paths(calc$vset1, calc$vset2, lout, cex=0.7)
  })
}


server_out[["subplot"]] <- function(calc, sess){
  renderPlot({
    if(is.null(calc$plot_brush)) return()
    g <- calc$currentgraph
    handsubplot(g, 
                calc$subsetdf, 
                xlim = calc$zoomrange[['x']], 
                ylim = calc$zoomrange[['y']])
    # draw paths:
    overlay_paths(calc$vset1, calc$vset2, calc$subsetdf, cex=4)
  })
}

server_out[["plot_hover"]] <- function(calc, sess){
  renderPlot({
    if(is.null(calc$pts)) return()
    wordcloud(word[calc$pts], 
              freq[calc$pts], 
              random.order=TRUE, 
              scale=c(1.8,1.0), rot.per=0
    )
  })
}

####################################################################
# debug output:

server_calc[["debug"]] <- function(calc, sess){
  observeEvent(list( calc$zoomrange ), {
    calc[["verb"]] <- calc$zoomrange
  })
}

server_out[["verb"]] <- function(calc, sess){
  renderPrint({ calc$verb })
}





