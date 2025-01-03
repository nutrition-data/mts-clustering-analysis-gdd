select_data <- function(dataset, incomes, variables) {
  data <- read.csv(file=paste("./data/data_", dataset, ".csv", sep=""))
  data <- data[data$income %in% incomes,]
  data <- data[data$varnum %in% variables,]

  return(data)
}


# clustering dtw wrapper
library(TSclust)
library(dtwclust)
library(fossil)
clusterdtw <- function(data, k, metric="dtw_basic", plot=FALSE, sigma=100, backtrack = FALSE,
                       normalize = FALSE, sqrt.dist = TRUE, norm = "L1", seed=1) {
  varnums <- unique(data$varnum)

  # some reshape
  data <- reshape(
    data,
    timevar = "varnum",
    idvar = c("iso3", "year", "income"),
    direction = "wide"
  )
  # scale
  colnames <- c()
  for (varnum in varnums) {
    colname <- paste("median.", as.character(varnum), sep="")
    data[,colname] <- scale(data[,colname])

    colnames <- c(colnames, colname)
  }

  # split (each country into separate sub data)
  data_split <- split(data[,colnames], data$iso3)

  # mvc
  mvc <- tsclust(
    data_split,
    k=k,
    distance = metric,
    seed = seed,
    args = tsclust_args(dist = list(sigma=sigma, normalize=normalize, norm=norm, sqrt.dist = sqrt.dist, backtrack=backtrack))
  )
  # this creates a PartitionalTSClusters S4 object

  # plot own graph with custom colors
  if (plot) {
    plot(mvc)
  }

  result <- mvc@cluster
  result <- as.data.frame(result)
  rownames(result) <- unique(data$iso3)

  # retrieve actual income values
  result$income <- NA
  for(country in rownames(result)) {
    result[country,]$income <- data[data$iso3==country,]$income[1]
  }

  return(result)
}




# results
library(devtools)
library(caret)
library(fossil)
# library(labelremap)
# if (!require("labelremap", character.only = TRUE)) {
#   install_github("nutritionviz/labelremap")
# }

source("labelremap/R/hello.R")
get_results <- function(cluster_res, truth) {
  cluster_res <- as.factor(cluster_res)
  truth <- as.factor(truth)

  res_list <- list()
  cluster_res <- labelremap(cluster_res, truth)

  cfm <- confusionMatrix(cluster_res, truth)
  res_list <- append(res_list, list(cfm=cfm))

  ri <- rand.index(as.numeric(cluster_res), as.numeric(truth))
  res_list <- append(res_list, list(ri=ri))

  ari <- adj.rand.index(as.numeric(cluster_res), as.numeric(truth))
  res_list <- append(res_list, list(ari=ari))

  return(res_list)
}
