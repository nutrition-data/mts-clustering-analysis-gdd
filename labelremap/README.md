# LabelRemap

R package to 'best' remap cluster labels to ground truth by assessing accuracy of each permutation.

## Installation
```R
library(devtools)
install_github("nutritionviz/labelremap")
library("labelremap")
```

## Usage
```R 
labels <- labelremap(clustering_labels, true_labels)
```

Returns the remapped clustering_labels. You could then pass to the caret package's confusionMatrix function to assess clustering performance, e.g.:
```R
library("caret")
confusionMatrix(labels, true_labels)
```

## License
[MIT](https://choosealicense.com/licenses/mit/)
