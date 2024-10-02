library(shiny)
library(mwshiny)
library(igraph)
library(wordcloud)

load("data/w2v_freq.Rds")
load("data/w2v_cset.Rds")
load("data/w2v_graph.Rds")
load("data/w2v_layout.Rds")

word <- dat$word
freq <- dat$freq

# plot parameters:

cheight <- sapply(cluster.set, function(s) s$height)
nbins <- max(cheight)

E(mg)$color <- "lightgrey"
E(mg)$width <- 1
E(mg)$arrow.mode <- 0
E(mg)$curved <- FALSE
V(mg)$size <- sapply(cluster.set, function(s) 0.1*length(s$cluster) ) / 2
V(mg)$label <- ""
V(mg)$color <- cheight

# giant component:

cc <- components(mg)
tab <- table(cc$membership)
gidx <- which(tab==max(tab))
giantv <- which(cc$membership==gidx)
giant <- induced_subgraph(mg, giantv)


source("functions.R")

####################################################################

source("ui.R")
source("server.R")

####################################################################
# RUN ----

runApp(mwsApp(ui, server_calc, server_out),
       host = "192.168.1.221",
       launch.browser = FALSE)
