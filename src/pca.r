require(maptools)

data <- read.csv("../data/vectors.csv", encoding="UTF-8")
#svg("../results/pca.svg")
pdf("../results/pca.pdf")
#png("../results/pca.png")

colors = c("green", "red",  "blue", "darkred")
textcolors = c("black", colors[2:4])

pca <- princomp(data[,3:27])
x <- pca$scores[,1]
y <- pca$scores[,2]
names <- data[,1]
curias <- data[,2] + 1

write.csv(cbind(as.character(names),curias,x,y), file="../results/pca.csv")
write.csv(pca$loadings, file="../results/pca_components.csv")

plot(x, y, pch=20, asp=1, col=colors[curias])
set.seed(123)
pointLabel(x, y, labels = names, cex=0.45, col=textcolors[curias])
#text(x, y, names, cex=0.5, pos=3, col="")

dev.off()
