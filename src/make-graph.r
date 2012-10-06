# prepare csv files for import in gephi. Coordinates — result of PCA
fnodes = "../data/gnodes.csv"
fedges = "../data/gedges.csv"
fply = "../data/g.ply"


v <- read.csv("../data/vectors.csv", encoding="Windows-1251")

Label = v[,1]
Curia = v[,2]
Block = v[,3]
ans = v[,4:28]
blockNames = unique(Block)
Id = 1:length(Label)
pca <- princomp(ans)
x <- pca$scores[,1]
y <- pca$scores[,2]
z <- pca$scores[,3]
m <- pca$scores[,4]

# ply-file: Points Cloud
header = sprintf("ply\nformat ascii 1.0\nelement vertex %d\nproperty float x\nproperty float y\nproperty float z\nproperty int Red\nproperty int Green\nproperty int Blue\nend_header\n", 167);
cat(header, file = fply)

color = col2rgb(as.integer(factor(Block)))
write.table(
	data.frame(x, y, z, color[1,], color[2,], color[3,]),
	file=fply,
	sep = ' ',
	quote = FALSE,
	row.names = FALSE,
	col.names = FALSE,
	append=TRUE
)

# csv nodes
write.table(
	data.frame(Id, Label, Curia, Block, x, y, z, m),
	file=fnodes,
	sep = ',',
	quote = FALSE,
	row.names = FALSE,
)


# csv edges
d = as.matrix(dist(ans))
all_edges = t(combn(1:(dim(d)[1]), 2))
weights = cbind(all_edges, d[all_edges])
edges = (weights[order(weights[,3]),])[1:1000,]
Source = edges[,1]
Target = edges[,2]
Weight = 30-edges[,3]
Type = "undirected"
write.table(
	data.frame(Source, Target, Weight, Type),
	file=fedges,
	quote = FALSE,
	row.names = FALSE)