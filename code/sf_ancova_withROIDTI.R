library(tidyverse)
library(readxl)
library(writexl)
library(emmeans)

data <- read_xlsx('data/allparticipants_20ROI_AD.xlsx') %>%
  as_tibble()
fibers <- tail(colnames(data), 20)

res.tab <- data.frame() %>% as_tibble()
for (fiber in fibers) {
  # fiber <- 'ATRL'
  tmp.data <- data %>%
    dplyr::select(GROUP, Age, Gender, EDUTotal, `冠心病BS5`, JDiabetes, JHLP, JCVD, y = all_of(fiber)) %>%
    mutate(GROUP=as.factor(GROUP), Age=as.numeric(Age), Gender=as.factor(Gender), EDUTotal=as.numeric(EDUTotal), `冠心病BS5`=as.factor(`冠心病BS5`), JDiabetes=as.factor(JDiabetes), JHLP=as.factor(JHLP), JCVD=as.factor(JCVD), y=as.numeric(y)) %>%
    drop_na()
  
  # anova
  tmp.model <- lm(y~Age+Gender+EDUTotal+`冠心病BS5`+JDiabetes+JHLP+JCVD+GROUP, data=tmp.data)
  tmp.model.res <- summary(aov(tmp.model))
  
  # Post-hoc: LSD without adjustment
  tmp.posthoc <- emmeans(tmp.model, specs = pairwise ~ GROUP, adjust = 'none')
  tmp.posthoc.res <- tmp.posthoc$contrasts %>% as_tibble() %>% arrange(contrast)
  
  # mean & sd of each group
  tmp.data <- tmp.data %>%
    group_by(GROUP) %>%
    summarise(Mean=mean(y), Sd=sd(y)) %>%
    ungroup() %>%
    arrange(GROUP)
  
  res.tab <- rbind(res.tab, c(fiber, 
               tmp.model.res[[1]]$`F value`[8], 
               tmp.model.res[[1]]$`Pr(>F)`[8],
               tmp.data$Mean,
               tmp.data$Sd,
               tmp.posthoc.res$estimate,
               tmp.posthoc.res$t.ratio,
               tmp.posthoc.res$p.value
               ))
}
colnames(res.tab) <- c('ROI', 'AOV_F_GROUP', 'AOV_P_GROUP', 'Mean_G1', 'Mean_G2', 'Mean_G3', 'SD_G1', 'SD_G2', 'SD_G3', 'Posthoc_G1G2_difference', 'Posthoc_G1G3_difference', 'Posthoc_G2G3_difference', 'Posthoc_G1G2_t_ration', 'Posthoc_G1G3_t_ration', 'Posthoc_G2G3_t_ration', 'Posthoc_G1G2_p_value', 'Posthoc_G1G3_p_value', 'Posthoc_G2G3_p_value')

res.tab <- as.tibble(res.tab)
res.tab$AOV_P_GROUP_Adj <- p.adjust(res.tab$AOV_P_GROUP, method = 'BH')
res.tab <- res.tab %>% relocate(ROI, AOV_F_GROUP, AOV_P_GROUP, AOV_P_GROUP_Adj)

write_xlsx(res.tab, 'data/Summary_allparticipants_20ROI_AD.xlsx')
