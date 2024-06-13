CREATE DATABASE aluno;
USE aluno;


-- Tabela que armazenara a temperatura/umidade minima e maxima, que alertara o usuario caso haja mudanças fora das indicações
CREATE TABLE parametro (
  idParametro INT PRIMARY KEY AUTO_INCREMENT,
  umidade_max DECIMAL(5,2),
  temperatura_max DECIMAL(5,2),
  umidade_min DECIMAL(5,2),
  temperatura_min DECIMAL(5,2)
  );
  
-- UMA TABELA PARA AS EMPRESAS QUE CONTRATAREM OS NOSSOS SERVIÇOS
CREATE TABLE empresa (
  idEmpresa INT PRIMARY KEY,
  cnpj CHAR(14) NOT NULL,
  nome VARCHAR(255) NOT NULL,
  categoria VARCHAR(70),
  cep CHAR(8) NOT NULl,
  numero VARCHAR(45),
  complemento VARCHAR(60),
  telCelular VARCHAR(11),
  telFixo VARCHAR(10)
  );
  


-- Tabela para os funcionarios fazerem login no site para acessar os gráficos
CREATE TABLE funcionario (
idFuncionario INT,
fkEmpresa INT,
	CONSTRAINT pkFuncionario_empresa
		PRIMARY KEY (idFuncionario, fkEmpresa),
nome VARCHAR(255) NOT NULL,
email VARCHAR(255) UNIQUE,
	CONSTRAINT chkEmail
		CHECK (email like('%@%')),
cargo VARCHAR(255) NOT NULL,
senha VARCHAR(255) ,
fkSupervisor INT ,
  CONSTRAINT supervisor_funcionario
		FOREIGN KEY (fkSupervisor)
			REFERENCES funcionario (idFuncionario),
CONSTRAINT fk_funcionario_empresa
		FOREIGN KEY (fkEmpresa)
			REFERENCES empresa(idEmpresa)
);

-- Tabela para manter registro da localização de cada armazem 
CREATE TABLE armazem(
  idArmazem INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(255) NOT NULL,
  localizacao VARCHAR(255),
  capacidade_toneladas INT,
  fkEmpresa INT, 
	CONSTRAINT fk_Armazem_Empresa1
		FOREIGN KEY (fkEmpresa)
			REFERENCES empresa (idEmpresa),
  fkParametro INT ,
	CONSTRAINT parametro_armazem
		FOREIGN KEY (fkParametro)
			REFERENCES parametro(idParametro)
);
   

-- Tabela de Dispositivos para sabermos a localização de cada um deles e entregar um melhor monitoramento, já que se por exemplo o alerta aparecer que algum local está com a temp ou 
-- umidade abaixo do recomendado, vai ser mais fácil localizar se você souber o local onde está ocorrendo isso
CREATE TABLE dispositivo_monitoramento (
  idDispositivo INT PRIMARY KEY,
  nome VARCHAR(255),
  fkArmazem INT,
  CONSTRAINT dispositivo_armazem
    FOREIGN KEY (fkArmazem)
    REFERENCES armazem (idArmazem)
    );

-- Tabela pra receber os dados capturados do arduino
CREATE TABLE dados_monitoramento(
  idDados INT AUTO_INCREMENT,  
  fkDispositivo INT,
	PRIMARY KEY (idDados, fkDispositivo),
  data_horaCaptura DATETIME,
  temperatura DECIMAL(5,2),
  umidade DECIMAL(5,2),
	CONSTRAINT dados_dispositivo
		FOREIGN KEY (fkDispositivo)
			REFERENCES dispositivo_monitoramento (idDispositivo)
    );
-- Inserts das respectivas entidades


INSERT INTO parametro (umidade_max, temperatura_max, umidade_min, temperatura_min) VALUES
(12.00,25.00,11.00,10.00);

INSERT INTO empresa VALUES
(1, '12345678901234', 'Coffee World', 'Alimentos', '01234567','122',null, '11990123456','39012345'),
(2, '23456789012345', 'Bom grão', 'Agricultura', '12345678', '456',null, '11901234567','39234567'),
(3, '34567890123456', 'Café do bem', 'Alimentos', '23456789','1098',null, '11912345678','39345678'),
(4, '45678901234567', 'Cafeina Velha', 'Agricultura', '34567890','897',null, '11934567890','39456789');

INSERT INTO funcionario ( idFuncionario, fkEmpresa, nome, email, cargo, senha,fkSupervisor) VALUES
(1,1,'Patrick', 'patrickbateman@gmail.com', 'Gerente', '1234', NULL),
(2,1,'Amy', 'amydune@gmail.com', 'Supervisor', '2345', 1),
(3,1,'Fabio', 'fabiojunior@gmail.com', 'Funcionário', '3456', 2),


(4,2,'Carlos', 'carlosalves@gmail.com', 'Gerente', '1234', NULL),
(5,2,'Fernando', 'fernandobrandao@gmail.com', 'Supervisor', '2345', 4),
(6,2,'Julia', 'juliacristianotti@gmail.com', 'Funcionário', '3456', 5);

INSERT INTO armazem (nome, localizacao, capacidade_toneladas, fkEmpresa, fkAlerta) VALUES
('Armazém A', 'Cidade Aristoteles', 1000,1,1),
('Armazém B', 'Cidade Bethoven', 1500,1,1),
('Armazém C','Cidade Chopin',1000,2,1),
('Armazém D','Cidade Nietzsche',1500,3,1),
('Armazém E', 'Cidade Mozart', 1500,4,1);

INSERT INTO dispositivo_monitoramento VALUES
(1,'Sensor 1', 1),
(2, 'Sensor 2', 2),
(3,'Sensor 3', 3),
(4,'Sensor 4',4),
(5,'Sensor 5', 5);

INSERT INTO dados_monitoramento VALUES
(1, 1, '2024-05-07 08:00:00', 18.3, 11.25),
(2,2, '2024-05-07 08:00:00', 14.00, 14.00),
(3, 3, '2024-05-07 08:00:00', 14.00, 12.00),
(4, 4, '2024-05-07 08:00:00', 20.00, 11.10),
(5, 5, '2024-05-07 08:00:00', 21.32, 11.34);





-- JOINS

-- mostra a empresa, o funcionario, seu cargo e supervisor
SELECT empresa.nome AS Empresa, funcionario.nome AS Funcionário, funcionario.cargo AS Cargo, IFNULL(supervisor.nome, 'sem supervisor') AS Supervisor
FROM empresa
JOIN funcionario ON empresa.idEmpresa = funcionario.fkEmpresa
LEFT JOIN funcionario supervisor ON funcionario.fkSupervisor = supervisor.idFuncionario;

-- ponto de partida para finalizar o script

-- mostra o funcionario e a sua respectiva empresa

SELECT funcionario.nome AS 'Funcionário', empresa.nome AS 'Empresa'
FROM funcionario
JOIN empresa ON funcionario.fkEmpresa = empresa.idEmpresa;

-- exibe os dados do monitoramento junto com os dados do armazem
SELECT dm.data_horaCaptura AS 'Data e Hora', dm.temperatura AS 'Temperatura', dm.umidade AS 'Umidade', dispositivo.nome AS 'Dispositivo' , armazem.localizacao AS 'Localização'
	FROM dados_monitoramento AS dm
	JOIN dispositivo_monitoramento as dispositivo 
		ON dm.fkDispositivo = dispositivo.idDispositivo
	JOIN armazem  
		 ON dispositivo.fkArmazem = armazem.idArmazem;

