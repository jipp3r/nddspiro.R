#' Get spirometry results
#'
#' Extracts requested measurements from an ndd Easyware XML file
#'
#' @param param Character vector. Parameter to be returned.
#' @param nodelist XML nodelist. Nodes to be searched.
#' @param test_only Boolean. Optional. If TRUE suppresses the return patient details.
#' @param no_ranges Boolean. Optional. If TRUE suppresses the predicted values.
#' @return Dataframe of results for the given parameters.
#'
#' @keywords internal

nddspiro.results <- function(indices, file, xpath, label="", test_only=FALSE, no_ranges=FALSE) {
  # indices is a list of values, each of which can be:
  #    FEV1; FEV3; FEV6; FEV_5; FEV_75;
  #    FEF25; FEF50; FEF75; FEF2575;
  #    PEF; FET; FVC; FEV1_FVC; BEV; EOTV; PEFT;
  #    VCmax; BTPSin
  #    T0; BTPSex; AmbPressure; AmbHumidity

  # file is XML file to be traversed
  # xpath is the xpath expression which determines which trials will be chosen
  # label is an optional character vector to append to variable names
  # test_only is an optional boolean which supresses patient details if TRUE
  # no_ranges is an optional boolean which supresses normal range data if TRUE

  trials <- xpathApply(file, xpath)
  tests <- xmlSApply(trials, xpathApply, "../..")
  patients <- xmlSApply(trials, xpathApply, "../../../../../..")

  results.df <- lapply(indices, nddspiro.values, nodelist=trials, no_ranges=no_ranges, label=label) %>% bind_cols()

  test.df <- data.frame("nddTestID" = sapply(tests, xmlGetAttr, "TestAutoID"))

  patients.df <- data.frame("patientID" = sapply(patients, xmlGetAttr, "ID"))
  patients.df <- cbind.data.frame(patients.df,data.frame("nddPatientID" = sapply(patients, xmlGetAttr, "PatientAutoID")))
  patients.df <- cbind.data.frame(patients.df,data.frame("lastName" = sapply(xmlSApply(trials, xpathApply, "../../../../../../LastName"),xmlValue)))
  patients.df <- cbind.data.frame(patients.df,data.frame("firstName" = sapply(xmlSApply(trials, xpathApply, "../../../../../../FirstName"),xmlValue)))
  patients.df <- cbind.data.frame(patients.df,data.frame("height" = as.double(sapply(xmlSApply(trials, xpathApply, "../../PatientDataAtTestTime/Height"), xmlValue)),stringsAsFactors = FALSE))
  patients.df <- cbind.data.frame(patients.df,data.frame("weight" = as.double(sapply(xmlSApply(trials, xpathApply, "../../PatientDataAtTestTime/Weight"), xmlValue)),stringsAsFactors = FALSE))
  patients.df <- cbind.data.frame(patients.df,data.frame("ethnicity" = as.character(sapply(xmlSApply(trials, xpathApply, "../../PatientDataAtTestTime/Ethnicity"), xmlValue)),stringsAsFactors = TRUE))
  patients.df$ethnic_gli[patients.df$ethnicity=='Caucasian'] <- 1
  patients.df$ethnic_gli[patients.df$ethnicity=='African'] <- 2
  patients.df$ethnic_gli[patients.df$ethnicity=='North-East Asian'] <- 3
  patients.df$ethnic_gli[patients.df$ethnicity=='South-East Asian'] <- 4
  patients.df$ethnic_gli[patients.df$ethnicity=='Asian'] <- 4
  patients.df$ethnic_gli[patients.df$ethnicity=='Other'] <- 5
  patients.df$ethnic_gli[patients.df$ethnicity=='Hispanic'] <- 5
  patients.df <- cbind.data.frame(patients.df,data.frame("gender" = as.character(sapply(xmlSApply(trials, xpathApply, "../../PatientDataAtTestTime/Gender"), xmlValue)),stringsAsFactors = TRUE))
  # Recode gender to be 2 factors, first male (to be consistent with rspiro)
  patients.df$gender <- factor(patients.df$gender, levels = c("Male", "Female"))
  patients.df <- cbind.data.frame(patients.df,data.frame("dob" = as.Date((sapply(xmlSApply(trials, xpathApply, "../../PatientDataAtTestTime/DateOfBirth"), xmlValue))), stringsAsFactors = FALSE))
  patients.df <- cbind.data.frame(patients.df,data.frame("calcdob" = as.logical(sapply(xmlSApply(trials, xpathApply, "../../PatientDataAtTestTime/ComputedDateOfBirth"), xmlValue)), stringsAsFactors = FALSE))
  patients.df <- cbind.data.frame(patients.df,data.frame("testDate" = as.Date((sapply(xmlSApply(trials, xpathApply, "../../TestDate"), xmlValue))), stringsAsFactors = FALSE))
  patients.df <- cbind.data.frame(patients.df,data.frame("testType" = sapply(tests, xmlGetAttr, "TypeOfTest"),stringsAsFactors = TRUE))
  patients.df <- cbind.data.frame(patients.df,data.frame("testStage" = sapply(tests, xmlGetAttr, "StageType"), stringsAsFactors = TRUE))
  patients.df <- cbind.data.frame(patients.df,data.frame("nddTrialID" = xmlSApply(trials, xmlGetAttr, "TrialAutoID"), stringsAsFactors = FALSE))
  patients.df <- cbind.data.frame(patients.df,data.frame("deviceID" = sapply(xmlSApply(trials, xpathApply, "../../Device/SerialNumber"), xmlValue),stringsAsFactors = TRUE))

  patients.df <- cbind.data.frame(patients.df,data.frame("age" = (patients.df$testDate - patients.df$dob)/365.25))

  # Recode ethnicity to be (1 = Caucasian, 2 = African-American, 3 = NE Asian, 4 = SE Asian, 5 = Other/mixed)

  return.df <- cbind.data.frame(test.df, results.df)

  if(!no_ranges) {
    ranges.df <- data.frame("PredictedSet" = sapply(xmlSApply(trials, xpathApply, "../../../../PredictedSet/Spiro"),xmlValue),
                            "EthnicCorrection" = sapply(xmlSApply(trials, xpathApply, "../../../../PredictedSet/EthnicCorrection"),xmlValue))
    return.df <- cbind.data.frame(ranges.df, return.df)
  }

  if(!test_only) {return.df <- cbind.data.frame(patients.df, return.df)}


  return(return.df)
}
