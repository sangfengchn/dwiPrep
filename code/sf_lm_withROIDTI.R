library(tidyverse)
library(readxl)
library(writexl)

# load data
data <- read_xlsx('allparticipants_FA.xlsx') %>%
  as_tibble()

# cognition and roi need to statistic
rois <- c('IFOFL', 'IFOFR', 'UFR', 'FMI', 'ILFL', 'ILFR', 'UFL', 'CSTL', 'FMA', 'ATRR', 'SLFL', 'CSTR')
cogs <- c('N5', 'TMT.A', 'TMT.B')

res.tab <- data.frame() %>% as_tibble
for (cog in cogs) {
  for (roi in rois) {
    # cog <- 'N1.N5'
    # roi <- 'IFOFL'
    # tidy data
    tmp.data <- data %>%
      select(y=cog, x=roi, GROUP, Age, Gender, EDUTotal, BS5, JDiabetes, JHLP, JCVD) %>%
      mutate(GROUP = as.factor(GROUP), BS5 = as.factor(BS5), JDiabetes = as.factor(JDiabetes), JHLP = as.factor(JHLP), JCVD = as.factor(JCVD)) %>%
      drop_na()
    
    # linear model and summary of model
    # whole
    tmp.model <- lm(scale(y)~scale(Age)+Gender+scale(EDUTotal)+BS5+JDiabetes+JHLP+JCVD+scale(x), data=tmp.data)
    tmp.model.res <- summary(tmp.model)
    res.tab <- res.tab %>%
      rbind(., c(cog, roi, 'Whole', tmp.model.res$coefficients[9, 1], tmp.model.res$coefficients[9, 3], tmp.model.res$coefficients[9, 4]))
    
    # Group 1
    tmp.data.group <- tmp.data %>% filter(GROUP == '1')
    tmp.model <- lm(scale(y)~scale(Age)+Gender+scale(EDUTotal)+BS5+JDiabetes+JHLP+JCVD+scale(x), data=tmp.data.group)
    tmp.model.res <- summary(tmp.model)
    res.tab <- res.tab %>%
      rbind(., c(cog, roi, 'G1', tmp.model.res$coefficients[9, 1], tmp.model.res$coefficients[9, 3], tmp.model.res$coefficients[9, 4]))
    
    # Group 2
    tmp.data.group <- tmp.data %>% filter(GROUP == '2')
    tmp.model <- lm(scale(y)~scale(Age)+Gender+scale(EDUTotal)+BS5+JDiabetes+JHLP+JCVD+scale(x), data=tmp.data.group)
    tmp.model.res <- summary(tmp.model)
    res.tab <- res.tab %>%
      rbind(., c(cog, roi, 'G2', tmp.model.res$coefficients[9, 1], tmp.model.res$coefficients[9, 3], tmp.model.res$coefficients[9, 4]))
    
    # Group 3
    tmp.data.group <- tmp.data %>% filter(GROUP == '3')
    tmp.model <- lm(scale(y)~scale(Age)+Gender+scale(EDUTotal)+BS5+JDiabetes+JHLP+JCVD+scale(x), data=tmp.data.group)
    tmp.model.res <- summary(tmp.model)
    res.tab <- res.tab %>%
      rbind(., c(cog, roi, 'G3', tmp.model.res$coefficients[9, 1], tmp.model.res$coefficients[9, 3], tmp.model.res$coefficients[9, 4]))
  }
}
# tidy result table
colnames(res.tab) <- c('Cognition', 'Region', 'Group', 'beta', 't', 'p')
res.tab <- res.tab %>%
  as_tibble() %>%
  mutate(Cognition = as.factor(Cognition), Region = as.factor(Region), Group = as.factor(Group), beta = as.numeric(beta), t = as.numeric(t), p = as.numeric(p))
res.tab$p_adj <- p.adjust(res.tab$p, method = 'BH')

# save results
write_xlsx(res.tab, 'Res_allparticipants_FA.xlsx')