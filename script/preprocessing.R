# **************************************
# load data template
# **************************************


mscompURL <- "https://s3.amazonaws.com/al-chemy/microsoft-malware-prediction/train.csv.zip"
download.file(mscompURL, "train.zip")
zipF<-file.choose()
mscompURL <- unzip(zipF, file = mscompURL)
df.hex <- h2o.importFile(path = mscompURL, destination_frame = "df.hex")






# # **************************************
# # join exmpale V1-28
# # **************************************





# # **************************************
# # set validation
# # **************************************


# Split training/validation
df.split <- h2o.splitFrame(data=df.hex, ratios=0.75)
ka_print_size(df.split[[1]])
ka_print_size(df.split[[2]]) #Validation dim

# Create a training set from the 1st dataset in the split
df.train <- df.split[[1]]

# Create a validation set from the 2nd dataset in the split
df.test <- df.split[[2]]

#df.all.r <- as.data.frame(df.test)


h2o.shutdown(prompt = TRUE) #=======END OF LINE ============================#



# **************************************
# stack numeric features
# **************************************
num_feats <- c(  #for now all features
"MachineIdentifier"              ,
"ProductName"                    ,
"EngineVersion"                  ,
"AppVersion"                     ,
"AvSigVersion"                   ,
"IsBeta"                         ,
"RtpStateBitfield"               ,
"IsSxsPassiveMode"               ,
"DefaultBrowsersIdentifier"      ,
"AVProductStatesIdentifier"   ,
"AVProductsInstalled"         ,
"AVProductsEnabled"           ,
"HasTpm"                      ,
"CountryIdentifier"           ,
"CityIdentifier"              ,
"OrganizationIdentifier"      ,
"GeoNameIdentifier"           ,
"LocaleEnglishNameIdentifier" ,
"Platform"                     ,
"Processor"                    ,
"OsVer"                        ,
"OsBuild"                      ,
"OsSuite"                      ,
"OsPlatformSubRelease"         ,
"OsBuildLab"                   ,
"SkuEdition"                   ,
"IsProtected"                  ,
"AutoSampleOptIn"              ,
"PuaMode"                      ,
"SMode"                        ,
"IeVerIdentifier"              ,
"SmartScreen"                  ,
"Firewall"                     ,
"UacLuaenable"                 ,
"Census_MDC2FormFactor"        ,
"Census_DeviceFamily"          ,
"Census_OEMNameIdentifier"              ,
"Census_OEMModelIdentifier"             ,
"Census_ProcessorCoreCount"             ,
"Census_ProcessorManufacturerIdentifier",
"Census_ProcessorModelIdentifier"       ,
"Census_ProcessorClass"                 ,
"Census_PrimaryDiskTotalCapacity"       ,
"Census_PrimaryDiskTypeName"            ,
"Census_SystemVolumeTotalCapacity"      ,
"Census_HasOpticalDiskDrive"                       ,
"Census_TotalPhysicalRAM"                          ,
"Census_ChassisTypeName"                           ,
"Census_InternalPrimaryDiagonalDisplaySizeInInches",
"Census_InternalPrimaryDisplayResolutionHorizontal",
"Census_InternalPrimaryDisplayResolutionVertical"  ,
"Census_PowerPlatformRoleName"                     ,
"Census_InternalBatteryType"                       ,
"Census_InternalBatteryNumberOfCharges"            ,
"Census_OSVersion"                                 ,
"Census_OSArchitecture"                           ,
"Census_OSBranch"                                 ,
"Census_OSBuildNumber"                            ,
"Census_OSBuildRevision"                          ,
"Census_OSEdition"                                ,
"Census_OSSkuName"                                ,
"Census_OSInstallTypeName"                        ,
"Census_OSInstallLanguageIdentifier"              ,
"Census_OSUILocaleIdentifier"                      ,
"Census_OSWUAutoUpdateOptionsName"                 ,
"Census_IsPortableOperatingSystem"                 ,
"Census_GenuineStateName"                          ,
"Census_ActivationChannel"                         ,
"Census_IsFlightingInternal"                       ,
"Census_IsFlightsDisabled"                         ,
"Census_FlightRing"                                ,
"Census_ThresholdOptIn"                            ,
"Census_FirmwareManufacturerIdentifier"            ,
"Census_FirmwareVersionIdentifier"                 ,
"Census_IsSecureBootEnabled"                       ,
"Census_IsWIMBootEnabled"                          ,
"Census_IsVirtualDevice"                           ,
"Census_IsTouchEnabled"                            ,
"Census_IsPenCapable"                              ,
"Census_IsAlwaysOnAlwaysConnectedCapable"          ,
"Wdft_IsGamer"                                     ,
"Wdft_RegionIdentifier"
)


df_all_num_feats <- list()
i <- 1
for(feat in num_feats){
  df_all_num_feats_ <- df_all[c("X1", feat)]
  df_all_num_feats_$feature <- feat
  df_all_num_feats_$value <- as.numeric(df_all_num_feats_[[feat]])
  df_all_num_feats_ <- df_all_num_feats_[c("X1", "feature", "value")]
  df_all_num_feats[[i]] <- df_all_num_feats_
  i <- i + 1
}
df_all_num_feats <- bind_rows(df_all_num_feats)
print("numeric feature")
print(n_distinct(df_all_num_feats$feature))


# # **************************************
# # stack categorical features
# # **************************************
# ohe_feats = c('gender', 'signup_method', 'signup_flow', 'language', 'affiliate_channel', 'affiliate_provider', 'first_affiliate_tracked', 'signup_app', 'first_device_type', 'first_browser')
# df_all_ohe_feats <- list()
# i <- 1
# n_feats <- 0
# for(feat in ohe_feats){
#   df_all_ohe_feats_ <- df_all[c("id", feat)]
#   df_all_ohe_feats_$feature <- paste(feat, df_all_ohe_feats_[[feat]], sep="_")
#   n_feats_ <- n_distinct(df_all_ohe_feats_$feature)
#   df_all_ohe_feats_$value <- 1
#   df_all_ohe_feats_ <- df_all_ohe_feats_[c("id", "feature", "value")]
#   df_all_ohe_feats[[i]] <- df_all_ohe_feats_
#   i <- i + 1
#   n_feats <- n_feats + n_feats_
# }
# df_all_ohe_feats <- bind_rows(df_all_ohe_feats)
# print("categorical feature")
# print(n_feats)




# **************************************
# feature binding template
# **************************************
df_all_feats <-
  bind_rows(
    df_all_num_feats
    # sessions_action_se_mean,
    # sessions_action_type_se_mean,

  )
print("feature number")
print(n_distinct(df_all_feats$feature))

saveRDS(labels, paste0("cache/",folder,"/labels.RData"))
saveRDS(sample_submission_NCI, paste0("cache/",folder,"/sample_submission_NCI.RData"))
saveRDS(df_all, paste0("cache/",folder,"/df_all.RData"))
saveRDS(df_all_feats, paste0("cache/",folder,"/df_all_feats.RData"))
