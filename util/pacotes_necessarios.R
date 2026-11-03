# Pacotes necessários ----
pacotes_script_1 <- c('tidyverse', 'visdat', 'ggridges', 'plotly', 'skimr', 'gridExtra')
pacotes_script_2 <- c('tidyverse', 'PRROC', 'h2o')
pacotes_todos <- unique(c(pacotes_script_1, pacotes_script_2))

# Carrega os pacotes, explicando o que fazer se algum estiver faltando
carrega_pacotes <- function(pacotes) {

  faltando <- pacotes[!sapply(pacotes, requireNamespace, quietly = TRUE)]

  if (length(faltando) > 0) {
    stop('Pacotes faltando: ', paste(faltando, collapse = ', '),
         '. Rode antes o script 00_verificar_ambiente.R.', call. = FALSE)
  }

  for (pacote in pacotes) library(pacote, character.only = TRUE)
}
