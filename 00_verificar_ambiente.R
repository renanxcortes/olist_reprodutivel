# Verificação do ambiente ----

options("download.file.method" = "wininet")

# Abra o projeto pelo arquivo olist_reprodutivel.Rproj e rode este script inteiro
# uma vez, antes da aula (Ctrl + Shift + Enter). Ele não precisa de administrador.
# Ao final, deve aparecer: AMBIENTE PRONTO.

if (!file.exists('util/pacotes_necessarios.R')) {
  stop('Pasta errada: feche o RStudio e abra o arquivo olist_reprodutivel.Rproj.')
}

source('util/pacotes_necessarios.R')
source('util/java_portatil.R')

options(timeout = 3600) # O padrão de 60 segundos é pouco para o pacote h2o (278 MB)

# Testa gravando um arquivo de verdade, pois no Windows o file.access não é confiável
pasta_gravavel <- function(pasta) {
  dir.create(pasta, recursive = TRUE, showWarnings = FALSE)
  teste <- tempfile(tmpdir = pasta)
  ok <- suppressWarnings(tryCatch(file.create(teste), error = function(e) FALSE))
  if (ok) unlink(teste)
  ok
}

# 1. Biblioteca onde os pacotes serão instalados ----
candidatas <- c(.libPaths(), Sys.getenv('R_LIBS_USER'), file.path(getwd(), 'biblioteca'))
candidatas <- candidatas[nzchar(candidatas)]
biblioteca <- Find(pasta_gravavel, candidatas)

if (is.null(biblioteca)) stop('Nenhuma pasta com permissão de escrita para instalar pacotes.')

.libPaths(c(biblioteca, .libPaths()))
cat('Biblioteca de pacotes:', biblioteca, '\n')

# 2. Pacotes (usa instaladores/ se existir para esta versão do R; senão, o CRAN) ----
faltando <- pacotes_todos[!sapply(pacotes_todos, requireNamespace, quietly = TRUE)]

if (length(faltando) > 0) {

  repositorio <- paste0('file:///', normalizePath('instaladores', winslash = '/', mustWork = FALSE))
  tem_local <- file.exists(file.path(contrib.url('instaladores', 'win.binary'), 'PACKAGES'))
  if (!tem_local) repositorio <- 'https://cloud.r-project.org'

  cat('Instalando', paste(faltando, collapse = ', '), 'a partir de', repositorio, '\n')
  install.packages(faltando, lib = biblioteca, repos = repositorio, type = 'binary')
}

faltando <- pacotes_todos[!sapply(pacotes_todos, requireNamespace, quietly = TRUE)]
if (length(faltando) > 0) stop('Não foi possível instalar: ', paste(faltando, collapse = ', '))
cat('Pacotes: OK\n')

# 3. Java ----
if (!java_compativel()) {
  cat('Java de 8 a 17 (64-bit) não encontrado. Preparando o Java portátil...\n')
  instala_java_portatil()
}

if (!java_compativel()) stop('Não foi possível preparar o Java.')
cat('Java:', localiza_java(), '\n')

# 4. Dados ----
arquivos_dados <- c('customers_dataset', 'orders_dataset', 'order_reviews_dataset',
                    'order_payments_dataset', 'products_dataset', 'sellers_dataset',
                    'product_category_name_translation', 'order_items_dataset')
dados_faltando <- arquivos_dados[!file.exists(paste0('data/', arquivos_dados, '.zip'))]

if (length(dados_faltando) > 0) stop('Dados faltando: ', paste(dados_faltando, collapse = ', '))
if (!file.exists('data/base_model.rds')) stop('Arquivo data/base_model.rds não encontrado.')
cat('Dados: OK\n')

# 5. Teste do H2O ----
library(h2o)
h2o.no_progress()
h2o.init(nthreads = 2, max_mem_size = '2G')

teste <- as.h2o(data.frame(x = 1:100, y = factor(rep(c('a', 'b'), 50))))
modelo <- h2o.glm(y = 'y', x = 'x', training_frame = teste, family = 'binomial')
h2o.shutdown(prompt = FALSE)

cat('\nAMBIENTE PRONTO\n')
