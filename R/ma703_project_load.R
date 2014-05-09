# Load data and create any constants to be used for this project.
#_______________________________________________________________________________
# by Chris Watson, 2013-12-23

require(brainGraph)
#===============================================================================
# These variables need to be set correctly before any data analysis is done
#===============================================================================
group1 <- 'Control'
group2 <- 'Fontan'   # 'Fontan', 'd-TGA'
cost <- 0.075
threshes <- seq(cost - 0.05, cost + 0.03, 0.01)
atlas <- 'dkt'  # 'dk', 'dkt', 'dkSplit2'

kNumCovars <- 4     # The first few columns are NOT thicknesses

resids <- 1   # '0' or '1', to correlate residuals or raw thickness values
plotting <- 0     # '0' or '1'
nifti.plot <- 1   # '0' or '1', for plotting over a brain slice, or just outline
image.dir <- paste('../outfiles/images/', group2, '/', sep='') # Where images should be saved
prefix <- 'adj_graph_'   # Also for plotting

# Where .node, .edge files go
out.dir <- paste('../outfiles/brainNet_files/', group2, '/', sep='')

lhfile <- paste('../data/', group2, '/lhThick_', group2, '.csv', sep='')
rhfile <- paste('../data/', group2, '/rhThick_', group2, '.csv', sep='')
#===============================================================================

# Check OS version for parallel processing
OS <- .Platform$OS.type
if (OS == 'windows') {
  library(snow)
  library(doSNOW)
  num.cores <- as.numeric(Sys.getenv('NUMBER_OF_PROCESSORS'))
  cl <- makeCluster(num.cores, type='SOCK')
  clusterExport(cl, 'sim.rand.graph.par')#, 'sim.rand.graph.HQS',# 'degree.sequence.game',
      #'average.path.length', 'transitivity',
    #  'global.eff', 'local.eff',
    #  'rich.club.coeff', #'edge.betweenness.community', 'fastgreedy.community',
      #'vcount', 'shortest.paths', 'degree', 'ecount', 'induced.subgraph', 'V',
      #'E',
    #  'within.module.deg.z.score'))#, 'graph.neighborhood', 'simplify',
      #'graph.adjacency', 'graph.empty'))
  registerDoSNOW(cl)
} else {
  library(parallel)
  library(doMC)
  num.cores <- detectCores()
  registerDoMC(num.cores)
}

# Coordinates for DK and DKT atlases to be used with BrainNet Viewer
data(list=c('coords', 'coords.dkt', 'coords.brainnet.dk68'))
coords.brainnet.dkt62 <- coords.brainnet.dk68[-c(1, 31, 32, 35, 65, 66), ]

if (atlas=='dkt') {
  coords.cur <- coords.dkt
  exclude <- c(30, 61) # Exclude L & R transversetemporal
} else if (atlas=='dkt') {
  coords.cur <- coords
  exclude <- c(1, 33, 35, 67) # Exclude L & R bankssts, L & R transversetemporal
} else if (atlas=='dkSplit2') {
  data(coords.split2)
  coords.cur <- coords.split2
  exclude <- c(1, 2, 61, 62, 63, 64, 65, 66,
               69, 70,129, 130, 131, 132, 133, 134)
}
