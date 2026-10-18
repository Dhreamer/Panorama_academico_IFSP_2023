# Panorama Acadêmico do IFSP — 2023 | SQL e Power BI

Projeto pessoal desenvolvido para analisar as situações das matrículas e os resultados dos ciclos do **Instituto Federal de São Paulo — IFSP**, utilizando dados públicos da **Plataforma Nilo Peçanha — PNP**, edição 2024, ano-base 2023.

Neste projeto, trabalhei com a importação dos arquivos no PostgreSQL, exploração e preparação dos dados com SQL, organização das consultas no Power Query, modelagem, criação de medidas em DAX e construção do dashboard no Power BI.

## Contexto e objetivo

O objetivo foi organizar os dados acadêmicos do IFSP em um painel que permitisse consultar quantidades e percentuais de matrículas por situação, além de acompanhar os resultados presentes na base de eficiência acadêmica.

Separei a análise em dois blocos: **Matrículas em 2023** e **Resultados dos ciclos**. Cada bloco utiliza sua própria base e seu próprio total, mantendo a diferença entre o panorama anual e o conjunto de ciclos acompanhado pela base de eficiência.

O relatório permite filtrar os resultados por campus, tipo de curso, eixo tecnológico, curso, oferta e modalidade de ensino.

## Perguntas respondidas

- Quantas matrículas fazem parte do recorte anual analisado?
- Como essas matrículas se distribuem entre conclusão, abandono, reprovação, transferência e outras situações?
- Qual é a participação de cada situação no total de matrículas do recorte?
- Como os registros da base de eficiência se distribuem entre concluídos, concluintes, em curso e evadidos?
- Quantos registros possuem desfecho, considerando a definição utilizada no projeto?
- Quais situações compõem o grupo de evadidos e qual é a participação de cada uma?
- Como esses resultados mudam ao selecionar diferentes campi e cursos?

## Dados utilizados

Utilizei dois arquivos públicos da PNP, disponíveis no portal de Dados Abertos do MEC:

| Base | Fonte oficial |
|---|---|
| Matrículas | [2023 — Microdados Matrículas](https://dadosabertos.mec.gov.br/pnp/item/260-2023-microdados-matriculas) |
| Eficiência acadêmica | [2023 — Microdados Eficiência Acadêmica](https://dadosabertos.mec.gov.br/pnp/item/261-2023-microdados-eficiencia-academica) |

Os arquivos CSV não estão incluídos neste repositório devido ao tamanho. Para reproduzir a preparação dos dados, eles devem ser baixados nas páginas oficiais acima e extraídos, caso sejam disponibilizados compactados.

Segundo a descrição do MEC, a base de matrículas reúne os vínculos que estiveram ativos em pelo menos um dia do ano-base. A base de eficiência acadêmica acompanha matrículas de ciclos com término previsto no ano anterior ao ano de referência.

Uma linha representa uma **matrícula**, não necessariamente uma pessoa única. As duas bases podem conter vínculos em comum e **não devem ser somadas**.

Mantive os arquivos nacionais no PostgreSQL e utilizei o código de instituição **26439** para selecionar o IFSP.

| Recorte | Quantidade de registros |
|---|---:|
| Matrículas do IFSP antes do tratamento temporal | 77.558 |
| Registros excluídos dos indicadores anuais | 460 |
| Matrículas utilizadas no dashboard | 77.098 |
| Registros da base de eficiência acadêmica do IFSP | 41.703 |

## Como o projeto foi desenvolvido

### 1. Exploração e verificação com SQL

Importei os arquivos no PostgreSQL e conferi as quantidades de registros, os códigos de matrícula e os campos necessários para a análise.

Também verifiquei campos vazios, formatos de datas, datas de início e fim dos ciclos, correspondência entre códigos e nomes dos campi e consistência das informações dos ciclos.

Na estrutura importada, identifiquei uma coluna chamada `municipio` que continha regiões e uma coluna `regiao` que repetia o nome da instituição. Após a conferência, removi a coluna repetida e renomeei a coluna com os valores de região.

O arquivo SQL também preserva consultas exploratórias sobre idade, vagas e carga horária. Esses campos foram investigados durante o aprendizado, mas não fazem parte dos indicadores do dashboard final.

### 2. Preparação das bases para análise

Organizei os dados em dois schemas:

- **`pnp_raw`:** tabelas de importação utilizadas nas consultas exploratórias.
- **`pnp`:** tabelas preparadas do IFSP e a view utilizada no recorte anual.

Nas tabelas preparadas, selecionei os campos necessários e converti o ano e as datas para os tipos adequados.

Na base anual, identifiquei **460 registros com pendências temporais**:

| Pendência | Registros |
|---|---:|
| Entrada posterior a 2023 | 458 |
| Entrada anterior a 2024, mas situação datada de 2024 | 2 |
| Total excluído da análise anual | 460 |

Como não havia informação suficiente para corrigir essas datas, mantive os registros na tabela preparada e criei a view `pnp.matriculas_ifsp_2023_analise` para excluí-los dos indicadores anuais.

Esse tratamento resultou em **77.098 matrículas**. O mesmo filtro não foi aplicado à base de eficiência acadêmica, que possui um recorte diferente.

### 3. Power Query e modelagem de dados

Conectei o Power BI ao PostgreSQL e utilizei a view de matrículas e a tabela preparada de eficiência acadêmica.

No Power Query, ajustei os tipos de dados e organizei as dimensões compartilhadas pelas duas bases. Mantive os códigos de identificação como texto.

O modelo possui duas tabelas fato, **Matrículas** e **Eficiência Acadêmica**, relacionadas às dimensões:

- Campus;
- Tipo de Curso;
- Eixo;
- Curso;
- Oferta;
- Modalidade;
- Situação.

A **Dim Situação** reúne a situação da matrícula e a categoria à qual ela pertence. Os relacionamentos seguem a cardinalidade **um para muitos**, com o filtro partindo das dimensões para as tabelas fato.

Também criei uma tabela **Métricas**, com as medidas organizadas em pastas conforme sua finalidade.

![Modelo de dados do projeto](./Imagens/Modelagem%20de%20Dados.jpg)

### 4. DAX

Criei medidas para calcular totais, percentuais e textos dinâmicos utilizados nos cartões, gráficos e dicas de ferramenta.

Entre os recursos utilizados estão `COUNTROWS`, `CALCULATE`, `DIVIDE`, `REMOVEFILTERS`, `SELECTEDVALUE` e `FORMAT`.

Nos percentuais, mantive a base de comparação correspondente a cada análise:

| Indicador | Cálculo |
|---|---|
| Percentual de uma situação na base anual | Matrículas daquela situação ÷ total de matrículas de todas as situações |
| Percentual de uma categoria na eficiência | Registros daquela categoria ÷ total de registros de eficiência |
| Percentual de uma situação entre os evadidos | Registros daquela situação entre os evadidos ÷ total de evadidos |
| Percentual com desfecho | Concluídos e evadidos ÷ total de registros de eficiência |

As medidas de denominador removem o filtro da dimensão Situação e mantêm os demais filtros, como campus, curso e modalidade.

### 5. Dashboard

Organizei o relatório em uma página com dois blocos de análise.

**Matrículas em 2023** apresenta o total de matrículas, as concluídas, as que estão em curso e a distribuição pelas situações disponíveis.

**Resultados dos ciclos** apresenta o total de registros de eficiência, os registros com desfecho, a distribuição por categoria e o detalhamento das situações que compõem os evadidos.

Os seis filtros permitem explorar os dois blocos, respeitando os totais de cada base. O botão **Limpar** permite limpar as seleções dos filtros.

![Panorama Acadêmico do IFSP — 2023](./Imagens/Imagem%20Dashboard.jpg)

## Dicas de ferramenta

Configurei duas páginas de dicas de ferramenta, exibidas ao passar o mouse sobre os gráficos. Elas mostram o nome da situação ou categoria, a quantidade, o percentual e a base utilizada na divisão.

### Situação da matrícula — gráfico de colunas

![Tooltip do gráfico de colunas](./Imagens/Tooltip-%20Gr%C3%A1fico%20de%20Colunas.jpg)

### Categoria da situação — gráfico de rosca

![Tooltip do gráfico de rosca](./Imagens/Tooltip%20-%20Gr%C3%A1fico%20de%20Rosca.jpg)

As imagens mostram as páginas de configuração sem uma seleção específica. No dashboard, os conteúdos mudam conforme o ponto indicado e os filtros aplicados.

## Ferramentas utilizadas

- PostgreSQL e pgAdmin
- SQL
- Power BI Desktop
- Power Query
- DAX

## Organização dos arquivos

| Arquivo ou pasta | Conteúdo |
|---|---|
| [Dashboard](./Dashboard/) | Relatório em formato `.pbix` |
| [SQL](./SQL/) | Consultas de exploração, verificação e preparação dos dados |
| [Imagens](./Imagens/) | Capturas do dashboard, modelo de dados e tooltips |
| README.md | Documentação do projeto |

## Arquivos do projeto

- [Baixar o relatório em Power BI](./Dashboard/1%20-%20Panorama%20Acad%C3%AAmico%20do%20IFSP%20%E2%80%94%202023.pbix)
- [Visualizar o script SQL](./SQL/Querys%20completas%20-%20Projeto%20IFSP_2023.sql)
- [Consultar os microdados de Matrículas no MEC](https://dadosabertos.mec.gov.br/pnp/item/260-2023-microdados-matriculas)
- [Consultar os microdados de Eficiência Acadêmica no MEC](https://dadosabertos.mec.gov.br/pnp/item/261-2023-microdados-eficiencia-academica)

## Como abrir o projeto

1. Baixe o arquivo `.pbix` disponível na pasta **Dashboard**.
2. Abra o arquivo no **Power BI Desktop**.
3. Explore os filtros, gráficos, tabela e dicas de ferramenta.

Os dados importados estão armazenados no arquivo. Para navegar pelo relatório, não é necessário instalar PostgreSQL nem baixar os CSVs.

Para **atualizar os dados**, é necessário preparar o banco no seu próprio ambiente e configurar a conexão utilizada pelo Power BI. A conexão original utiliza um banco PostgreSQL local.

## Como reproduzir a preparação no PostgreSQL

O script SQL registra as etapas executadas durante o projeto e deve ser utilizado **por blocos, na ordem apresentada**. A importação dos CSVs foi realizada pelo pgAdmin e não está automatizada no script.

1. Instale PostgreSQL e pgAdmin e crie um banco, como `pnp_ifsp_2023`.
2. Baixe os dois arquivos nas fontes oficiais indicadas e extraia os CSVs.
3. Abra o script da pasta **SQL** e execute somente o bloco inicial de criação dos schemas e das duas tabelas `pnp_raw`, antes de **CONFERINDO TABELAS**.
4. Importe cada CSV na tabela correspondente: Matrículas em `pnp_raw.matriculas_2023` e Eficiência Acadêmica em `pnp_raw.eficiencia_2023`. Na importação usada no projeto, o formato é CSV, a codificação é UTF-8, o delimitador é ponto e vírgula, há cabeçalho e o caractere de aspas é `"`.
5. Confira a ordem e a quantidade das colunas antes de importar: a associação é feita pela posição, não pelo nome do cabeçalho.
6. Continue a partir de **CONFERINDO TABELAS**, executando e examinando os resultados dos blocos até a criação das tabelas preparadas e da view final.
7. Confira os totais esperados: **77.558** na tabela preparada de matrículas, **77.098** na view de análise e **41.703** na tabela de eficiência.
8. No Power BI, ajuste a conexão com o PostgreSQL para o servidor, banco e credenciais do seu ambiente.

O script inclui alterações de colunas e criação de objetos que não foram feitas para execução repetida sobre o mesmo banco já preparado. Para reproduzir o processo completo desde o início, utilize um banco novo. Importe cada CSV uma única vez para evitar duplicação de registros.

## Aprendizados

Com este projeto, pratiquei a integração entre SQL e Power BI, desde a conferência dos arquivos até a construção dos indicadores.

Também aprofundei meu entendimento sobre a diferença entre consultar e tratar dados, o uso de tabelas e views, a organização de dimensões compartilhadas e o efeito do contexto de filtro nas medidas DAX.

Um dos principais aprendizados foi definir o que cada base representa antes de calcular percentuais, além de documentar as decisões de tratamento sem substituir informações inconsistentes por valores presumidos.

## Observações sobre a análise

- **Matrícula não é pessoa única:** os totais representam vínculos registrados nas bases.
- **As duas bases têm recortes diferentes:** seus totais não devem ser somados nem usados como denominadores um do outro.
- **2023 é o ano de referência:** não significa que todos os cursos começaram ou terminaram nesse ano. A data prevista de término, sozinha, não determina a situação da matrícula.
- **Com desfecho**, neste projeto, corresponde à soma de **Concluídos + Evadidos** na base de eficiência. Não significa que todos concluíram o curso com sucesso.
- **Concluintes** e **Concluídos** são categorias diferentes na base: a situação Integralizada pertence a Concluintes, enquanto Concluída pertence a Concluídos.
- **Evadidos** reúne as situações Abandono, Reprovado, Desligada, Cancelada, Transf. externa e Transf. interna, conforme o agrupamento encontrado nos dados.
- Os percentuais apresentados descrevem a composição dos recortes analisados. O percentual **com desfecho não é o Índice de Eficiência Acadêmica oficial da PNP**.
- A exclusão dos **460 registros** é uma decisão de tratamento do recorte anual deste projeto. Os registros permanecem na tabela preparada para consulta.
- A análise descreve os registros disponíveis e suas distribuições. Ela não identifica as causas de abandono, transferência ou outras situações.
