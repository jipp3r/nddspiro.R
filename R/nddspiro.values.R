#' Get spirometry data from an ndd Easyware XML file
#' 
#' \code{nddspiro.results} returns a dataframe containing the requested measurements.
#' 
#' @param param Character vector. Parameter to be returned.
#' @param nodelist XML nodelist. Nodes to be searched.
#' @param no_ranges Boolean. Optional. If TRUE supresses the return of LLN and predicted values.
#' @param label Optional. Character vector. Appended to each of the column names.  
#' @return Dataframe of results for the given parameter.
#' @keywords internal

nddspiro.values <- function(param, nodelist, no_ranges=FALSE, label="") {
  values <- as.double(sapply(lapply(xmlSApply(nodelist, xpathApply, paste0(".//ResultParameter[@ID='", param, "']//DataValue")), "[[",1),xmlValue))
  
  return.df <- data.frame(values, stringsAsFactors = FALSE)
  names(return.df) <- c(paste0(param, "_value", "_", label))
  
  if(!no_ranges) {
    units <- sapply(lapply(xmlSApply(nodelist, xpathApply, paste0(".//ResultParameter[@ID='", param, "']//Unit")), "[[",1),xmlValue)
    pred <- as.double(sapply(lapply(xmlSApply(nodelist, xpathApply, paste0(".//ResultParameter[@ID='", param, "']//PredictedValue")), "[[",1),xmlValue))
    lln <- as.double(sapply(lapply(xmlSApply(nodelist, xpathApply, paste0(".//ResultParameter[@ID='", param, "']//LLNormalValue")), "[[",1),xmlValue))
    
    temp.df <- data.frame(units, pred,lln, stringsAsFactors = FALSE)
    names(temp.df) <- c(paste0(param, "_units"), paste0(param, "_pred"), paste0(param, "_lln"))
    return.df <- cbind(return.df, temp.df)
  }
  
  return(return.df)
}
