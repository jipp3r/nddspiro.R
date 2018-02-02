#' Import and process spirometry data
#'
#' Extracts spirometry data from ndd Easyware XML files
#'
#' @details
#' This is the only function you are likely to need.
#' Can be used with\pkg{rspiro} from devtools::install_git(\"https://github.com/thlytras/rspiro.git\")
#'
#' @param xmlfilename Character vector. Filename of the XML file to process.
#' @param indices Optional. List of character vectors. The indices to be returned. Default is FEV1, FVC, FEV1FVC, PEFR. Possible values are "FEV1", "FEV6", "FVC", "FEV1_FVC", "PEFR", "FEF2575", "FET", "BEV", "EOTV", "VCmax"
#' @param traces Integer. Optional. Results per test to be returned (in descending order from Rank 1). Default=2.
#' @param accepted_only Optional. Boolean. If TRUE only "accepted" traces will be returned. Default=TRUE.
#' @param add_GLI Optional. Boolean. If TRUE will add GLI 2012 reference ranges. Requires rspiro package. Default=FALSE.
#'
#' @return Dataframe of test results
#'
#' @author Jamie Rylance, \email{jamie.rylance@lstmed.ac.uk}
#'
#' @examples
#' read.nddspiro("example.xml", traces=3)
#'
#' read.nddspiro("example.xml", indices=c("FEV1", "FVC"))
#'
#' read.nddspiro("example.xml", accepted_only=FALSE, add_GLI=TRUE)
#'
#' @export

nddspiro.read <- function(xmlfilename, indices = c("FEV1", "FVC", "FEV1_FVC","PEFR"), traces=2, accepted_only=TRUE, add_GLI = FALSE) {
  require(rspiro)

  if(!is.installed('rspiro')) {
    add_GLI <- FALSE
    cat("rpsiro package is not available - unable to add GLI ranges. To install, try... devtools::install_git(\"https://github.com/thlytras/rspiro.git\")\n")
  }

  xmlfile <- xmlParse(xmlfilename)
  if(traces<1) traces <- 1

  for(i in 1:traces) {
    if(i==1) {
      no_ranges <- FALSE
      test_only <- FALSE }
    else {no_ranges <- TRUE
    test_only <- TRUE }

    xmlpath <- paste0("//Trial[Rank=",i)
    if(accepted_only) xmlpath <- paste0(xmlpath," and Accepted='true']") else xmlpath <- paste0(xmlpath,"]")

    if(i==1) {return.df <- nddspiro.results(indices, xmlfile, xmlpath, label=as.character(i), test_only, no_ranges)}
    else {
      new.df <- nddspiro.results(indices, xmlfile, xmlpath, label=as.character(i), test_only, no_ranges)
      return.df <- merge(return.df, new.df, by="nddTestID", all.x=TRUE)
    }

  }

  if (add_GLI) {
    return.df <-
      cbind.data.frame(
        return.df,
        pred_GLI(
          return.df$age,
          return.df$height,
          return.df$gender,
          return.df$ethnicity,
          param = c("FEV1", "FVC", "FEV1FVC", "FEF2575")
        )
      )
    return.df <-
      cbind.data.frame(
        return.df,
        LLN_GLI(
          return.df$age,
          return.df$height,
          return.df$gender,
          return.df$ethnicity,
          param = c("FEV1", "FVC", "FEV1FVC", "FEF2575")
        )
      )
    return.df <-
      cbind.data.frame(return.df, data.frame("gli_z_fev1" = ((return.df$FEV1_value_1 - return.df$pred.FEV1) / ((return.df$pred.FEV1 - return.df$LLN.FEV1) / 1.64)
      )))
    return.df <-
      cbind.data.frame(return.df, data.frame("gli_z_fvc" = ((return.df$FVC_value_1 - return.df$pred.FVC) / ((return.df$pred.FVC - return.df$LLN.FVC) / 1.64)
      )))
    return.df <-
      cbind.data.frame(return.df, data.frame("gli_z_fev1fvc" = ((return.df$FEV1_FVC_value_1 - return.df$pred.FEV1FVC) / ((return.df$pred.FEV1FVC - return.df$LLN.FEV1FVC) / 1.64)
      )))
    return.df <-
      cbind.data.frame(return.df, data.frame("gli_z_fef2575" = ((return.df$FEF2575_value_1 - return.df$pred.FEF2575) / ((return.df$pred.FEF2575 - return.df$LLN.FEF2575) / 1.64)
      )))
  }

  return(return.df)
}
