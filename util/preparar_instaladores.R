# Preparação do pen drive (somente professor) ----

# Baixa uma vez os pacotes e o Java para instaladores/. Depois, copie a pasta do projeto
# inteira para o pen drive ou para a pasta compartilhada do laboratório.
# IMPORTANTE: rode com a mesma versão do R do laboratório (ex.: 4.5), pois os pacotes
# binários dependem dela. Em versão diferente, o 00_verificar_ambiente.R usa o CRAN.

source('util/pacotes_necessarios.R')
source('util/java_portatil.R')

options(timeout = 3600)

repositorio <- 'https://cloud.r-project.org'
destino <- contrib.url('instaladores', 'win.binary')
dir.create(destino, recursive = TRUE, showWarnings = FALSE)
dir.create('instaladores/java', recursive = TRUE, showWarnings = FALSE)

disponiveis <- available.packages(repos = repositorio, type = 'win.binary')
dependencias <- tools::package_dependencies(pacotes_todos, db = disponiveis, recursive = TRUE)
pacotes <- intersect(unique(c(pacotes_todos, unlist(dependencias))), rownames(disponiveis))

download.packages(pacotes, destdir = destino, repos = repositorio, type = 'win.binary')
tools::write_PACKAGES(destino, type = 'win.binary')

download.file(url_java_17, 'instaladores/java/java17.zip', mode = 'wb')

cat('Instaladores prontos em', normalizePath('instaladores'), '\n')
