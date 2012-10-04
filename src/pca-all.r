require(maptools)

usersData <- read.csv("../data/all-answers.csv")
candidatesData <- read.csv("../data/vectors.csv", encoding="windows-1251")

nUsers = length(usersData[,1])
colors = c("green", "blue", "red", "darkred", "grey")
pchars = c('o', 'o', 'o', 'o', '.')
textcolors = c("black", colors[2:5])

pca <- princomp(rbind(usersData, candidatesData[,4:28]))
ux <- pca$scores[1:nUsers,1]
uy <- pca$scores[1:nUsers,2]
uz <- pca$scores[1:nUsers,3]

candidates = (nUsers+1):length(pca$scores[,1])
x <- pca$scores[candidates,1]
y <- pca$scores[candidates,2]
z <- pca$scores[candidates,3]
names <- candidatesData[,1]
curias <- as.integer(factor(candidatesData[,2]))
blocks <- as.integer(factor(candidatesData[,3]))

#write.csv(pca$loadings, file="../results/pca_all_components.csv")
pdf("../results/pca_all_xy_xz.pdf")
plot(ux, uy, pch='·', col="grey", asp=0.9, xlab="Economical freedom (-18+24-14-2-6-19)", ylab="Tolerance to current goverment (-15 -12)")
points(x, y, pch=20,  col=colors[curias])
pointLabel(x, y, labels = names, cex=0.3, col=textcolors[curias])
plot(ux, uz, pch='·', col="grey", asp=0.9, xlab="Economical freedom (-18+24-14-2-6-19)", ylab="RobinHoodness (-14-5-25-10-3)")
points(x, z, pch=20, col=colors[curias])
pointLabel(x, z, labels = names, cex=0.3, col=textcolors[curias])
dev.off()
