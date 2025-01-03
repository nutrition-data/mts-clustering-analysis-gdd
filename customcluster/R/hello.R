library(TSclust)
customcluster <- function(data, k, dist_metric="EUCL", cluster_algo="PAM") {
  x_diss = NA
  x_diss_2 = NA
  actual_incomes = 0
  iso_order <- 0

  tot <- NA
  tot_2 <- NA
  first_run <- TRUE

  vars <- unique(data$varnum)

  for (var in vars) {
    x <- data[data$varnum == var,]

    # standardise
    x$median <- scale(x$median)

    x <- x[c('iso3', 'year', 'median')]

    # reshape
    x <- reshape(x, idvar = "iso3", timevar="year", direction = "wide")
    rownames(x) <- x$iso3
    x <- x[,c('median.1990', 'median.1995', 'median.2000', 'median.2005', 'median.2010', 'median.2015', 'median.2018')]

    iso_order <- rownames(x)
    x <- as.matrix(sapply(x, as.numeric))

    # calc dissimilarity
    x_diss <- diss(x, dist_metric)
    x_diss_2 <- x_diss
    x_diss <- as.matrix(x_diss)

    if (first_run) {
      tot <- x_diss
      tot_2 <- x_diss_2
      first_run <- FALSE
    } else {
      tot <- tot + x_diss
      tot_2 <- tot_2 + x_diss_2
    }
  }

  result <- data.frame()

  if (cluster_algo == "PAM") {
    # apply PAM clustering
    pam.res <- pam(tot, k)
    result <- pam.res$clustering
  } else if (cluster_algo == "HCLUST") {
    # apply hierarchical clustering
    clusters <- hclust(tot_2, method="ward.D")
    # plot(clusters)
    hclabels <- cutree(clusters, k=k)
    result <- hclabels
  }

  result <- as.data.frame(result)
  rownames(result) <- iso_order

  # retrieve actual income values
  result$income <- NA
  for(country in rownames(result)) {
    result[country,]$income <- data[data$iso3==country,]$income[1]
  }

  return(result)
}
