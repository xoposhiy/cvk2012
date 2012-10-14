#!rscript
vectors <- read.csv("../data/vectors.csv")
blocks <- read.csv("../data/blocks.csv")

avgDistInClique = function (answers) {
  size = length(answers[,1])
  pairs = combn(1:size, 2)
  sum=0
  for(ip in 1:dim(pairs)[2]) {
    a1 = pairs[1, ip]
    a2 = pairs[2, ip]
    sum = sum + dist(rbind(answers[a1,], answers[a2,]))[1]
  }
  return(sum / length(pairs))
}

sampleDistInRandomClique = function(cliqueSize, sampleSize){
  res = c()
  for(i in 1:sampleSize){
    s = sample(1:length(ans[,1]), cliqueSize);
    res[length(res)+1] = avgDistInClique(ans[s, ])
  }
  return(res)
}





Blocks = rle(as.character(blocks[,1]))
ans = vectors[,3:27]
uSizes = sort(unique(Blocks$lengths))

sds=c()
means=c()
for(size in uSizes){
  sample = sampleDistInRandomClique(size, 1000);
  sds[size] = sd(sample);
  means[size] = mean(sample)
  print(size)
  print(means[size])
}

means
plot(1:max(uSizes), means)
plot(1:max(uSizes), sds)

blockMeans = t(sapply(
  1:length(Blocks$values),
  function(iBlock) {
    people = vectors[,1]
    blockName = Blocks$values[iBlock]
    blockPeople = blocks[as.character(blocks[,1]) == blockName, 2]
    personInBlockFlags = sapply(people, 
        function(person) {return (length(which(blockPeople == as.character(person))) > 0)})
    return(c(blockName, avgDistInClique(ans[personInBlockFlags,])))
    }
  ))

diffInSigmas = c()
for(i in 1:length(Blocks$values)){
  size = Blocks$lengths[i]
  diffInSigmas[i] = (means[size] - as.double(blockMeans[i,2])) / sds[size]
}

cbind(cbind(Blocks$values, Blocks$lengths), diffInSigmas)[order(diffInSigmas),]
