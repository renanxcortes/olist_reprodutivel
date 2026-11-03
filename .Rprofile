# Executado automaticamente ao abrir olist_reprodutivel.Rproj ----
# Usa a biblioteca e o Java locais quando o 00_verificar_ambiente.R precisou criá-los.

local({
  biblioteca <- file.path(getwd(), 'biblioteca')
  if (dir.exists(biblioteca)) .libPaths(c(biblioteca, .libPaths()))

  java <- Sys.glob(file.path(getwd(), 'ferramentas', 'java', '*', 'bin', 'java.exe'))
  if (length(java) > 0) Sys.setenv(JAVA_HOME = dirname(dirname(java[1])))
})
