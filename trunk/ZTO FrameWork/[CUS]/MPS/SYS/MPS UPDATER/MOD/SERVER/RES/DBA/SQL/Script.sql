SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `MPSUPDATER` ;
USE `MPSUPDATER`;

-- -----------------------------------------------------
-- Table `MPSUPDATER`.`USUARIOS`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `USUARIOS` (
  `BI_USUARIOS_ID` BIGINT NOT NULL AUTO_INCREMENT ,
  `VA_NOME` VARCHAR(45) NOT NULL COMMENT 'Descrição ou nome específico do usuário' ,
  `VA_LOGIN` VARCHAR(20) NOT NULL COMMENT 'Nome usado para login' ,
  `VA_SENHA` CHAR(32) NOT NULL COMMENT 'Senha (MD5)' ,
  `VA_EMAIL` VARCHAR(32) NULL ,
  PRIMARY KEY (`BI_USUARIOS_ID`) ,
  UNIQUE INDEX `VA_NOME_UC` (`VA_NOME` ASC) ,
  UNIQUE INDEX `VA_LOGIN_UC` (`VA_LOGIN` ASC) )
ENGINE = InnoDB
COMMENT = 'MNE=USU;Tabela de usuários que podem realizar atualização de dados. Estes usuários podem ser individuais ou não, dependendo da vontada do administrador. Vários usuários físicos ou computadores especificamente podem fazer uso de um mesmo usuário, já que objetivo do sistema é simplesmente a atualização dos programas';


-- -----------------------------------------------------
-- Table `MPSUPDATER`.`SISTEMAS`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `SISTEMAS` (
  `BI_SISTEMAS_ID` BIGINT NOT NULL AUTO_INCREMENT ,
  `VA_NOME` VARCHAR(30) NOT NULL COMMENT 'Nome do sistema' ,
  `VA_DIRETORIO` VARCHAR(128) NOT NULL COMMENT 'Diretório no qual os arquivos do sistema em questão são colocados' ,
  `VA_DESCRICAO` VARCHAR(64) NULL COMMENT 'Descrição do sistema em questão' ,
  `VA_CHAVEDEINSTALACAO` VARCHAR(128) NOT NULL COMMENT 'Chave de registro que identifica o sistema' ,
  PRIMARY KEY (`BI_SISTEMAS_ID`) ,
  UNIQUE INDEX `VA_NOME_UC` (`VA_NOME` ASC) ,
  UNIQUE INDEX `VA_DIRETORIO_UC` (`VA_DIRETORIO` ASC),
  UNIQUE INDEX `VA_CHAVEDEINSTALACAO_UC` (`VA_CHAVEDEINSTALACAO` ASC) )
ENGINE = InnoDB
COMMENT = 'MNE=SIS;Esta tabela mantém o registro dos sistemas que podem ter seus arquivos e/ou módulos atualizados. Basicamente esta tabela fará parte do subsistema de autenticação de usuários, já que um usuário poderá atualizar arquivos e/ou módulos de vários sistemas, caso o ele tenha esta permissão';


-- -----------------------------------------------------
-- Table `MPSUPDATER`.`USUARIOSDOSSISTEMAS`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `USUARIOSDOSSISTEMAS` (
  `BI_USUARIOS_ID` BIGINT NOT NULL ,
  `BI_SISTEMAS_ID` BIGINT NOT NULL ,
  PRIMARY KEY (`BI_USUARIOS_ID`, `BI_SISTEMAS_ID`) ,
  INDEX `UDS_USUARIOS_FK` (`BI_USUARIOS_ID` ASC) ,
  INDEX `UDS_SISTEMAS_FK` (`BI_SISTEMAS_ID` ASC) ,
  CONSTRAINT `UDS_USUARIOS_FK`
    FOREIGN KEY (`BI_USUARIOS_ID` )
    REFERENCES `USUARIOSDOSSISTEMAS` (`BI_USUARIOS_ID` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `UDS_SISTEMAS_FK`
    FOREIGN KEY (`BI_SISTEMAS_ID` )
    REFERENCES `SISTEMAS` (`BI_SISTEMAS_ID` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'MNE=UDS;Tabela de ligação que relaciona cada usuário com seus sistemas específicos';


-- -----------------------------------------------------
-- Table `MPSUPDATER`.`ARQUIVOS`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `ARQUIVOS` (
  `BI_ARQUIVOS_ID` BIGINT NOT NULL ,
  `VA_DIRETORIO` VARCHAR(128) NOT NULL ,
  `DT_DATAEHORADOARQUIVO` DATETIME NOT NULL ,
  PRIMARY KEY (`BI_ARQUIVOS_ID`) ,
  UNIQUE INDEX `VA_DIRETORIO_UC` (`VA_DIRETORIO` ASC) )
ENGINE = InnoDB
COMMENT = 'MNE=ARQ;Esta tabela será alimentada com os arquivos contidos nos diretórios configurados para cada sistema, na tabela SISTEMAS. Aqui será salvo o caminho completo para o arquivo, de forma que não haja necessidade de construçao de caminhos dentro da aplicação. ESTA TABELA VAI CONTER OS CAMINHOS DE TODOS OS ARQUIVOS DE TODOS OS SISTEMAS';



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
