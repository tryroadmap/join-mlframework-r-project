# **************************************
# stacking template for the module
# **************************************
# X1:
# target: Class
# model: XGBoost
# training-dataset: all training dataset
# **************************************
# X2:
# target: Class
# model: nnet
# training-dataset: all training dataset
# **************************************
# Add more here.
# **************************************




# **************************************
# make dataset for predict Class
# **************************************

response <- "Class"
predictors <- c("V17", "V12", "V16", "V11" ,"V18", "V14", "V7" , "V9",
                "V10" ,"V26", "V4",  "V20" ,"V3" , "V27", "V21", "V8" , "V1", "Amount"
                 )


# X1_all <- subset(df_all_feats, is.na(value)==F)
#
# X1_all$feature_name <- X1_all$feature
# X1_all$feature <- as.numeric(as.factor(X1_all$feature))
# X2 <- subset(X2_all, id %in% subset(df_all, dac_yearmonth %nin% c("201407", "201408", "201409"))$id)
# X2_test <- subset(X2_all, id %in% subset(df_all, dac_yearmonth %in% c("201407", "201408", "201409"))$id)
# X2_all <- rbind(X2, X2_test)
#
# X2_all_feature <- X2_all[!duplicated(X2_all$feature), c("feature", "feature_name")]
# X2_all_feature <- X2_all_feature[order(X2_all_feature$feature),]
#
# X2$id_num <- as.numeric(as.factor(X2$id))
# X2_test$id_num <- as.numeric(as.factor(X2_test$id))
#
# X2_id <- X2 %>% distinct(id_num)
# X2_id <- data.frame(id = X2_id$id, id_num = X2_id$id_num)
# X2_id <- dplyr::left_join(X2_id, df_all[c("id", "dfb_dac_lag_flg")], by = "id")
# X2_id <- X2_id %>%
#   dplyr::arrange(id_num)
# y2 <- X2_id$dfb_dac_lag_flg
#
# X2_test_id <- X2_test %>% distinct(id_num)
# X2_test_id <- data.frame(id = X2_test_id$id, id_num = X2_test_id$id_num)
# X2_test_id <- X2_test_id %>%
#   dplyr::arrange(id_num)
# y2_test <- rep(NA, nrow(X2_test_id))
#
#
# common_feature <- dplyr::intersect(unique(X2$feature), unique(X2_test$feature))
#
# X2 <- na.omit(X2)
# X2 <- subset(X2, feature %in% common_feature)
# X2_sp <- sparseMatrix(i = X2$id_num,
#                       j = X2$feature,
#                       x = X2$value)
# dim(X2_sp)
#
# X2_test <- na.omit(X2_test)
# X2_test <- subset(X2_test, feature %in% common_feature)
# X2_test_sp <- sparseMatrix(i = X2_test$id_num,
#                            j = X2_test$feature,
#                            x = X2_test$value)
# dim(X2_test_sp)
#
# dX2 <- xgb.DMatrix(X2_sp, label = y2, missing = -99999)
# dX2_test <- xgb.DMatrix(X2_test_sp, missing = -99999)

# **************************************
# Predict Class
# **************************************

# **************************************
# For EDA Run Automated MOdel
# **************************************
# Run the automated machine learning

is_xgboost_available = H2OXGBoostEstimator.available()
#h2o.estimators.xgboost.H2OXGBoostEstimator.available()


models_h2o_max <- h2o.automl(
  x = predictors,
  y = response, # labels
  training_frame    = df.train, # training
  leaderboard_frame = df.test, # validation
  max_runtime_secs  = 1000,
  nfolds=6,
  balance_classes = TRUE,
  max_after_balance_size = 100,
  #stopping_metric = "AUC",
  seed = 1234,
  project_name="auto_ml_top10var"

)

lb <- models_h2o_max@leaderboard
automl_leader <- models_h2o@leader
automl_leader
h2o_predic <- h2o.predict(automl_leader, df.test)

Folds <- 10
df.gbm <- h2o.gbm(y = response,
                    x = predictors  ,
                    training_frame=df.train,
                  model_id ="gbm_top10_varimpo",
                  keep_cross_validation_predictions = TRUE,
                  balance_classes = TRUE,
                    nfolds=Folds,
                  learn_rate = 0.05,
                  ntrees = 100, max_depth = 6, min_rows = 3)



# X2_cv <- createFolds(1:nrow(X2_sp), k = Folds)
# X2_stack <- data.frame()
# X2_test_stack <- data.frame()
# for(i in 1:Folds){
#   # i <- 1
#   set.seed(123 * i)
#   X2_id_ <- X2_id[-X2_cv[[i]], ]
#   X2_fold_id_ <- X2_id[X2_cv[[i]], ]
#   X2_sp_ <- X2_sp[-X2_cv[[i]], ]
#   X2_fold_sp_ <- X2_sp[X2_cv[[i]], ]
#   y2_ <- y2[-X2_cv[[i]]]
#   # y2_fold_ <- y2[X2_cv[[i]]]
#
#   dX2_ <- xgb.DMatrix(X2_sp_, label = y2_)
#   dX2_fold_ <- xgb.DMatrix(X2_fold_sp_)
#
#   param <- list("objective" = "multi:softprob",
#                 "eval_metric" = "mlogloss",
#                 "num_class" = 4,
#                 "eta" = 0.01,
#                 "max_depth" = 6,
#                 "subsample" = 0.7,
#                 "colsample_bytree" = 0.3,
#                 # "lambda" = 1.0,
#                 "alpha" = 1.0,
#                 # "min_child_weight" = 6,
#                 # "gamma" = 10,
#                 "nthread" = 24)
#
#   if (i == 1){
#     # Run Cross Valication
#     cv.nround = 3000
#     bst.cv = xgb.cv(param = param,
#                     data = dX2_,
#                     nfold = Folds,
#                     nrounds = cv.nround,
#                     early.stop.round = 10)
#     saveRDS(bst.cv, paste0("cache/",folder,"/X2_bst_cv.RData"))
#   }
#
#   # train xgboost
#   xgb <- xgboost(data = dX2_,
#                  param = param,
#                  nround = which.min(bst.cv$test.mlogloss.mean)
#   )
#
#   # predict values in test set
#   y2_fold_ <- predict(xgb, dX2_fold_)
#   y2_fold_mat <- matrix(y2_fold_, nrow=nrow(X2_fold_sp_), ncol=n_distinct(y2_), byrow=T)
#   y2_fold_df <- as.data.frame(y2_fold_mat)
#   names(y2_fold_df) <- paste0("dfb_dac_lag_flg_", 1:4)
#   y2_fold_df <- mutate(y2_fold_df,
#                        id = unique(X2_fold_id_$id))
#   y2_fold_df <- y2_fold_df[c("id", paste0("dfb_dac_lag_flg_", 1:4))]
#   X2_stack <- bind_rows(X2_stack,
#                         y2_fold_df)
#
#   y2_test_ <- predict(xgb, dX2_test)
#   y2_test_mat <- matrix(y2_test_, nrow=nrow(X2_test_sp), ncol=n_distinct(y2_), byrow=T)
#   y2_test_df <- as.data.frame(y2_test_mat)
#   names(y2_test_df) <- paste0("dfb_dac_lag_flg_", 1:4)
#   y2_test_df <- mutate(y2_test_df,
#                        id = unique(X2_test_id$id))
#   y2_test_df <- y2_test_df[c("id", paste0("dfb_dac_lag_flg_", 1:4))]
#   X2_test_stack <- bind_rows(X2_test_stack,
#                              y2_test_df)
# }
# X2_test_stack <- X2_test_stack %>%
#   group_by(id) %>%
#   summarise_each(funs(mean))
#
# X2_stack <- melt.data.table(as.data.table(X2_stack))
# X2_stack <- data.frame(X2_stack)
# names(X2_stack) <- c("id", "feature", "value")
#
# X2_test_stack <- melt.data.table(as.data.table(X2_test_stack))
# X2_test_stack <- data.frame(X2_test_stack)
# names(X2_test_stack) <- c("id", "feature", "value")
#
# saveRDS(X2_stack, paste0("cache/",folder,"/X2_stack.RData"))
# saveRDS(X2_test_stack, paste0("cache/",folder,"/X2_test_stack.RData"))
#gc()

# # **************************************
# # make dataset for predict Class
# # **************************************
# X3_all <- subset(df_all_feats, is.na(value)==F)
#
# X3_all <- subset(X3_all, feature %nin% c("age"))
# X3_all <- subset(X3_all, feature %nin% c("age_cln"))
# X3_all <- subset(X3_all, feature %nin% c("age_cln2"))
#
# X3_all$feature_name <- X3_all$feature
# X3_all$feature <- as.numeric(as.factor(X3_all$feature))
# X3 <- subset(X3_all, id %in% subset(df_all, is.na(age)==F)$id)
# X3_test <- subset(X3_all, id %in% subset(df_all, is.na(age)==T)$id)
# X3_all <- rbind(X3, X3_test)
#
# X3_all_feature <- X3_all[!duplicated(X3_all$feature), c("feature", "feature_name")]
# X3_all_feature <- X3_all_feature[order(X3_all_feature$feature),]
#
# X3$id_num <- as.numeric(as.factor(X3$id))
# X3_test$id_num <- as.numeric(as.factor(X3_test$id))
#
# X3_id <- X3 %>% distinct(id_num)
# X3_id <- data.frame(id = X3_id$id, id_num = X3_id$id_num)
# X3_id <- dplyr::left_join(X3_id, df_all[c("id", "age")], by = "id")
# X3_id <- X3_id %>%
#   dplyr::arrange(id_num)
# y3 <- X3_id$age
#
# X3_test_id <- X3_test %>% distinct(id_num)
# X3_test_id <- data.frame(id = X3_test_id$id, id_num = X3_test_id$id_num)
# X3_test_id <- X3_test_id %>%
#   dplyr::arrange(id_num)
# y3_test <- rep(NA, nrow(X3_test_id))
#
#
# common_feature <- dplyr::intersect(unique(X3$feature), unique(X3_test$feature))
#
# X3 <- na.omit(X3)
# X3 <- subset(X3, feature %in% common_feature)
# X3_sp <- sparseMatrix(i = X3$id_num,
#                       j = X3$feature,
#                       x = X3$value)
# dim(X3_sp)
#
# X3_test <- na.omit(X3_test)
# X3_test <- subset(X3_test, feature %in% common_feature)
# X3_test_sp <- sparseMatrix(i = X3_test$id_num,
#                            j = X3_test$feature,
#                            x = X3_test$value)
# dim(X3_test_sp)
#
# dX3 <- xgb.DMatrix(X3_sp, label = y3, missing = -99999)
# dX3_test <- xgb.DMatrix(X3_test_sp, missing = -99999)
#
# # **************************************
# # Predict Class
# # **************************************
# Folds <- 10
# X3_cv <- createFolds(1:nrow(X3_sp), k = Folds)
# X3_stack <- data.frame()
# X3_test_stack <- data.frame()
# for(i in 1:Folds){
#   # i <- 1
#   set.seed(123 * i)
#   X3_id_ <- X3_id[-X3_cv[[i]], ]
#   X3_fold_id_ <- X3_id[X3_cv[[i]], ]
#   X3_sp_ <- X3_sp[-X3_cv[[i]], ]
#   X3_fold_sp_ <- X3_sp[X3_cv[[i]], ]
#   y3_ <- y3[-X3_cv[[i]]]
#   # y3_fold_ <- y3[X3_cv[[i]]]
#
#   dX3_ <- xgb.DMatrix(X3_sp_, label = y3_)
#   dX3_fold_ <- xgb.DMatrix(X3_fold_sp_)
#
#   param <- list("objective" = "reg:linear",
#                 "eval_metric" = "rmse",
#                 "eta" = 0.01,
#                 "max_depth" = 6,
#                 "subsample" = 0.7,
#                 "colsample_bytree" = 0.3,
#                 # "lambda" = 1.0,
#                 "alpha" = 1.0,
#                 # "min_child_weight" = 6,
#                 # "gamma" = 10,
#                 "nthread" = 24)
#
#   if (i == 1){
#     # Run Cross Valication
#     cv.nround = 3000
#     bst.cv = xgb.cv(param=param,
#                     data = dX3_,
#                     nfold = Folds,
#                     nrounds=cv.nround,
#                     early.stop.round = 10)
#     saveRDS(bst.cv, paste0("cache/",folder,"/X3_bst_cv.RData"))
#   }
#
#   # train xgboost
#   xgb <- xgboost(data = dX3_,
#                  param = param,
#                  nround = which.min(bst.cv$test.rmse.mean)
#   )
#
#   # predict values in test set
#   y3_fold_ <- predict(xgb, dX3_fold_)
#   y3_fold_df <- data.frame(age_pred = y3_fold_)
#   y3_fold_df <- mutate(y3_fold_df,
#                        id = unique(X3_fold_id_$id))
#   y3_fold_df <- y3_fold_df[c("id", "age_pred")]
#   X3_stack <- bind_rows(X3_stack,
#                         y3_fold_df)
#
#   y3_test_ <- predict(xgb, dX3_test)
#   y3_test_df <- data.frame(age_pred = y3_test_)
#   y3_test_df <- mutate(y3_test_df,
#                        id = unique(X3_test_id$id))
#   y3_test_df <- y3_test_df[c("id", "age_pred")]
#   X3_test_stack <- bind_rows(X3_test_stack,
#                              y3_test_df)
# }
# X3_test_stack <- X3_test_stack %>%
#   group_by(id) %>%
#   summarise_each(funs(mean))
#
# X3_stack <- melt.data.table(as.data.table(X3_stack))
# X3_stack <- data.frame(X3_stack)
# names(X3_stack) <- c("id", "feature", "value")
#
# X3_test_stack <- melt.data.table(as.data.table(X3_test_stack))
# X3_test_stack <- data.frame(X3_test_stack)
# names(X3_test_stack) <- c("id", "feature", "value")
#
# saveRDS(X3_stack, paste0("cache/",folder,"/X3_stack.RData"))
# saveRDS(X3_test_stack, paste0("cache/",folder,"/X3_test_stack.RData"))
# gc()



gc()
