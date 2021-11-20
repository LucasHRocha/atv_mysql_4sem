CREATE DATABASE DBCLINICA;

USE DBCLINICA;

/* 1  - Crie o modelo físico do banco DBCLINICA no MYSQL usando comandos DDL. 
        Atribua a cada um dos campos das tabelas acima tipos e tamanhos 
		convenientes.
		Imponha valores default e regras (check) quando necessários
*/
CREATE TABLE TabConvenio(
	codConvenio INTEGER AUTO_INCREMENT PRIMARY KEY,
	nomeConv VARCHAR(20),
	foneConv NUMERIC,
	homePage VARCHAR(50),
	valorConsulta FLOAT
);

CREATE TABLE TabPaciente(
	codPac INTEGER AUTO_INCREMENT PRIMARY KEY,
	nomePac VARCHAR(30) NOT NULL,
	sobrenomePac VARCHAR(30) NOT NULL,
	sexoPac CHAR(1) CHECK (SexoPac = 'F' OR SexoPac = 'M'),
	fonePac NUMERIC, 
	dataNascPac DATE,
	codConvenio INTEGER,
	enderecoPac VARCHAR(30) NOT NULL,
	cidadePac VARCHAR(30) NOT NULL,
	FOREIGN KEY(codConvenio) REFERENCES TabConvenio(codConvenio)
);

CREATE TABLE TabEspecialidade(
	codEspecialidade INTEGER AUTO_INCREMENT PRIMARY KEY,
	especialidade VARCHAR(30) NOT NULL
);

CREATE TABLE TabMedicos(
	codMedic INTEGER AUTO_INCREMENT PRIMARY KEY,
	nomeMedic VARCHAR(30) NOT NULL,
	foneMedic NUMERIC,
	celMedic NUMERIC,
	codEspecialidade INTEGER, 
	crm INTEGER, 
	FOREIGN KEY(codEspecialidade) REFERENCES TabEspecialidade(codEspecialidade)
);

CREATE TABLE TabConsultas(
	numConsulta INTEGER AUTO_INCREMENT PRIMARY KEY,
	dataCons DATE,
	horaCons TIME,
	codPac INTEGER,
	codMedic INTEGER,
	queixaPaciente VARCHAR(50),
	prescricoes VARCHAR(50) NOT NULL,
	FOREIGN KEY(codPac) REFERENCES TabPaciente(codPac),
	FOREIGN KEY(codMedic) REFERENCES TabMedicos(codMedic)
);

/* 2  - Insira pelo menos 3 convênios e 3 especialidades médicas. 
*/
INSERT INTO TabConvenio VALUES
(null,"Amil",12345678,"www.amil.com.br",150),
(null,"Bradesco",98745678,"www.bradesco.com.br",250),
(null,"Vitoria",19345458,"www.vitoria.com.br",500);

INSERT INTO TabEspecialidade VALUES
(null,"Otorrinolaringologia"),
(null,"Psiquiatria"),
(null,"Neurologia");


/* 3  - Insira pelo menos 6 pacientes e 4 médicos.
*/
INSERT INTO TabPaciente VALUES
(null,'Manuel','Araujo','M',99995555,'1999-07-08',1,'Rua um de dois,212','Sao Paulo'),
(null,'Maria','Oliveira','F',95684752,'2000-06-25',2,'Rua tres de quatro,252','Sao Caetano'),
(null,'Matheus','Andrade','M',963652525,'2001-12-22',1,'Rua cinco de marco,555','Santo Andre'),
(null,'Jessica','Araujo','F',925631254,'2000-10-16',3,'Rua seis de abril,166','Sao Bernardo do Campo'),
(null,'Andre','Araujo','M',986547231,'1999-11-25',2,'Rua sete de outubro,123','Santo Andre'),
(null,'Emilia','Araujo','F',942369542,'2001-03-14',1,'Rua oito de dezembro,111','Sao Paulo');

INSERT INTO TabMedicos VALUES
(NULL,'Marcela',46235696,956863214,2,150075),
(NULL,'Carlos',43659874,976369545,2,185002),
(NULL,'Joana',43679452,926254251,2,165211),
(NULL,'Leonardo',41775964,995413564,2,625460);

/* 4  - Insira pelo menos 10 consultas médicas.
*/
INSERT INTO TabConsultas VALUES
(null,'2021-11-15','12:00',1,1,'Dor de Garganta','Anti-Inflamatorio'),
(null,'2021-11-15','13:00',2,1,'Gripe','Analgesico'),
(null,'2021-11-15','14:00',3,1,'Dor de Barriga','Antidiarreico'),
(null,'2021-11-15','15:00',4,1,'Dor nas costas','Anti-Inflamatorio e Fisioterapia'),
(null,'2021-11-15','16:00',1,1,'Alergia','Pomada'),
(null,'2021-11-15','17:00',6,1,'Dor de cabeca','Paracetamol'),
(null,'2021-11-15','18:00',2,1,'Tosse','Xarope'),
(null,'2021-11-15','19:00',3,1,'Febre','Antitermico'),
(null,'2021-11-15','20:00',4,1,'Nausea','Antiemetico'),
(null,'2021-11-15','21:00',6,1,'Luxacao no pe','Repouso por 3 a 5 dias');

/* 5  - Mostre os dados das 5 tabelas (TabPaciente, TabConvenio,TabMedicos, TabEspecalidades 
	    e TabConsultas)
*/
SELECT * FROM TabConvenio;
SELECT * FROM TabEspecialidade;
SELECT * FROM TabPaciente;
SELECT * FROM TabMedicos;
SELECT * FROM TabConsultas;

/* 6  - Crie uma view para pacientes que mostre o nome concatenado com o sobrenome além 
		das demais informações do paciente, incluindo o nome do seu convênio.
*/
CREATE VIEW view_pacon AS
	SELECT 
		p.codPac, CONCAT(p.nomePac, p.sobrenomePac) AS nomeCompleto,
		p.sexoPac as sexo,
		p.fonePac as fone,
		p.datanascPac as datanasc,
		c.nomeConv as convenio,
		p.enderecoPac as endereco,
		p.cidadePac
	FROM TabPaciente p 
	INNER JOIN TabConvenio c
	WHERE p.codConvenio = c.codConvenio;

SELECT * FROM view_pacon;

/* 7  - Crie uma view que relacione os dados das consultas com médicos e pacientes e queixas
*/
CREATE VIEW view_copame AS 
	SELECT 
		c.numConsulta, 
		c.dataCons as data, 
		c.horaCons as hora, 
		c.queixaPaciente as queixaPaciente, 
		c.prescricoes as prescricoes, 
		p.nomepac AS paciente,
		m.nomeMedic AS medico
	FROM TabConsultas c 
	INNER JOIN TabPaciente p ON c.codPac = p.codPac 
	INNER JOIN TabMedicos m ON c.codMedic = m.codMedic ORDER BY numConsulta;

SELECT * from view_copame;

--8)a)A quantidade de pacientes por convênio
SELECT COUNT(*) AS contador, c.nomeConv from tabPaciente p INNER JOIN tabConvenio c ON p.codConvenio = c.codConvenio group by p.codConvenio;
--b)Mostre os dados dos médicos com suas especialidades
SELECT m.*,e.especialidade FROM tabMedicos m INNER JOIN tabEspecialidade e ON m.codEspecialidade = e.codEspecialidade;
--c)Quais as consultas realizadas por um determinado paciente
SELECT c.*,p.nomePac FROM tabConsultas c INNER JOIN tabPaciente p on c.codPac = p.codPac WHERE p.codPac=1;
--d)A relação de consultas por data (nome do paciente, nome do médico, especialidade médica)
SELECT p.nomePac, e.especialidade,m.nomeMedic FROM tabConsultas c INNER JOIN tabPaciente p ON p.codPac = c.codPac INNER JOIN tabMedicos m on m.codMedic = c.codMedic INNER JOIN tabEspecialidade e on e.codEspecialidade = m.codEspecialidade;
--e)Quais os dados das consultas realizadas por cada um dos médicos
SELECT m.nomeMedic,c.numConsulta,c.dataCons,c.horaCons,c.codPac,c.queixaPaciente,c.prescricoes FROM tabConsultas c INNER JOIN tabMedicos m on m.codMedic=c.codMedic;
--f)Qual o nome do convênio que tem o menor valor de consulta
SELECT nomeConv FROM tabConvenio WHERE valorConsulta = (SELECT MIN(valorConsulta) FROM tabConvenio);
--g)Quanto seria o valor das consultas se os convênios sofressem um reajuste de 10%
SELECT codConvenio,nomeConv,foneConv,homePage,valorConsulta*1.1 AS valorConsultaReajuste FROM TabConvenio;
--h)Mostre o nome completo e a idade dos pacientes
SELECT CONCAT(nomePac,sobrenomePac)as nomeCompletoPaciente,TIMESTAMPDIFF(YEAR,dataNascPac,curdate()) as idade FROM tabPaciente;
--i)Crie um procedimento que busque os dados de um médico pelo seu CRM.
CREATE PROCEDURE Buscacrm(in c INTEGER) 
	SELECT * from tabMedicos 
	WHERE crm = c;
--j)Crie um procedimento que busque o endereço de um paciente a partir do seu nome
CREATE PROCEDURE BuscaPacEnd(in e VARCHAR(30))
	SELECT nomePac FROM tabPaciente 
	WHERE enderecoPac=e;