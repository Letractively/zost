TYPE=VIEW
query=select `acw`.`situacoes`.`TI_SITUACOES_ID` AS `TI_SITUACOES_ID` from `acw`.`situacoes` where (`acw`.`situacoes`.`VA_DESCRICAO` in (\'EM ANDAMENTO NIVEL A\',\'EM ANDAMENTO NIVEL B\',\'EM ANDAMENTO NIVEL M\'))
md5=af904df02598df1131a166019b7aa117
updatable=1
algorithm=0
definer_user=ODBC
definer_host=localhost
suid=1
with_check_option=0
timestamp=2010-03-02 23:38:01
create-version=1
source=SELECT SITUACOES.TI_SITUACOES_ID AS TI_SITUACOES_ID FROM SITUACOES WHERE (SITUACOES.VA_DESCRICAO IN (\'EM ANDAMENTO NIVEL A\',\'EM ANDAMENTO NIVEL B\',\'EM ANDAMENTO NIVEL M\'))
client_cs_name=utf8
connection_cl_name=utf8_general_ci
view_body_utf8=select `acw`.`situacoes`.`TI_SITUACOES_ID` AS `TI_SITUACOES_ID` from `acw`.`situacoes` where (`acw`.`situacoes`.`VA_DESCRICAO` in (\'EM ANDAMENTO NIVEL A\',\'EM ANDAMENTO NIVEL B\',\'EM ANDAMENTO NIVEL M\'))