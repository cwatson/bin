# This uses the example graph of Figure 2.4 in Kolaczyk's book.
# It has 7 vertices and 10 edges.

A <- matrix(c(0, 1, 1, 0, 0, 0, 0,
              1, 0, 1, 1, 0, 0, 0,
              1, 1, 0, 0, 1, 0, 0,
              0, 1, 0, 0, 1, 1, 1,
              0, 0, 1, 1, 0, 1, 0,
              0, 0, 0, 1, 1, 0, 1,
              0, 0, 0, 1, 0, 1, 0),
            nrow=7, byrow=T)

g.adj <- graph.adjacency(A, mode='undirected')
coords <- matrix(c(0, 0,
                   1, 1,
                   1, -1,
                   2, 1,
                   2, -1,
                   3, 1,
                   3, -1),
                 ncol=2, byrow=T)

png("../images/orig_network.png")
plot(g.adj, layout=coords, edge.width=3)
dev.off()

num.edges <- ecount(g.adj)
num.vert <- vcount(g.adj)
vertices <- V(g.adj)

# List the edges from vertex 1
E(g.adj) [ from(1) ]


#-------------------------------------------------------------------------------
# Set the parameters
#-------------------------------------------------------------------------------
k.uv.1 <- 2   # 'spring stiffness'
k.uv.2 <- 0.6   # 'electric repulsion' strength
len.uv <- 2


png("../images/new_networks.png")
par(mfrow=c(3, 3))
coords.new <- coords

for (i in seq(1, 27)) {
  # TODO: find some stopping (equilibrium) criteria, e.g. F.x < some number?
  F.x <- vector(length=num.vert)
  F.y <- vector(length=num.vert)
  for (v in vertices) {
    term1.x <- 0
    term2.x <- 0
    term1.y <- 0
    term2.y <- 0

    u <- neighbors(g.adj, v)
    distance <- sqrt(rowSums(t(t(coords.new[u, ]) - coords.new[v, ])^2)) 
    term1.x <- -k.uv.1 * (distance - len.uv) *
      ((coords.new[v, 1] - coords.new[u, 1]) / distance)
    term1.y <- -k.uv.1 * (distance - len.uv) * 
      ((coords.new[v, 2] - coords.new[u, 2]) / distance)
    

    u <- vertices[vertices != v]  
    distance <- sqrt(rowSums(t(t(coords.new[u, ]) - coords.new[v, ])^2)) 
    term2.x <- k.uv.2 * (coords.new[v, 1] - coords.new[u, 1]) /
      distance^3
    term2.y <- k.uv.2 * (coords.new[v, 2] - coords.new[v, 2]) /
        distance^3

    F.x[v] <- sum(term1.x) + sum(term2.x)
    F.y[v] <- sum(term1.y) + sum(term2.y)
  }

  coord.mult <- .15
  coords.new <- coords - coord.mult * cbind(F.x, F.y)
  if (i %% 3 == 0) 
    plot(g.adj, layout=coords.new, sub=sprintf('Iteration %02i', i),
      edge.width=2)
}
dev.off()
