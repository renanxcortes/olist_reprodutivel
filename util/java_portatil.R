# Java 17 portátil (64-bit), que não precisa de administrador ----
url_java_17 <- 'https://api.adoptium.net/v3/binary/latest/17/ga/windows/x64/jre/hotspot/normal/eclipse'

# Lê versão e arquitetura de um executável do Java
descreve_java <- function(java) {

  saida <- tryCatch(system2(java, '-version', stdout = TRUE, stderr = TRUE),
                    error = function(e) character(0),
                    warning = function(w) character(0))

  if (length(saida) == 0) return(list(versao = NA, bits_64 = FALSE))

  texto <- sub('.*version "([^"]+)".*', '\\1', saida[1])
  partes <- strsplit(texto, '[._-]')[[1]]
  versao <- suppressWarnings(as.integer(if (partes[1] == '1') partes[2] else partes[1]))

  list(versao = versao, bits_64 = any(grepl('64-Bit', saida)))
}

# O H2O usa o JAVA_HOME primeiro e depois o PATH
localiza_java <- function() {
  java_home <- Sys.getenv('JAVA_HOME')
  if (nzchar(java_home)) return(file.path(java_home, 'bin', 'java.exe'))
  Sys.which('java')
}

# O pacote h2o do CRAN declara suporte às versões 8 a 17
java_compativel <- function() {
  java <- localiza_java()
  if (!nzchar(java)) return(FALSE)
  info <- descreve_java(java)
  isTRUE(info$versao >= 8 && info$versao <= 17 && info$bits_64)
}

# Instala o Java em ferramentas/java usando o zip do pen drive ou a internet
instala_java_portatil <- function() {

  zips <- Sys.glob('instaladores/java/*.zip')

  if (length(zips) > 0) {
    arquivo <- zips[1]
  } else {
    arquivo <- tempfile(fileext = '.zip')
    download.file(url_java_17, arquivo, mode = 'wb')
  }

  dir.create('ferramentas/java', recursive = TRUE, showWarnings = FALSE)
  unzip(arquivo, exdir = 'ferramentas/java')

  java <- Sys.glob('ferramentas/java/*/bin/java.exe')
  if (length(java) == 0) stop('O zip do Java não contém bin/java.exe.', call. = FALSE)
  Sys.setenv(JAVA_HOME = normalizePath(dirname(dirname(java[1]))))
}
