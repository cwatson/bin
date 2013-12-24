# Load data and create any constants to be used for this project.
#_______________________________________________________________________________
# by Chris Watson, 2013-12-23

# Get all of the thickness data into variables
#---------------------------------------
lhThick <- read.csv('../data/lhThick_abbrev.csv')
rhThick <- read.csv('../data/rhThick_abbrev.csv')
all.thick <- merge(lhThick, rhThick)
control.thick <- subset(all.thick, group=="control")
tga.thick <-     subset(all.thick, group=="d-TGA")


#===============================================================================
# Coordinates for plotting the nodes of the graph (LH first)
#===============================================================================
coords <- data.frame(matrix(
                 c(-5, -3,      #  1 bankssts
                   -1, 3,       #  2 caudal ACC
                   -2.5, 3.5,   #  3 caudal MFG
                   -1, -13,     #  4 cuneus
                   -5, 0,       #  5 entorhinal
                   -3.5, -8.5,  #  6 fusiform
                   -4, -6,      #  7 inf parietal
                   -7, -1.5,    #  8 inf temporal
                   -1, -3.5,    #  9 isthmus cing
                   -3, -15,     # 10 lateral occ
                   -4.5, 9.5,   # 11 lateral OFC
                   -2, -10,     # 12 lingual
                   -1, 9.5,     # 13 medial OFC
                   -6, -3.5,    # 14 mid temp
                   -5, -2,      # 15 parahipp
                   -1.5, -2,    # 16 paracentral
                   -5, 3.5,     # 17 pars opercularis
                   -4.5, 6.5,   # 18 pars orbitalis
                   -4.5, 5,     # 19 pars triangularis
                   -1, -11.5,   # 20 pericalcarine
                   -3, -4,      # 21 postcentral
                   -1, -0,      # 22 posterior cing
                   -3, -2.5,    # 23 precentral
                   -1, -6,      # 24 precuneus
                   -1, 5.5,     # 25 rostral ACC
                   -2.5, 8,     # 26 rostral MFG
                   -2, 11,      # 27 SFG
                   -5.5, -9.5,  # 28 superior parietal
                   -6, -5.5,    # 29 superior temporal
                   -4, -5,      # 30 supramarginal
                   -1.5, 13.5,  # 31 frontal pole
                   -6, 1.5,     # 32 temporal pole
                   -5, -3.5,    # 33 transverse temporal
                   -3, 0.5,     # 34 insula
                    5, -3,      #  1 bankssts
                    1, 3,       #  2 caudal ACC
                    2.5, 3.5,   #  3 caudal MFG
                    1, -13,     #  4 cuneus
                    5, 0,       #  5 entorhinal
                    3.5, -8.5,  #  6 fusiform
                    4, -6,      #  7 inf parietal
                    7, -1.5,    #  8 inf temporal
                    1, -3.5,    #  9 isthmus cing
                    3, -15,     # 10 lateral occ
                    4.5, 9.5,   # 11 lateral OFC
                    2, -10,     # 12 lingual
                    1, 9.5,     # 13 medial OFC
                    6, -3.5,    # 14 mid temp
                    5, -2,      # 15 parahipp
                    1.5, -2,    # 16 paracentral
                    5, 3.5,     # 17 pars opercularis
                    4.5, 6.5,   # 18 pars orbitalis
                    4.5, 5,     # 19 pars triangularis
                    1, -11.5,   # 20 pericalcarine
                    3, -4,      # 21 postcentral
                    1, 0,       # 22 posterior cing
                    3, -2.5,    # 23 precentral
                    1, -6,      # 24 precuneus
                    1, 5.5,     # 25 rostral ACC
                    2.5, 8,     # 26 rostral MFG
                    2, 11,      # 27 SFG
                    5.5, -9.5,  # 28 superior parietal
                    6, -5.5,    # 29 superior temporal
                    4, -5,      # 30 supramarginal
                    1.5, 13.5,  # 31 frontal pole
                    6, 1.5,     # 32 temporal pole
                    5, -3.5,    # 33 transverse temporal
                    3, 0.5),    # 34 insula
                ncol=2, byrow=T))
names(coords) <- c('x', 'y')
rownames(coords) <- names(all.thick[, -1:-3])

# Exclude L & R bankssts, L & R transversetemporal
exclude <- c(1, 33, 35, 67)

thresh <- 0.55

# Import the png of a generic brain outline (axial)
img <- readPNG('../images/brain_top_view_outline.png')
r <- as.raster(img[, , 1:3])
