require(maptools)
require(grDevices)
require(graphics)

usersData <- read.csv("../data/all-answers.csv")
candidatesData <- read.csv("../data/vectors.csv")

nUsers = length(usersData[,1])
colors = c("green", "blue", "red", "darkred", "grey")
pchars = c('o', 'o', 'o', 'o', '.')
textcolors = c("black", colors[2:5])

pca_all <- princomp(rbind(usersData, candidatesData[,4:28]))
pca_cand <- princomp(candidatesData[,4:28])
ux <- pca_all$scores[1:nUsers,1]
uy <- pca_all$scores[1:nUsers,2]
uz <- pca_all$scores[1:nUsers,3]

candidates = (nUsers+1):length(pca_all$scores[,1])
x <- pca_all$scores[candidates,1]
y <- pca_all$scores[candidates,2]
z <- pca_all$scores[candidates,3]
names <- candidatesData[,2] #english names (R has problems with cyrillic symbols)
curias <- as.integer(factor(candidatesData[,2]))

write.csv(pca_all$loadings, file="../results/pca_all_components.csv")
write.csv(pca_cand$loadings, file="../results/pca_candidates_components.csv")
pdf("../results/pca_all_xy_xz.pdf")

plot(ux, uy, pch='·', col="grey", asp=0.9, xlab="Economical freedom (-18+24-14-2-6-19)", ylab="Tolerance to current goverment (-15 -12)")
points(x, y, pch=20,  col=colors[curias])
pointLabel(x, y, labels = names, cex=0.3, col=textcolors[curias])
plot(ux, uz, pch='·', col="grey", asp=0.9, xlab="Economical freedom (-18+24-14-2-6-19)", ylab="RobinHoodness (-14-5-25-10-3)")
points(x, z, pch=20, col=colors[curias])
pointLabel(x, z, labels = names, cex=0.3, col=textcolors[curias])
dev.off()