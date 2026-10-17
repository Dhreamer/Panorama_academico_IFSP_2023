-- Projeto IFSP | PNP 2024, ano-base 2023
-- CRIANDO O BANCO DE DADOS

CREATE SCHEMA IF NOT EXISTS pnp_raw;
CREATE SCHEMA IF NOT EXISTS pnp;


CREATE TABLE IF NOT EXISTS pnp_raw.matriculas_2023 (
    ano text,
    carga_horaria text,
    carga_horaria_minima text,
    categoria_da_situacao text,
    co_inst text,
    cod_unidade text,
    cor_raca text,
    codigo_da_matricula text,
    codigo_da_unidade_de_ensino_sistec text,
    codigo_do_ciclo_matricula text,
    codigo_do_municipio_com_dv text,
    data_de_fim_previsto_do_ciclo text,
    data_de_inicio_do_ciclo text,
    data_de_ocorrencia_da_matricula text,
    eixo_tecnologico text,
    faixa_etaria text,
    fator_esforco_curso text,
    fonte_de_financiamento text,
    idade text,
    instituicao text,
    matricula_atendida text,
    modalidade_de_ensino text,
    municipio text,
    mes_de_ocorrencia_da_situacao text,
    nome_de_curso text,
    numero_de_registros text,
    regiao text,
    renda_familiar text,
    sexo text,
    situacao_de_matricula text,
    subeixo_tecnologico text,
    tipo_de_curso text,
    tipo_de_oferta text,
    total_de_inscritos text,
    turno text,
    uf text,
    unidade_de_ensino text,
    vagas_extraordinarias_ac text,
    vagas_extraordinarias_l1 text,
    vagas_extraordinarias_l10 text,
    vagas_extraordinarias_l13 text,
    vagas_extraordinarias_l14 text,
    vagas_extraordinarias_l2 text,
    vagas_extraordinarias_l5 text,
    vagas_extraordinarias_l6 text,
    vagas_extraordinarias_l9 text,
    vagas_regulares_ac text,
    vagas_regulares_l1 text,
    vagas_regulares_l10 text,
    vagas_regulares_l13 text,
    vagas_regulares_l14 text,
    vagas_regulares_l2 text,
    vagas_regulares_l5 text,
    vagas_regulares_l6 text,
    vagas_regulares_l9 text
);

CREATE TABLE IF NOT EXISTS pnp_raw.eficiencia_2023 (
    ano text,
    carga_horaria text,
    carga_horaria_minima text,
    categoria_da_situacao text,
    co_inst text,
    cod_unidade text,
    cor_raca text,
    codigo_da_matricula text,
    codigo_da_unidade_de_ensino_sistec text,
    codigo_do_ciclo_matricula text,
    codigo_do_municipio_com_dv text,
    data_de_fim_previsto_do_ciclo text,
    data_de_inicio_do_ciclo text,
    data_de_ocorrencia_da_matricula text,
    eixo_tecnologico text,
    faixa_etaria text,
    fator_esforco_curso text,
    fonte_de_financiamento text,
    idade text,
    instituicao text,
    matricula_atendida text,
    modalidade_de_ensino text,
    municipio text,
    mes_de_ocorrencia_da_situacao text,
    nome_de_curso text,
    numero_de_registros text,
    regiao text,
    renda_familiar text,
    sexo text,
    situacao_de_matricula text,
    subeixo_tecnologico text,
    tipo_de_curso text,
    tipo_de_oferta text,
    turno text,
    uf text,
    unidade_de_ensino text,
    vagas_extraordinarias_ac text,
    vagas_extraordinarias_l1 text,
    vagas_extraordinarias_l10 text,
    vagas_extraordinarias_l13 text,
    vagas_extraordinarias_l14 text,
    vagas_extraordinarias_l2 text,
    vagas_extraordinarias_l5 text,
    vagas_extraordinarias_l6 text,
    vagas_extraordinarias_l9 text,
    vagas_regulares_ac text,
    vagas_regulares_l1 text,
    vagas_regulares_l10 text,
    vagas_regulares_l13 text,
    vagas_regulares_l14 text,
    vagas_regulares_l2 text,
    vagas_regulares_l5 text,
    vagas_regulares_l6 text,
    vagas_regulares_l9 text
);


-- CONFERINDO TABELAS

SELECT
	'Matrícula' AS arquivo,
	COUNT(*) AS total_brasil,
	COUNT(*) FILTER (WHERE co_inst = '26439') AS total_ifsp
FROM pnp_raw.matriculas_2023

UNION

SELECT
	'Eficiência acadêmica',
	COUNT (*),
	COUNT (*) FILTER (WHERE co_inst = '26439')
FROM pnp_raw.eficiencia_2023;


-- CONFERINDO MATRICULAS SEM CÓDIGO OU CÓDIGO REPETIDO
SELECT
	'matriculas_2023' AS arquivo,
	COUNT(*) AS total_linhas,
	COUNT(codigo_da_matricula) AS linhas_com_codigo,
	COUNT(DISTINCT codigo_da_matricula) AS codigos_diferentes
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'

UNION ALL

SELECT
	'eficiência_2023',
	COUNT(*),
	COUNT(codigo_da_matricula),
	COUNT(DISTINCT codigo_da_matricula)
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439';


-- VERIFICANDO ESPAÇOS VAZIOS EM CAMPOS ESSENCIAIS
SELECT
	'matricula_2023' AS arquivo,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(codigo_da_matricula), '') IS NULL) AS sem_codigo,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(cod_unidade), '') IS NULL) AS sem_campus,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(tipo_de_curso), '') IS NULL) AS sem_tipo,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(eixo_tecnologico), '') IS NULL) AS sem_eixo,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(nome_de_curso), '') IS NULL) AS sem_curso,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(situacao_de_matricula), '') IS NULL) AS sem_situacao,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(data_de_inicio_do_ciclo), '') IS NULL) AS sem_inicio,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(data_de_fim_previsto_do_ciclo), '') IS NULL) AS sem_fim
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'

UNION ALL

SELECT
	'eficiencia_2023',
    COUNT(*) FILTER (WHERE NULLIF(TRIM(codigo_da_matricula), '') IS NULL),
    COUNT(*) FILTER (WHERE NULLIF(TRIM(cod_unidade), '') IS NULL),
    COUNT(*) FILTER (WHERE NULLIF(TRIM(tipo_de_curso), '') IS NULL),
    COUNT(*) FILTER (WHERE NULLIF(TRIM(eixo_tecnologico), '') IS NULL),
    COUNT(*) FILTER (WHERE NULLIF(TRIM(nome_de_curso), '') IS NULL),
    COUNT(*) FILTER (WHERE NULLIF(TRIM(situacao_de_matricula), '') IS NULL),
    COUNT(*) FILTER (WHERE NULLIF(TRIM(data_de_inicio_do_ciclo), '') IS NULL),
    COUNT(*) FILTER (WHERE NULLIF(TRIM(data_de_fim_previsto_do_ciclo), '') IS NULL)
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439';


-- CATEGORIAS E SITUAÇÕES DE MATRÍCULA

SELECT
	'Matrículas' AS arquivo,
	categoria_da_situacao AS categoria,
	situacao_de_matricula AS situacao,
	COUNT(*) AS quantidade
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'
GROUP BY categoria_da_situacao, situacao_de_matricula

UNION ALL

SELECT
	'Eficiência acadêmica',
	categoria_da_situacao,
	situacao_de_matricula,
	COUNT(*)
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439'
GROUP BY categoria_da_situacao, situacao_de_matricula
ORDER BY arquivo, categoria, situacao;


-- VALIDAÇÃO DAS DATAS DOS CICLOS
SELECT
	'Matriculas' AS arquivo,
	COUNT(*) FILTER(WHERE data_de_inicio_do_ciclo !~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
		OR data_de_fim_previsto_do_ciclo !~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$') AS formato_diferente,
	COUNT(*) FILTER(WHERE TO_DATE(data_de_fim_previsto_do_ciclo, 'DD/MM/YYYY')< TO_DATE(data_de_inicio_do_ciclo, 'DD/MM/YYYY')) AS fim_antes_do_inicio
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'

UNION ALL

SELECT
    'Eficiência acadêmica',
    COUNT(*) FILTER(WHERE data_de_inicio_do_ciclo !~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
           OR data_de_fim_previsto_do_ciclo !~ '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'),
    COUNT(*) FILTER(WHERE TO_DATE(data_de_fim_previsto_do_ciclo, 'DD/MM/YYYY') < TO_DATE(data_de_inicio_do_ciclo, 'DD/MM/YYYY'))
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439';


-- INSPEÇÃO DOS VALORES DE VAGAS REGULARES L13
SELECT
	'Matrículas' AS arquivo,
	vagas_regulares_l13 AS valor,
	COUNT(*) AS quantidade
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'
GROUP BY vagas_regulares_l13

UNION ALL

SELECT
	'Eficiência acadêmica',
	vagas_regulares_l13,
	COUNT(*)
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439'
GROUP BY vagas_regulares_l13
ORDER BY arquivo, valor;


-- REGISTROS COM L13 NEGATIVO OU VAZIO
SELECT
	'Matrículas' AS arquivo,
	codigo_da_matricula,
	cod_unidade,
    nome_de_curso,
    data_de_inicio_do_ciclo,
    data_de_fim_previsto_do_ciclo,
    vagas_regulares_l13 AS valor_l13
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'
	AND (TRIM(vagas_regulares_l13) = '-1'
		OR NULLIF(TRIM(vagas_regulares_l13), '') IS NULL)

UNION ALL

SELECT
    'Eficiência acadêmica',
    codigo_da_matricula,
    cod_unidade,
    nome_de_curso,
    data_de_inicio_do_ciclo,
    data_de_fim_previsto_do_ciclo,
    vagas_regulares_l13
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439'
  AND (TRIM(vagas_regulares_l13) = '-1'
      OR NULLIF(TRIM(vagas_regulares_l13), '') IS NULL)
ORDER BY arquivo, cod_unidade, nome_de_curso;

-- DETALHAMENTO DOS REGISTROS COM L13 IGUAL A -1
SELECT *
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'
	AND TRIM(vagas_regulares_l13) = '-1'


-- VERIFICANDO COLUNA MUNICIPIO
SELECT
	'Eficiencia' AS arquivo,
	municipio,
	COUNT(DISTINCT municipio)
FROM pnp_raw.eficiencia_2023
GROUP BY municipio

UNION ALL

SELECT
	'matricula',
	municipio,
	COUNT(DISTINCT municipio)
FROM pnp_raw.matriculas_2023
GROUP BY municipio;


-- VERIFICANDO COLUNAS DUPLICADAS
SELECT
	'eficiencia' AS arquivo,
	regiao,
	COUNT (DISTINCT regiao) AS nome_instituto
FROM pnp_raw.eficiencia_2023
GROUP BY regiao

UNION ALL

SELECT
	'matricula',
	regiao,
	COUNT (DISTINCT regiao) AS nome_instituto
FROM pnp_raw.matriculas_2023
GROUP BY regiao;



SELECT
	'eficiencia' AS arquivo,
	regiao,
	instituicao,
	COUNT (DISTINCT instituicao) AS nome_instituto
FROM pnp_raw.eficiencia_2023
GROUP BY instituicao, regiao

UNION ALL

SELECT
	'matricula',
	regiao,
	instituicao,
	COUNT (DISTINCT instituicao) AS nome_instituto
FROM pnp_raw.matriculas_2023
GROUP BY instituicao, regiao;


-- DELETANDO COLUNA REPETIDA E ALTERANDO NOMES DAS COLUNAS
BEGIN;

ALTER TABLE pnp_raw.matriculas_2023
DROP COLUMN regiao;

ALTER TABLE pnp_raw.matriculas_2023
RENAME COLUMN municipio TO regiao;

ALTER TABLE pnp_raw.eficiencia_2023
DROP COLUMN regiao;

ALTER TABLE pnp_raw.eficiencia_2023
RENAME COLUMN municipio TO regiao;

COMMIT;


-- VERIFICAÇÃO DE IDADE E CARGA HORÁRIA
SELECT
    'Matrículas' AS arquivo,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(idade), '') IS NULL
           OR TRIM(idade) !~ '^[0-9]+$') AS idade_a_investigar,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(carga_horaria), '') IS NULL
           OR TRIM(carga_horaria) !~ '^[0-9]+$') AS carga_horaria_a_investigar,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(carga_horaria_minima), '') IS NULL
           OR TRIM(carga_horaria_minima) !~ '^[0-9]+$') AS carga_minima_a_investigar
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'

UNION ALL

SELECT
    'Eficiência acadêmica',
    COUNT(*) FILTER(WHERE NULLIF(TRIM(idade), '') IS NULL
           OR TRIM(idade) !~ '^[0-9]+$'),
    COUNT(*) FILTER(WHERE NULLIF(TRIM(carga_horaria), '') IS NULL
           OR TRIM(carga_horaria) !~ '^[0-9]+$'),
    COUNT(*) FILTER(WHERE NULLIF(TRIM(carga_horaria_minima), '') IS NULL
           OR TRIM(carga_horaria_minima) !~ '^[0-9]+$')
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439';



-- MENORES E MAIORES VALORES DE IDADE E CARGA HORÁRIA
SELECT
    'Matrículas' AS arquivo,
    MIN(CAST(idade AS INTEGER)) AS menor_idade,
    MAX(CAST(idade AS INTEGER)) AS maior_idade,
    MIN(CAST(carga_horaria AS INTEGER)) AS menor_carga,
    MAX(CAST(carga_horaria AS INTEGER)) AS maior_carga,
    MIN(CAST(carga_horaria_minima AS INTEGER)) AS menor_carga_minima,
    MAX(CAST(carga_horaria_minima AS INTEGER)) AS maior_carga_minima
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'

UNION ALL

SELECT
    'Eficiência acadêmica',
    MIN(CAST(idade AS INTEGER)),
    MAX(CAST(idade AS INTEGER)),
    MIN(CAST(carga_horaria AS INTEGER)),
    MAX(CAST(carga_horaria AS INTEGER)),
    MIN(CAST(carga_horaria_minima AS INTEGER)),
    MAX(CAST(carga_horaria_minima AS INTEGER))
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439';


-- INVESTIGAÇÃO DAS IDADES EXTREMAS
SELECT
    'Matrículas' AS arquivo,
    codigo_da_matricula,
    idade,
    faixa_etaria,
    nome_de_curso,
    tipo_de_curso,
    unidade_de_ensino
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'
  AND CAST(idade AS INTEGER) IN (4, 1958)

UNION ALL

SELECT
    'Eficiência acadêmica',
    codigo_da_matricula,
    idade,
    faixa_etaria,
    nome_de_curso,
    tipo_de_curso,
    unidade_de_ensino
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439'
  AND CAST(idade AS INTEGER) IN (2, 89);


-- IDADES ASSOCIADAS À FAIXA ETÁRIA S/I
SELECT
    'Matrículas' AS arquivo,
    CAST(idade AS INTEGER) AS idade,
    COUNT(*) AS quantidade
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'
  AND TRIM(faixa_etaria) = 'S/I'
GROUP BY CAST(idade AS INTEGER)

UNION ALL

SELECT
    'Eficiência acadêmica',
    CAST(idade AS INTEGER),
    COUNT(*)
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439'
  AND TRIM(faixa_etaria) = 'S/I'
GROUP BY CAST(idade AS INTEGER)

ORDER BY arquivo, idade;


-- DETALHAMENTO DA IDADE 4 EM EFICIÊNCIA
SELECT
    codigo_da_matricula,
    idade,
    faixa_etaria,
    nome_de_curso,
    tipo_de_curso,
    unidade_de_ensino
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439'
  AND CAST(idade AS INTEGER) = 4;

-- DIAGNÓSTICO | IDADES INCONSISTENTES
-- Eficiência: matrículas 105084958 (2) e 96876516 (4).
-- Matrículas: matrículas 115766935 (4) e 113111060 (1958).
-- Tratamento proposto para a versão limpa:
-- manter as matrículas, preservar a idade original e usar NULL
-- na idade tratada, com indicação do motivo.
-- Não substituir por uma idade presumida nem por zero.




-- CURSOS COM CARGAS HORÁRIAS EXTREMAS
SELECT
    'Matrículas' AS arquivo,
    nome_de_curso,
    tipo_de_curso,
    CAST(carga_horaria AS INTEGER) AS carga_horaria,
    CAST(carga_horaria_minima AS INTEGER) AS carga_minima,
    COUNT(*) AS quantidade_matriculas
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'
  AND CAST(carga_horaria AS INTEGER) IN (16, 5027)
GROUP BY
    nome_de_curso,
    tipo_de_curso,
    carga_horaria,
    carga_horaria_minima

UNION ALL

SELECT
    'Eficiência acadêmica',
    nome_de_curso,
    tipo_de_curso,
    CAST(carga_horaria AS INTEGER),
    CAST(carga_horaria_minima AS INTEGER),
    COUNT(*)
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439'
  AND CAST(carga_horaria AS INTEGER) IN (20, 5027)
GROUP BY
    nome_de_curso,
    tipo_de_curso,
    carga_horaria,
    carga_horaria_minima
ORDER BY arquivo, carga_horaria, nome_de_curso;


-- CONTEXTO DOS CURSOS COM CARGAS SUSPEITAS
SELECT DISTINCT
    'Matrículas' AS arquivo,
    codigo_do_ciclo_matricula,
    unidade_de_ensino,
    nome_de_curso,
    tipo_de_oferta,
    data_de_inicio_do_ciclo,
    data_de_fim_previsto_do_ciclo,
    CAST(carga_horaria AS INTEGER) AS carga_horaria,
    CAST(carga_horaria_minima AS INTEGER) AS carga_minima
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'
  AND nome_de_curso IN ('Qualificação Profissional - Desenvolvimento Educacional e Social', 'Técnico em Informática')
  AND CAST(carga_horaria AS INTEGER) IN (16, 20, 5027)

UNION ALL

SELECT DISTINCT
    'Eficiência acadêmica',
    codigo_do_ciclo_matricula,
    unidade_de_ensino,
    nome_de_curso,
    tipo_de_oferta,
    data_de_inicio_do_ciclo,
    data_de_fim_previsto_do_ciclo,
    CAST(carga_horaria AS INTEGER),
    CAST(carga_horaria_minima AS INTEGER)
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439'
  AND nome_de_curso IN ('Qualificação Profissional - Desenvolvimento Educacional e Social', 'Técnico em Informática')
  AND CAST(carga_horaria AS INTEGER) IN (16, 20, 5027)
ORDER BY nome_de_curso, codigo_do_ciclo_matricula, arquivo;


-- CARGAS HORÁRIAS DISPONÍVEIS POR CURSO
SELECT DISTINCT
    'Matrículas' AS arquivo,
    nome_de_curso,
    tipo_de_curso,
    tipo_de_oferta,
    CAST(carga_horaria AS INTEGER) AS carga_horaria
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'

UNION ALL

SELECT DISTINCT
    'Eficiência acadêmica',
    nome_de_curso,
    tipo_de_curso,
    tipo_de_oferta,
    CAST(carga_horaria AS INTEGER)
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439'
ORDER BY carga_horaria,nome_de_curso, tipo_de_oferta, arquivo;


-- CONSISTÊNCIA DOS CÓDIGOS E NOMES DOS CAMPI
WITH campi AS (
    SELECT cod_unidade, unidade_de_ensino
    FROM pnp_raw.matriculas_2023
    WHERE co_inst = '26439'

    UNION ALL

    SELECT cod_unidade, unidade_de_ensino
    FROM pnp_raw.eficiencia_2023
    WHERE co_inst = '26439')
SELECT
    cod_unidade,
    COUNT(DISTINCT unidade_de_ensino) AS quantidade_de_nomes
FROM campi
GROUP BY cod_unidade
HAVING COUNT(DISTINCT unidade_de_ensino) > 1
ORDER BY cod_unidade;


-- CONSISTÊNCIA DA IDENTIFICAÇÃO DOS CICLOS
WITH ciclos AS (
    SELECT
        codigo_do_ciclo_matricula,
        cod_unidade,
        nome_de_curso,
        tipo_de_curso,
        eixo_tecnologico
    FROM pnp_raw.matriculas_2023
    WHERE co_inst = '26439'

    UNION ALL

    SELECT
        codigo_do_ciclo_matricula,
        cod_unidade,
        nome_de_curso,
        tipo_de_curso,
        eixo_tecnologico
    FROM pnp_raw.eficiencia_2023
    WHERE co_inst = '26439')
SELECT
    codigo_do_ciclo_matricula,
    COUNT(DISTINCT cod_unidade) AS quantidade_campi,
    COUNT(DISTINCT nome_de_curso) AS quantidade_nomes,
    COUNT(DISTINCT tipo_de_curso) AS quantidade_tipos,
    COUNT(DISTINCT eixo_tecnologico) AS quantidade_eixos
FROM ciclos
GROUP BY codigo_do_ciclo_matricula
HAVING COUNT(DISTINCT cod_unidade) > 1
    OR COUNT(DISTINCT nome_de_curso) > 1
    OR COUNT(DISTINCT tipo_de_curso) > 1
    OR COUNT(DISTINCT eixo_tecnologico) > 1
ORDER BY codigo_do_ciclo_matricula;


-- CONTAGEM DE MATRÍCULAS E ABANDONOS
SELECT
    'Total de matrículas' AS indicador,
    COUNT(*) AS quantidade
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'

UNION ALL

SELECT
    'Matrículas em abandono',
    COUNT(*)
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'
  AND situacao_de_matricula = 'Abandono';


-- TOTAL DE MATRÍCULAS E PERCENTUAL DE ABANDONO
WITH contagens AS (
    SELECT
        COUNT(*) AS total_matriculas,
        COUNT(*) FILTER (WHERE situacao_de_matricula = 'Abandono') AS total_abandono
    FROM pnp_raw.matriculas_2023
    WHERE co_inst = '26439')
SELECT
    total_matriculas,
    total_abandono,
    total_abandono * 100.0 / total_matriculas AS percentual_abandono
FROM contagens;


-- ABANDONO POR CAMPUS E CURSO
WITH contagens AS (
    SELECT
        cod_unidade,
        unidade_de_ensino,
        eixo_tecnologico,
        tipo_de_curso,
        nome_de_curso,
        tipo_de_oferta,
        COUNT(*) AS total_matriculas,
        COUNT(*) FILTER (WHERE situacao_de_matricula = 'Abandono') AS total_abandono
    FROM pnp_raw.matriculas_2023
    WHERE co_inst = '26439'
    GROUP BY
        cod_unidade,
        unidade_de_ensino,
        eixo_tecnologico,
        tipo_de_curso,
        nome_de_curso,
        tipo_de_oferta)
SELECT *,
    total_abandono * 100.0 / total_matriculas AS percentual_abandono
FROM contagens
ORDER BY percentual_abandono DESC, total_matriculas DESC;


-- CONTEXTO DO GRUPO COM UMA MATRÍCULA
SELECT
    codigo_da_matricula,
    codigo_do_ciclo_matricula,
    nome_de_curso,
    data_de_inicio_do_ciclo,
    data_de_fim_previsto_do_ciclo,
    data_de_ocorrencia_da_matricula,
    situacao_de_matricula
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'
  AND cod_unidade = '200'
  AND eixo_tecnologico = 'Turismo, Hospitalidade e Lazer'
  AND tipo_de_curso = 'Tecnologia'
  AND nome_de_curso = 'Gestão de Turismo'
  AND tipo_de_oferta = 'Não se aplica';


-- ABANDONOS POR ANO DE OCORRÊNCIA
SELECT
    EXTRACT(YEAR FROM TO_DATE(mes_de_ocorrencia_da_situacao, 'DD/MM/YYYY')) AS ano_abandono,
    COUNT(*) AS total_abandono
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'
  AND situacao_de_matricula = 'Abandono'
GROUP BY ano_abandono
ORDER BY ano_abandono;


-- CONFERÊNCIA DO PERÍODO E DA MATRÍCULA ATENDIDA
WITH base AS (
    SELECT
        'Matrículas' AS arquivo,
        ano,
        matricula_atendida,
        situacao_de_matricula,
        mes_de_ocorrencia_da_situacao
    FROM pnp_raw.matriculas_2023
    WHERE co_inst = '26439'

    UNION ALL

    SELECT
        'Eficiência acadêmica',
        ano,
        matricula_atendida,
        situacao_de_matricula,
        mes_de_ocorrencia_da_situacao
    FROM pnp_raw.eficiencia_2023
    WHERE co_inst = '26439')
SELECT
    arquivo,
    ano,
    matricula_atendida,
    situacao_de_matricula,
    EXTRACT(YEAR FROM TO_DATE(mes_de_ocorrencia_da_situacao, 'DD/MM/YYYY')) AS ano_situacao,
    COUNT(*) AS quantidade
FROM base
GROUP BY
    arquivo,
    ano,
    matricula_atendida,
    situacao_de_matricula,
    ano_situacao
ORDER BY
    arquivo,
    matricula_atendida,
    situacao_de_matricula,
    ano_situacao;


-- MATRÍCULAS COM SITUAÇÃO EM CURSO DATADA DE 2024
SELECT
    EXTRACT(YEAR FROM TO_DATE(data_de_ocorrencia_da_matricula, 'DD/MM/YYYY')) AS ano_matricula,
    EXTRACT(YEAR FROM TO_DATE(data_de_inicio_do_ciclo, 'DD/MM/YYYY')) AS ano_inicio_ciclo,
    COUNT(*) AS quantidade
FROM pnp_raw.matriculas_2023
WHERE co_inst = '26439'
  AND ano = '2023'
  AND matricula_atendida = 'Sim'
  AND situacao_de_matricula = 'Em curso'
  AND EXTRACT(YEAR FROM TO_DATE(mes_de_ocorrencia_da_situacao, 'DD/MM/YYYY')) = 2024
GROUP BY ano_matricula, ano_inicio_ciclo
ORDER BY ano_matricula, ano_inicio_ciclo;


-- CONFERÊNCIA DO ANO DE ENTRADA DAS MATRÍCULAS
WITH base AS (
	SELECT TO_DATE(data_de_ocorrencia_da_matricula, 'DD/MM/YYYY') AS data_matricula
    FROM pnp_raw.matriculas_2023
    WHERE co_inst = '26439')
SELECT
    COUNT(*) AS total_matriculas,
    COUNT(*) FILTER(WHERE data_matricula < TO_DATE('01/01/2024', 'DD/MM/YYYY')) AS entradas_ate_2023,
    COUNT(*) FILTER(WHERE data_matricula >= TO_DATE('01/01/2024', 'DD/MM/YYYY')) AS entradas_apos_2023,
    COUNT(*) FILTER (WHERE data_matricula IS NULL) AS sem_data_matricula
FROM base;




-- CRIAÇÃO DA TABELA PREPARADA DE MATRÍCULAS DO IFSP
CREATE TABLE pnp.matriculas_ifsp_2023 AS
WITH base AS (
    SELECT
        CAST(ano AS INTEGER) AS ano,
        codigo_da_matricula,
        codigo_do_ciclo_matricula,
        co_inst,
        instituicao,
        cod_unidade,
        unidade_de_ensino,
        eixo_tecnologico,
        tipo_de_curso,
        nome_de_curso,
        tipo_de_oferta,
        modalidade_de_ensino,
        categoria_da_situacao,
        situacao_de_matricula,
        matricula_atendida,
        TO_DATE(data_de_ocorrencia_da_matricula, 'DD/MM/YYYY') AS data_matricula,
        TO_DATE(mes_de_ocorrencia_da_situacao, 'DD/MM/YYYY') AS data_situacao
    FROM pnp_raw.matriculas_2023
    WHERE co_inst = '26439'
      AND ano = '2023')
SELECT *,
    CASE
        WHEN data_matricula >= TO_DATE('01/01/2024', 'DD/MM/YYYY')
            THEN 'Entrada após 2023'
        WHEN data_situacao >= TO_DATE('01/01/2024', 'DD/MM/YYYY')
            THEN 'Situação após 2023'
        ELSE 'Sem pendência temporal identificada'
    END AS pendencia_temporal
FROM base;


-- CONFERÊNCIA DA TABELA PREPARADA
SELECT
    pendencia_temporal,
    COUNT(*) AS quantidade
FROM pnp.matriculas_ifsp_2023
GROUP BY pendencia_temporal
ORDER BY pendencia_temporal;


-- CRIAÇÃO DA TABELA PREPARADA DE EFICIÊNCIA DO IFSP
CREATE TABLE pnp.eficiencia_ifsp_2023 AS
SELECT
    CAST(ano AS INTEGER) AS ano,
    codigo_da_matricula,
    codigo_do_ciclo_matricula,
    co_inst,
    instituicao,
    cod_unidade,
    unidade_de_ensino,
    eixo_tecnologico,
    tipo_de_curso,
    nome_de_curso,
    tipo_de_oferta,
    modalidade_de_ensino,
    categoria_da_situacao,
    situacao_de_matricula,
    matricula_atendida,
    TO_DATE(data_de_ocorrencia_da_matricula, 'DD/MM/YYYY') AS data_matricula,
    TO_DATE(mes_de_ocorrencia_da_situacao, 'DD/MM/YYYY') AS data_situacao,
    TO_DATE(data_de_fim_previsto_do_ciclo, 'DD/MM/YYYY') AS data_fim_previsto_ciclo
FROM pnp_raw.eficiencia_2023
WHERE co_inst = '26439'
  AND ano = '2023';


-- CONFERÊNCIA DOS TOTAIS DAS TABELAS PREPARADAS
SELECT
    'Matrículas' AS arquivo,
    COUNT(*) AS quantidade
FROM pnp.matriculas_ifsp_2023

UNION ALL

SELECT
    'Eficiência acadêmica',
    COUNT(*)
FROM pnp.eficiencia_ifsp_2023;


-- DECISÃO DE TRATAMENTO | RECORTE ANUAL DE MATRÍCULAS
-- Excluir dos indicadores de 2023 os 460 registros sinalizados:
-- 458 com entrada posterior a 2023;
-- 2 com entrada em 2020 e situação datada de 2024.
-- Não há informação suficiente para corrigir as datas.
-- Os registros permanecem preservados na tabela.
-- Base resultante para o panorama anual: 77.098 matrículas.
-- Este critério não se aplica à tabela de Eficiência.



-- RECORTE DE MATRÍCULAS PARA A ANÁLISE DE 2023
CREATE VIEW pnp.matriculas_ifsp_2023_analise AS
SELECT *
FROM pnp.matriculas_ifsp_2023
WHERE pendencia_temporal = 'Sem pendência temporal identificada';


SELECT COUNT(*) AS total_matriculas_analise
FROM pnp.matriculas_ifsp_2023_analise;