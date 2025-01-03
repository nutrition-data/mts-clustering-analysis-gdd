# Multivariate Time Series Cluster Analysis of Nutrition Data
This repository can be used to reproduce the paper results. It comprises of R code (in RMarkdown files).

## Manual Installation
- Download the repository ZIP, or in your Terminal type `git clone https://github.com/nutrition-data/mts-clustering-analysis-gdd.git`. 
- Ensure you have R Studio installed and proceed to open the R Markdown files. 
- Hit ``Run > Run All`` to execute the code. Start with the file [download_and_prep.Rmd](download_and_prep.Rmd).

## Custom Packages
- `customcluster`: implementation of the custom multivariate time series clustering program.
- `labelremap`: remaps cluster labels to a ground truth for further analysis.
These can be found in their respective folders.

### Files
There are several Rmd files each of which performs a distinct role:  
- [download_and_prep.Rmd](download_and_prep.Rmd): This script combines all main data sources into single csv ``/data/data_all_999.csv``. This script also generates nutritional data for the stratified variables (e.g. `data_female_0.csv` and `data_female_1.csv`).
- [utils.R](utils.R): Several utility functions including a wrapper for DTW clustering.
- [exploratory.Rmd](exploratory.Rmd): an initial exploration of the data.
- [clustering_example_dtw.Rmd](clustering_example_dtw.Rmd): a test of multivariate time series clustering using Dynamic Time Warping distance and dummy data.
- [clustering_dtw.Rmd](clustering_dtw.Rmd): MTS clustering using DTW.
- [clustering_custom.Rmd](clustering_custom.Rmd): MTS clustering using the custom program.
- [results.Rmd](results.Rmd): Reproduces the main figures and tables.

### Folders
- [data](data/): Holds datasets and processed data

## Data
Please refer to the paper for full references of data sources.

## Running with Docker (advanced)
As opposed to setting up R and the repository manually, one can run this project in Docker. The `Dockerfile` contains all necessary commands to setup your environment. First build the image:
```shell
docker build -t main_project .
```
then run the image:
```shell
docker run -e PASSWORD=password -p 8787:8787 main_project
```
You can now connect to your RStudio Server via your browser [localhost:8787](http://localhost:8787/).

### System Specification
CPU Intel i7-9750H (2.6GHz), RAM 16GB
RStudio Version 2021.09.0+351 "Ghost Orchid" Release
R Version 4.1.1
Docker Client Cloud integration: v1.0.24; Version: 20.10.14; API version: 1.41
Docker Server, Docker Desktop 4.8.1 (78998); Engine Version: 20.10.14; Engine API version: 1.41;
Docker Host Docker running on Windows Subsystem for Linux 2 (WSL 2: Ubuntu)

## License
[MIT](https://choosealicense.com/licenses/mit/)
