<!-- badges: start -->
  [![R-CMD-check](https://github.com/d-callan/microbiomeData/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/d-callan/microbiomeData/actions/workflows/R-CMD-check.yaml)
  <!-- badges: end -->


# microbiomeData
An R package containing some (eventually all!) of the curated datasets from MicrobiomeDB.org and various helper functions for conveniently using that data in R.

## Installation

Use the R package [remotes](https://cran.r-project.org/web/packages/remotes/index.html) to install microbiomeData. From the R command prompt:

```R
remotes::install_github('d-callan/microbiomeData')
```

## Usage
This package could be used directly to explore data you've downloaded from MicrobiomeDB.org, or it could be used for data management as a dependency in another package.

### Direct Usage
You can download data for a particular microbiome study from MicrobiomeDB.org. Data files from the website are organized by 'entity', with some entities representing sample metadata and others assay data. The assay data are organized into 'collections' where a particular collection might for example represent all abundances for a particular taxonomic rank for a particular assay. The column names in the assay data files are prepended with their collection id.

You can pass lists of files to a method called `MbioDataset`. You can pass one list of files for any entities representing sample metadata and a second list of files for any entities representing assay data/ collections. If you got the files from our website, or have organized yours similarly enough, we'll parse them into the appropriate collections for you. That might look something like this:

```R
myData <- MbioDataset(collections = list(fileA, fileB), metadata = list(fileD, fileE))
```

If you already read those files into R, you can do a similar thing except passing lists of data.frame or data.table objects and things will work the same.

Once you have `myData`, you can ask for specific collections from that dataset. That might look something like:

```R
getCollectionNames(myData) # will print the names of collections
myData <- updateCollectionName(myData, '16S-species', '16S Species')
myCollection <- getCollection(myData, '16S Species')
```

Once you have `myCollection`, you can start using our `microbiomeComputations` package (which was installed for you when you installed this one) to do fun things like:

```R
correlationResults <- correlation(myCollection)
differentialAbundanceResults <- differentialAbundance(myCollection)
```

This will give you a `ComputeResult` object, with slots for `data` and `statistics` that you can explore. These objects can be difficult to parse, so we're planning to either expand this package or maybe introduce a second one to help format these results in more usable and exciting ways! For now though, we have a primitive helper called `getComputeResult` which will return data.tables and you can use like this:

```R
myCorrelationDT <- getComputeResult(correlationResults)
```

### Usage as a Package Dependency
This package may be used as a dependency in other R packages. In order to establish that depedency the developer of the 
dependent package must follow these steps:
1. add ```microbiomeData``` to the ```Imports``` section of the dependent package's ```DESCRIPTION``` file.
2. add a ```Remotes``` section to the dependent package's ```DESCRIPTION``` file.
3. add ```d-callan/microbiomeData``` to the ```Remotes``` section of the dependent package's ```DESCRIPTION``` file.
4. add ```#' @import microbiomeData``` to the dependent package's package-level documentation file (usually called ```{mypackage}-package.R```).
5. run ```devtools::document()```.

The developer of the dependent package can either install this package using ```remotes``` as descripted in the "Installation" section above,
or if they mean to also develop microbiomeData simultaneously, can use ```devtools::load_all("{path-to-microbiomeData}")``` to load this package in their R session.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.


If you are trying to add data a dataset to the package, then on your local machine you should:
 1. Make sure you have `devtools` installed locally.
 2. Clone this repository and make a branch to work in.
 3. Create an `MbioDataset` object in your local R using the 'Direct Usage' instructions above. 
 4. Make sure your new dataset and its collections, etc are named well enough for others to use them too.
 5. Use `usethis::use_data` to add the `MbioDataset` object to the package. Be sure you're working in the branch you made.
 6. Add documentation for your dataset in R/data.R following this example:
   ```R
   #' World Health Organization TB data
   #'
   #' A subset of data from the World Health Organization Global Tuberculosis
   #' Report ...
   #'
   #' @format ## `who`
   #' A data frame with 7,240 rows and 60 columns:
   #' \describe{
   #'   \item{country}{Country name}
   #'   \item{iso2, iso3}{2 & 3 letter ISO country codes}
   #'   \item{year}{Year}
   #'   ...
   #' }
   #' @source <https://www.who.int/teams/global-tuberculosis-programme/data>
   "who" ## This is the name of your `MbioDataset` object
   ```
 7. Make a Pull Request against this repo!

## License
[Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0.txt)