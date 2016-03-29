CREATE OR REPLACE PROCEDURE PROC_CARGA_DIM_TEMPO(DATA_INICIAL IN DATE, DATA_FINAL IN DATE) AS
/* ------------------------------------------------------------------------------------------------
AUTOR: FRANKLIN NASCIMENTO                 DATA: 19/05/2011
------------------------------------------------------------------------------------------------
DESCRIÇÃO: PROCEDURE QUE CARREGA TABELA DE DIMENSÃO TEMPO PARA FINS DE DATA WHAREHOUSE
           INSERE DATA INFORMADA NO PARÂMETRO INICIAL ATÉ DATA FINAL INCLUSIVE
           CASO EXISTA REGISTROS A DATA_INICIAL É DESCONCIDERADA E UTILIZA-SE A ULTIMA DATA REGISTRADA.
           CASO SEJA INSERIDA UMA DATA_FINAL MENOR QUE A DATA_INICIAL NENHUM REGISTRO É INSERIDO,
           ASSIM COMO A DATA FINAL SEJA MENOR QUE A ULTIMA DATA REGISTRADA
           DÚVIDAS, SUGESTÕES: franklinv@gmail.com
------------------------------------------------------------------------------------------------
*/
ULTIMA_DATA   DATE;
DATA_CORRENTE DATE;
MES_CORRENTE  NUMBER;
DIA_CORRENTE  NUMBER;
QTD_DIAS      NUMBER;

BEGIN
  
  SELECT MAX(DT_DATA) INTO ULTIMA_DATA FROM TD_TEMPO; /* RETORNA A ULTIMA DATA EXISTENTE NA TABELA */
  
  IF ULTIMA_DATA IS NULL THEN
    DATA_CORRENTE := DATA_INICIAL; /*PARA PRIMEIRA CARGA INSERE-SE VALORES PADRÕES PARA DATAS INVÁLIDAS E DATAS EM BRANCO (NÃO ENCONTRADA)*/
    INSERT INTO TD_TEMPO VALUES(-2,'02/01/0001',-2,-2,'DATA INVÁLIDA',-2,'DI',2,'DI',-2,'DI',-2,'DI',-2,'DI',-2,'DI',-2,-2,'DI',-2,'DI',-2);
    INSERT INTO TD_TEMPO VALUES(-1,'01/01/0001',-1,-1,'NÃO INFORMADO',-1,'NI',1,'NI',-1,'NI',-1,'NI',-1,'NI',-1,'NI',-1,-1,'NI',-1,'NI',-1);
  ELSE
    DATA_CORRENTE := ULTIMA_DATA + 1;
  END IF; /* CASO ULTIMA_DATA SEJA NULA UTILIZA-SE A DATA_INICIAL SE NÃO USA-SE PROXIMA DATA */

  QTD_DIAS := DATA_FINAL - DATA_CORRENTE; --QUANTIDADE DE DIAS A SER INSERIDO

  FOR REG IN 0..QTD_DIAS
  LOOP
    MES_CORRENTE := TO_NUMBER(TO_CHAR(DATA_CORRENTE,'MM'));
    DIA_CORRENTE := TO_NUMBER(TO_CHAR(DATA_CORRENTE,'DD'));

    INSERT INTO TD_TEMPO (CO_SEQ_TEMPO,
                          DT_DATA,
                          CO_DIA,
                          CO_DIA_SEMANA,
                          DS_DIA_SEMANA,
                          CO_MES,
                          DS_MES,
                          CO_MES_ANO,
                          DS_MES_ANO,
                          CO_BIMESTRE,
                          DS_BIMESTRE,
                          CO_TRIMESTRE,
                          DS_TRIMESTRE,
                          CO_ESTACAO,
                          DS_ESTACAO,
                          CO_SEMESTRE,
                          DS_SEMESTRE,
                          CO_ANO,
                          CO_MES_ANT,
                          DS_MES_ANT,
                          CO_MES_ANO_ANT,
                          DS_MES_ANO_ANT,
                          CO_ANO_ANT)
                   VALUES(TO_NUMBER(TO_CHAR(DATA_CORRENTE,'YYYYMMDD')), -- CO_SEQ_TEMPO
                          DATA_CORRENTE,                                -- DT_DATA
                          DIA_CORRENTE,                                 -- CO_DIA
                          TO_NUMBER(TO_CHAR(DATA_CORRENTE,'D')),        -- CO_DIA_SEMANA
                          TO_CHAR(DATA_CORRENTE,'DAY'),                 -- DS_DIA_SEMANA
                          MES_CORRENTE,                                 -- CO_MES
                          TO_CHAR(DATA_CORRENTE,'MONTH'),               -- DS_MES
                          TO_NUMBER(TO_CHAR(DATA_CORRENTE,'YYYYMM')),   -- CO_MES_ANO
                          TO_CHAR(DATA_CORRENTE,'MON YYYY'),            -- DS_MES_ANO
                          CASE
                            WHEN MES_CORRENTE IN (1,2)   THEN 1
                            WHEN MES_CORRENTE IN (3,4)   THEN 2
                            WHEN MES_CORRENTE IN (5,6)   THEN 3
                            WHEN MES_CORRENTE IN (7,8)   THEN 4
                            WHEN MES_CORRENTE IN (9,10)  THEN 5
                            WHEN MES_CORRENTE IN (11,12) THEN 6
                          END ,                                         -- CO_BIMESTRE
                          CASE

                            WHEN MES_CORRENTE IN (1,2)   THEN '1º BIMESTRE'
                            WHEN MES_CORRENTE IN (3,4)   THEN '2º BIMESTRE'
                            WHEN MES_CORRENTE IN (5,6)   THEN '3º BIMESTRE'
                            WHEN MES_CORRENTE IN (7,8)   THEN '4º BIMESTRE'
                            WHEN MES_CORRENTE IN (9,10)  THEN '5º BIMESTRE'
                            WHEN MES_CORRENTE IN (11,12) THEN '6º BIMESTRE'
                          END,                                          -- DS_BIMESTRE
                          CASE
                            WHEN MES_CORRENTE IN (1,2,3)    THEN 1
                            WHEN MES_CORRENTE IN (4,5,6)    THEN 2
                            WHEN MES_CORRENTE IN (7,8,9)    THEN 3
                            WHEN MES_CORRENTE IN (10,11,12) THEN 4
                          END,                                          -- CO_TRIMESTRE
                          CASE
                            WHEN MES_CORRENTE IN (1,2,3)    THEN '1º TRIMESTRE'
                            WHEN MES_CORRENTE IN (4,5,6)    THEN '2º TRIMESTRE'
                            WHEN MES_CORRENTE IN (7,8,9)    THEN '3º TRIMESTRE'
                            WHEN MES_CORRENTE IN (10,11,12) THEN '4º TRIMESTRE'
                          END,                                          -- DS_TRIMESTRE
                          CASE
                            WHEN (MES_CORRENTE = 12 AND DIA_CORRENTE >= 21) OR MES_CORRENTE IN (1,2)   OR (MES_CORRENTE =  3 AND DIA_CORRENTE < 21) THEN 1
                            WHEN (MES_CORRENTE =  3 AND DIA_CORRENTE >= 21) OR MES_CORRENTE IN (4,5)   OR (MES_CORRENTE =  6 AND DIA_CORRENTE < 21) THEN 2
                            WHEN (MES_CORRENTE =  6 AND DIA_CORRENTE >= 21) OR MES_CORRENTE IN (7,8)   OR (MES_CORRENTE =  9 AND DIA_CORRENTE < 21) THEN 3
                            WHEN (MES_CORRENTE =  9 AND DIA_CORRENTE >= 21) OR MES_CORRENTE IN (10,11) OR (MES_CORRENTE = 12 AND DIA_CORRENTE < 21) THEN 4
                          END,                                          -- CO_ESTACAO --(ESTAÇÕES DO ANO)
                          CASE
                            WHEN (MES_CORRENTE = 12 AND DIA_CORRENTE >= 21) OR MES_CORRENTE IN (1,2)   OR (MES_CORRENTE =  3 AND DIA_CORRENTE < 21) THEN 'VERÃO'
                            WHEN (MES_CORRENTE =  3 AND DIA_CORRENTE >= 21) OR MES_CORRENTE IN (4,5)   OR (MES_CORRENTE =  6 AND DIA_CORRENTE < 21) THEN 'OUTONO'
                            WHEN (MES_CORRENTE =  6 AND DIA_CORRENTE >= 21) OR MES_CORRENTE IN (7,8)   OR (MES_CORRENTE =  9 AND DIA_CORRENTE < 21) THEN 'INVERNO'
                            WHEN (MES_CORRENTE =  9 AND DIA_CORRENTE >= 21) OR MES_CORRENTE IN (10,11) OR (MES_CORRENTE = 12 AND DIA_CORRENTE < 21) THEN 'PRIMAVERA'
                          END,                                          -- DS_ESTACAO
                          CASE
                            WHEN MES_CORRENTE IN (1,2,3,4,5,6)    THEN 1
                            WHEN MES_CORRENTE IN (7,8,9,10,11,12) THEN 2
                          END,                                          --CO_SEMESTRE
                          CASE
                            WHEN MES_CORRENTE IN (1,2,3,4,5,6)    THEN '1º SEMESTRE'
                            WHEN MES_CORRENTE IN (7,8,9,10,11,12) THEN '2º SEMESTRE'
                          END,                                                        --DS_SEMESTRE
                          TO_NUMBER(TO_CHAR(DATA_CORRENTE,'YYYY')),                  --CO_ANO
                          TO_NUMBER(TO_CHAR(ADD_MONTHS(DATA_CORRENTE,-1),'YYYYMM')), --CO_MES_ANT
                          TO_CHAR(ADD_MONTHS(DATA_CORRENTE,-1),'MON YYYY'),          --DS_MES_ANT
                          TO_NUMBER(TO_CHAR(ADD_MONTHS(DATA_CORRENTE,-12),'YYYYMM')),--CO_MES_ANO_ANT,
                          TO_CHAR(ADD_MONTHS(DATA_CORRENTE,-12),'MON YYYY'),         --DS_MES_ANO_ANT
                          TO_NUMBER(TO_CHAR(ADD_MONTHS(DATA_CORRENTE,-12),'YYYY'))   --CO_ANO_ANT
                          );

    DATA_CORRENTE := DATA_CORRENTE + 1;
  END LOOP;
  COMMIT;
END;

/* --execução
 begin
   -- Call the procedure
 proc_carga_tempo(data_inicial => '01/01/1900', data_final => '31/12/2112');
 end;
*/
