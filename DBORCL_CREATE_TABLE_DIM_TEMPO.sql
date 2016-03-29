/* ------------------------------------------------------------------------------------------------
AUTOR: FRANKLIN V. NASCIMENTO               DATA: 19/05/2011           DESCRIÇÃO: CRIAÇÃO
---------------------------------------------------------------------------------------------------       
DESCRIÇÃO: PACOTE COTENDO SCRIPTS SQL PARA CONSTRUÇÃO DE TABELA DIMENSÃO TEMPO NO ORACLE,
           PROCEDURE PARA POPULAR A TABELA 
           VIDE DESCRIÇÃO DA PROCEDURE PARA MAIS DETALHES 
           DÚVIDAS, SUGESTÕES: franklinv@gmail.com 
------------------------------------------------------------------------------------------------           
*/  

-- MODELO DE CRIAÇÃO DE TABELA
CREATE TABLE TD_TEMPO ( 
  CO_SEQ_TEMPO NUMBER not null, 
  DT_DATA DATE, 
  CO_DIA NUMBER, 
  CO_DIA_SEMANA NUMBER, 
  DS_DIA_SEMANA VARCHAR2(15), 
  CO_MES NUMBER, 
  DS_MES VARCHAR2(10), 
  CO_MES_ANO NUMBER, 
  DS_MES_ANO VARCHAR2(8), 
  CO_BIMESTRE NUMBER, 
  DS_BIMESTRE VARCHAR2(11), 
  CO_TRIMESTRE NUMBER, 
  DS_TRIMESTRE VARCHAR2(12), 
  CO_ESTACAO NUMBER, 
  DS_ESTACAO VARCHAR2(9), 
  CO_SEMESTRE NUMBER, 
  DS_SEMESTRE VARCHAR2(11), 
  CO_ANO NUMBER, 
  CO_MES_ANT NUMBER, 
  DS_MES_ANT VARCHAR2(8), 
  CO_MES_ANO_ANT NUMBER, 
  DS_MES_ANO_ANT VARCHAR2(8), 
  CO_ANO_ANT NUMBER 
);  
 
--Create/Recreate primary, unique and foreign key constraints 
alter table TD_TEMPO add constraint PK_TD_TEMPO primary key (CO_SEQ_TEMPO) using index 
