<!-- badges: start -->
  [![R-CMD-check](https://github.com/d-callan/microbiomeData/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/d-callan/microbiomeData/actions/workflows/R-CMD-check.yaml)
  <!-- badges: end -->


# microbiomeData
An R package containing all of the curated datasets from MicrobiomeDB.org and various helper functions for conveniently using that data in R.

## Installation

Use the R package [remotes](https://cran.r-project.org/web/packages/remotes/index.html) to install microbiomeData. From the R command prompt:

```R
remotes::install_github('d-callan/microbiomeData')
```

## Usage
This package is may be used as a dependency in other R packages. In order to establish that depedency the developer of the 
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

## License
[Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0.txt)