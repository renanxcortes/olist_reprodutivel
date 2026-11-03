# Olist reprodutível

Versão dos códigos de `contextos/olist` preparada para rodar em laboratório com Windows,
sem administrador e sem banco de dados.

## Para o aluno

1. Copie esta pasta para um local do computador (evite rodar direto do pen drive).
2. Dê dois cliques em `olist_reprodutivel.Rproj`. Não abra os arquivos `.R` diretamente.
3. Abra `00_verificar_ambiente.R` e rode tudo com `Ctrl + Shift + Enter`.
4. Espere aparecer `AMBIENTE PRONTO`.
5. Siga a aula em `01_importar_transformar_visualizar.R` e `02_modelagem_h2o.R`.

O script 2 funciona mesmo se o script 1 não tiver sido rodado, pois `data/base_model.rds`
já vem na pasta.

## Para o professor

### Antes da aula

1. Abra o projeto e rode `util/preparar_instaladores.R`, com a mesma versão do R do
   laboratório. Isso cria a pasta `instaladores/`, com os pacotes e o Java 17.
2. Copie a pasta do projeto inteira para o pen drive ou para a pasta compartilhada.
3. Rode o `00_verificar_ambiente.R` em uma máquina do laboratório e cronometre.
4. Rode o `02_modelagem_h2o.R` nessa mesma máquina e confira o tempo do AutoML.

### Se algo falhar na aula

| Sintoma | O que fazer |
|---|---|
| `Pasta errada` | Fechar o RStudio e abrir pelo `olist_reprodutivel.Rproj` |
| `Pacotes faltando` | Rodar o `00_verificar_ambiente.R` |
| R com versão diferente dos instaladores | O script usa o CRAN e precisa de internet (o `h2o` tem 278 MB) |
| H2O não sobe ou demora demais | O aluno acompanha por `resultados_referencia/` enquanto o professor roda no projetor |
| `Error in h2o.getConnection()` depois de encerrar o H2O | Pode ignorar: nos testes, essa mensagem não afetou os resultados |

### Tempos de referência

Medidos em uma máquina de 8 núcleos, com a pasta `instaladores/` (415 MB):

| Etapa | Tempo |
|---|---|
| `00_verificar_ambiente.R` em uma biblioteca vazia | cerca de 1 minuto |
| `01_importar_transformar_visualizar.R` | cerca de 30 segundos |
| `02_modelagem_h2o.R` | cerca de 5 minutos |

## O que mudou em relação a `contextos/olist`

- **Dados:** leitura local dos `.zip`, sem Neon e sem senha.
- **Geolocalização:** retirada, pois o join só usava o CEP e não acrescentava colunas.
- **Pacotes:** cada script carrega só o que usa; o script 1 não depende mais do `h2o`.
- **AutoML:** `max_models = 3` no lugar do limite de tempo, com `nthreads` e memória fixos.
  DeepLearning e XGBoost ficam de fora, para os mesmos modelos rodarem em toda máquina.
- **Funções antigas:** `stat()`, `fct_explicit_na()` e `select(var_x)` foram atualizadas.
- **Bancos e tabelas:** o script `0 - Postgres_Create_Tables.R` não foi trazido.

## Estrutura

| Caminho | Conteúdo |
|---|---|
| `00_verificar_ambiente.R` | Instala os pacotes, prepara o Java e testa o H2O |
| `01_importar_transformar_visualizar.R` | Importação, transformação e visualização |
| `02_modelagem_h2o.R` | Regressão logística e AutoML do H2O |
| `data/` | Dados em `.zip` e `base_model.rds` |
| `resultados_referencia/` | Gráficos, leaderboard e AUCs já calculados |
| `util/` | Funções e scripts de preparação do professor |
| `.Rprofile` | Aponta para a biblioteca e o Java locais, quando existem |
