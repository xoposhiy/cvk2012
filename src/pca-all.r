require(maptools)

data <- read.csv("../data/all-answers.csv", encoding="UTF-8")
users = 7338

pdf("../results/pca_all.pdf")
colors = c("green", "red",  "blue", "darkred", "grey")
pchars = c('o', 'o', 'o', 'o', '.')
textcolors = c("black", colors[2:5])

pca <- princomp(data[,3:27])
ux <- pca$scores[1:users,1]
uy <- pca$scores[1:users,2]
uz <- pca$scores[1:users,3]

candidates = (users+1):length(data[,1])

x <- pca$scores[candidates,1]
y <- pca$scores[candidates,2]
z <- pca$scores[candidates,3]
names <- data[candidates,1]
curias <- data[candidates,2] + 1

write.csv(pca$loadings, file="../results/pca_all_components.csv")

plot(ux, uy, pch='·', asp=1, col="grey", xlab="Economical freedom (-18+24-14-2-6-19)", ylab="Tolerance to current goverment (-15 -12)")
points(x, y, pch=20, asp=1, col=colors[curias])
pointLabel(x, y, labels = names, cex=0.45, col=textcolors[curias])
plot(ux, uz, pch='·', asp=1, col="grey", xlab="Economical freedom (-18+24-14-2-6-19)", ylab="RobinGoodness (-14-5-25-10-3)")
points(x, z, pch=20, asp=1, col=colors[curias])
pointLabel(x, z, labels = names, cex=0.45, col=textcolors[curias])
dev.off()
