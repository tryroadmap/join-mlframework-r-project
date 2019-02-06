# **************************************
# load data teamplate
# **************************************


#split according to past work
df_train = read_csv("data/train_df.csv",
                    col_types = cols(
                    Time = col_integer())
                  )

df_test = read_csv("data/test_df.csv",
                   col_types = cols(
                     Time = col_integer())
                   )


labels = df_train[, c('X1', 'Class')]
df_test$Class = NA
#NoClassIdentifiad - fill in
sample_submission_NCI <- fread("data/sample_submission_NCI.csv", data.table=F)


# combine train and test data
df_train$dataset <- "train"
df_test$dataset <- "test"
df_all = rbind(df_train, df_test)

# # **************************************
# # clean a variant template
# # **************************************
# df_all <- df_all %>%
#   dplyr::mutate(
#     age_cln = ifelse(age >= 1920, 2015 - age, age),
#     age_cln2 = ifelse(age_cln < 14 | age_cln > 100, -1, age_cln),
#     age_bucket = cut(age, breaks = c(Min(age_cln), 4, 9, 14, 19, 24,
#                                      29, 34, 39, 44, 49, 54,
#                                      59, 64, 69, 74, 79, 84,
#                                      89, 94, 99, Max(age_cln)
#     )),
#     age_bucket = mapvalues(age_bucket,
#                            from=c("(1,4]", "(4,9]", "(9,14]", "(14,19]",
#                                   "(19,24]", "(24,29]", "(29,34]", "(34,39]",
#                                   "(39,44]", "(44,49]", "(49,54]", "(54,59]",
#                                   "(59,64]", "(64,69]", "(69,74]", "(74,79]",
#                                   "(79,84]", "(84,89]", "(89,94]", "(94,99]", "(99,150]"),
#                            to=c("0-4", "5-9", "10-14", "15-19",
#                                 "20-24", "25-29", "30-34", "35-39",
#                                 "40-44", "45-49", "50-54", "55-59",
#                                 "60-64", "65-69", "70-74", "75-79",
#                                 "80-84", "85-89", "90-94", "95-99", "100+"))
  )

# # **************************************
# # feature using date_first_booking Time - data muting, formating in R
# # **************************************
# df_all <- df_all %>%
#   separate(date_account_created, into = c("dac_year", "dac_month", "dac_day"), sep = "-", remove=FALSE) %>%
#   dplyr::mutate(
#     dac_yearmonth = paste0(dac_year, dac_month),
#     dac_yearmonthday = as.numeric(paste0(dac_year, dac_month, dac_day)),
#     dac_week = as.numeric(format(date_account_created+3, "%U")),
#     dac_yearmonthweek = as.numeric(paste0(dac_year, dac_month, formatC(dac_week, width=2, flag="0"))),
#     tfa_year = str_sub(timestamp_first_active, 1, 4),
#     tfa_month = str_sub(timestamp_first_active, 5, 6),
#     tfa_day = str_sub(timestamp_first_active, 7, 8),
#     tfa_yearmonth = str_sub(timestamp_first_active, 1, 6),
#     tfa_yearmonthday = as.numeric(str_sub(timestamp_first_active, 1, 8)),
#     tfa_date = as.Date(paste(tfa_year, tfa_month, tfa_day, sep="-")),
#     tfa_week = as.numeric(format(tfa_date+3, "%U")),
#     tfa_yearmonthweek = as.numeric(paste0(tfa_year, tfa_month, formatC(tfa_week, width=2, flag="0"))),
#     dac_lag = as.numeric(date_account_created - tfa_date),
#     dfb_dac_lag = as.numeric(date_first_booking - date_account_created),
#     dfb_dac_lag_cut = as.character(cut2(dfb_dac_lag, c(0, 1))),
#     dfb_dac_lag_flg = as.numeric(as.factor(ifelse(is.na(dfb_dac_lag_cut)==T, "NA", dfb_dac_lag_cut))) - 1,
#     dfb_tfa_lag = as.numeric(date_first_booking - tfa_date),
#     dfb_tfa_lag_cut = as.character(cut2(dfb_tfa_lag, c(0, 1))),
#     dfb_tfa_lag_flg = as.numeric(as.factor(ifelse(is.na(dfb_tfa_lag_cut)==T, "NA", dfb_tfa_lag_cut))) - 1
#   )


# # **************************************
# # join exmpale V1-28
# # **************************************
# countries <- dplyr::mutate(countries,
#                            language = str_sub(destination_language, 1, 2))
# df_all <- df_all %>%
#   dplyr::mutate(country_destination = country_destination) %>%
#   dplyr::left_join(., countries[c("language", "country_destination", "distance_km", "destination_km2", "language_levenshtein_distance")],
#                    by = c("language", "country_destination"))
# countries$language <- NULL


# # **************************************
# # set validation
# # **************************************
# df_train <- subset(df_all, dataset == "train")
# df_train <- df_train %>%
#   dplyr::mutate(dataset = ifelse(dac_yearmonth %nin% c("201404", "201405", "201406"), "train", "valid"))
# df_test <- subset(df_all, dataset == "test")
# df_all = rbind(df_train, df_test)


# **************************************
# stack numeric features
# **************************************
num_feats <- c(
  'Time',
  'V1',
  'V2',
  'V3',
  'V4',
  'V5',
  'V6',
  'V7',
  'V8',
  'V9',
  'V10',
  'V11',
  'V12',
  'V13',
  'V14',
  'V15',
  'V16',
  'V17',
  'V18',
  'V19',
  'V20',
  'V21',
  'V22',
  'V23',
  'V24',
  'V25',
  'V26',
  'V27',
  'V28',
  'Amount',
  'Class'
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
