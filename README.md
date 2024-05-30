<!-- badges: start -->
  [![R-CMD-check](https://github.com/microbiomeDB/microbiomeData/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/microbiomeDB/microbiomeData/actions/workflows/R-CMD-check.yaml)
  [![](https://dcbadge.limes.pink/api/server/DEjNbxgq?style=flat)](https://discord.gg/DEjNbxgq)
  <!-- badges: end -->


# microbiomeData
An R package containing all of the curated datasets from MicrobiomeDB.org and a helper function to list which datasets are available.

## Installation

Use the R package [remotes](https://cran.r-project.org/web/packages/remotes/index.html) to install microbiomeData. From the R command prompt:

```R
remotes::install_github('microbiomeDB/microbiomeData')
```

## Usage
This package contains all of the curated datasets from MicrobiomeDB.org. It is an extension to the [MicrobiomeDB R package](https://github.com/microbiomeDB/MicrobiomeDB) which can be used to analyze and visualize these data. That package is installed and attached with this one.

### Direct Usage
You can get a list of all curated datasets available within this package by doing the following:

```R
microbiomeData::getCuratedDatsetNames()
myData <- microbiomeData::DiabImmune
```

Once you have your favorite dataset as `myData`, you can ask for specific collections from that dataset. A collection is any group of variables that represent a biologically coherent concept and are measured over a comparable range. Relative abundances at a specific taxonomic rank are an example. That might look something like:

```R
getCollectionNames(myData) # will print the names of collections
myCollection <- getCollection(myData, '16S (V4) Species')

```

## License
[Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0.txt)
