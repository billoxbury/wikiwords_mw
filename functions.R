
findnodes <- function(w){
  if(!(w %in% word)) return()
  id <- which(word==w)
  which( sapply(cluster.set, function(s){id %in% s$cluster}) )
}


# hand-craft the plot function:
handplot <- function(g, lout){
  
  palette(heat.colors(nbins))
  par(mai=c(0,0,0,0))
  plot(lout, type='n', axes=FALSE, xlab="", ylab="")
  #for(e in 1:ecount(g)){
  #  v <- ends(g,e)
  #  segments(lout[v[1],1], lout[v[1],2],  lout[v[2],1], lout[v[2],2], col='lightgrey')
  #}
  points(lout, pch=1, cex=0.7*V(g)$size, col= "darkgrey")
  points(lout, pch=19, cex=0.4*V(g)$size, col= V(g)$color)
  xtext <- min(lout[,1]) + 0.1*(max(lout[,1]) - min(lout[,1]))
  ytext <- min(lout[,2]) + 0.01*(max(lout[,2]) - min(lout[,2]))
  text(xtext, ytext, labels=sprintf("%d vertices, %d edges", vcount(g), ecount(g)), 
       col='darkblue')
}

handsubplot <- function(g, lout, xlim = NULL, ylim = NULL){
  
  palette(heat.colors(nbins))
  par(mai=c(0,0,0,0))
  cexscale <- 1
  plot(lout, type='n', axes=FALSE, xlab="", ylab="", xlim = xlim, ylim = ylim)
  for(e in 1:ecount(g)){
    v <- ends(g,e)
    segments(lout[v[1],1], lout[v[1],2],  lout[v[2],1], lout[v[2],2], col='grey')
  }
  points(lout, pch=1, cex=1.5*cexscale*V(g)$size, col= "grey")
  points(lout, pch=19, cex=cexscale*V(g)$size, col= V(g)$color)
  xtext <- min(lout[,1]) + 0.1*(max(lout[,1]) - min(lout[,1]))
  ytext <- min(lout[,2]) + 0.01*(max(lout[,2]) - min(lout[,2]))
  text(xtext, ytext, labels=sprintf("%d vertices, %d edges", vcount(g), ecount(g)), 
       col='darkblue')
  box(col='blue')
}

overlay_paths <- function(marked1, marked2, df, cex=1){
  
  # a function to convert global vertex id to local:
  gtol <- function(i){
    tmp <- which(as.numeric(row.names(df))==i)
    # return:
    tmp[!is.null(tmp)]
  } 
  
  if(!is.null(marked1) & !is.null(marked2)){
    for(v1 in marked1)
      for(v2 in marked2){
        p <- shortest_paths(mg, from=v1, to=v2)$vpath[[1]]
        if(length(p) == 0) next
        q <- sapply(p, gtol)
        len <- length(q)
        if(len > 1){
          for(i in 2:len)
            segments(df[q[i-1],1], df[q[i-1],2], df[q[i],1], df[q[i],2], 
                     col='black')
        }
        for(i in 2:(len-1))
          points(df[q[i],], col='blue', pch=19, cex=cex*V(mg)$size[q[i]])
      }
  }
  if(!is.null(marked1)){ 
    m <- sapply(marked1, gtol)
    points(df[m,], pch=19, cex=cex*V(mg)$size[marked1], col= "black")
  }
  if(!is.null(marked2)){
    m <- sapply(marked2, gtol)
    points(df[m,], pch=19, cex=cex*V(mg)$size[marked2], col= "black")
  }
}

