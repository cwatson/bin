# Code that creates a preferential attachment model up to maximum time t
#_______________________________________________________________________________
# by Chris Watson, 2013-12-05

pref.attach.vert <- function(cur.graph, t) {
  M <- 1  
  for (v in 0:(length(V(cur.graph))-1)) {
    for (i in 0:(d-1)) {
      M[2 * ((v+1)*d + i)] <- (v+1)
      r <- ceiling(runif(1, 0, 2 * ((v+1)*d + i)))
      M[2 * ((v+1)*d + i) + 1] <- M[r]
    }
  }

  edge.list <- vector()
  for (i in 0:(length(V(cur.graph))*d-1)) {
    edge.list <- c(edge.list, M[2*(i+1)], M[2*(i+1) + 1])
  }
  new.vert <- t + 1
  g.new <- cur.graph + vertex(new.vert) +
    edges(c(edge.list[2*i + 1], edge.list[2*i + 2]))
  out <- list(graph=g.new, M, edge.list)
}
