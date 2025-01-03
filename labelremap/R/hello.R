library(caret)
library(combinat)

labelremap <- function(cluster, truth) {
  cluster <- as.factor(cluster)
  truth <- as.factor(truth)
  # input validation
  if (length(cluster)!= length(truth)) {
    stop(paste(
        "Factors are not of equal length:",
        length(cluster),
        length(truth)
    ))
  }

  # find best permutation
  max_acc <- 0
  best_labels <- c()
  x <- levels(truth)
  for (perm in permn(x)) {
    cluster_temp <- cluster
    levels(cluster_temp) <- perm
    cluster_temp = as.numeric(levels(cluster_temp)[as.integer(cluster_temp)])
    cluster_temp <- as.factor(cluster_temp)
    cfm <- confusionMatrix(cluster_temp, truth)

    if (cfm$overall[['Accuracy']][] > max_acc) {
      best_labels <- cluster_temp
      max_acc <- cfm$overall[['Accuracy']][]
    }
  }

  return(best_labels)
}
