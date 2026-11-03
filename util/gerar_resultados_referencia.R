# Resultados de referência (somente professor) ----

# Roda o 02_modelagem_h2o.R e salva em resultados_referencia/ os gráficos, o leaderboard
# e as AUCs, para o aluno acompanhar a aula mesmo se a máquina dele falhar.

View <- function(...) invisible(NULL)

png('resultados_referencia/grafico_%02d.png', width = 1000, height = 650, res = 110)
source('02_modelagem_h2o.R', encoding = 'UTF-8', print.eval = TRUE)
dev.off()

write.csv(lb, 'resultados_referencia/leaderboard_h2o.csv', row.names = FALSE)
writeLines(c(paste('AUC Regressao Logistica (holdout):', round(auc_calculada, 4)),
             paste('AUC Lider H2O (holdout):', round(auc_h2o, 4))),
           'resultados_referencia/auc_holdout.txt')
