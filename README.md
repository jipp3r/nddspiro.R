# nddspiro

Extract spirometry data from an ndd Easyware XML file

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

nddspiro requires packages XML and dplyr. Use:

```
install.packages('XML')
install.packages('dplyr')
```

### Installing

Open R, and type:
```
devtools::install_git("https://github.com/jipp3r/nddspiro.R.git")
```
If you do not have the package "devtools", first install it from CRAN with:
```
install.packages("devtools")
```
Optionally, nddspiro can calculate GLI 2012 (Quanjer) reference ranges. This requires the rpsiro package:
```
devtools::install_git("https://github.com/thlytras/rspiro.git")
```

## Output format
nddspiro produces an R dataframe. Full details are given in (doc/nddspiro_format.md)

## Disclaimer

Although efforts have been made to verify correct operation of this software, I cannot accept any liability arising from its use. The software is provided "as is", without any express or implied warranty, and no implication of fitness for a particular use.

## Authors

* **Jamie Rylance** - *Initial work* - [jipp3r](https://github.com/jipp3r)

## License

This project is licensed under the GPL3 license

## Acknowledgments

* Many thanks to the excellent GLI-2012 project, and [thlytras] for the R package to implement these reference ranges.

