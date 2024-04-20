CREATE DATABASE aluno;
USE aluno;


-- Tabela que armazenara a temperatura/umidade minima e maxima, que alertara o usuario caso haja mudanças fora das indicações
CREATE TABLE alerta (
  idAlerta INT PRIMARY KEY AUTO_INCREMENT,
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
  telFixo VARCHAR(10),
  representante VARCHAR(255)
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
		CHECK (email IN('%@%', '%.%')),
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
  fkEmpresa INT , 
	CONSTRAINT fk_Armazem_Empresa1
		FOREIGN KEY (fkEmpresa)
			REFERENCES empresa (idEmpresa),
  fkAlerta INT ,
	CONSTRAINT alerta
		FOREIGN KEY (fkAlerta)
			REFERENCES alerta(idAlerta)
);
   

-- Tabela de Dispositivos para sabermos a localização de cada um deles e entregar um melhor monitoramento, já que se por exemplo o alerta aparecer que algum local está com a temp ou 
-- umidade abaixo do recomendado, vai ser mais fácil localizar se você souber o local onde está ocorrendo isso
CREATE TABLE dispositivo_monitoramento (
  idDispositivo INT PRIMARY KEY,
  nome VARCHAR(255),
  localizacao VARCHAR(255) NULL,
  fkArmazem INT,
  CONSTRAINT dispositivo_armazem
    FOREIGN KEY (fkArmazem)
    REFERENCES armazem (idArmazem)
    );
    
-- Tabela pra receber os dados capturados do arduino
CREATE TABLE dados_monitoramento(
  idDados INt,  
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

INSERT INTO empresa VALUES
(1, '12345678901234', 'Coffee World', 'Alimentos', '01234567','122',null, '11990123456','39012345', 'Laura Seda'),
(2, '23456789012345', 'Bom grão', 'Agricultura', '12345678', '456',null, '11901234567','39234567' 'Alberto Godoy'),
(3, '34567890123456', 'Café do bem', 'Alimentos', '23456789','1098',null, '11912345678','39345678', 'Julio Araujo'),
(4, '45678901234567', 'Cafeina Velha', 'Agricultura', '34567890','897',null, '11934567890','39456789', 'Alexandre Brasil');



-- reparar o erro do insert acima e continuar os inserts


   
INSERT INTO armazem (nome, localizacao, capacidade_toneladas) VALUES
('Armazém A', 'Cidade Aristoteles', 1000),
('Armazém B', 'Cidade Bethoven', 1500);

INSERT INTO dispositivo_monitoramento (nome, localizacao, fkArmazem) VALUES
('Sensor 1', 'Armazém A', 1),
('Sensor 2', 'Armazém B', 2);


INSERT INTO funcionario (nome, email, cargo, senha, fkEmpresa, fkSupervisor) VALUES
('Patrick Bateman', 'Bateman@americano.com', 'Gerente', 'paulallen', 1, NULL),
('Amy Dunne', 'Amyexemplar@mamacitas.com', 'Supervisor', 'fenasmalucas123', 1, 1),
('Hannibal Lecter', 'hannibal@meat.com', 'Funcionário', 'grahamlove', 1, 2);

INSERT INTO dados_monitoramento (data_hora, temperatura, umidade, fkDispositivo) VALUES
('2024-04-07 08:00:00', 25.6, 60, 1),
('2024-04-07 09:00:00', 26.2, 58, 2);

INSERT INTO registro_sistema (data_hora, acao, fkFuncionario) VALUES
('2024-04-07 08:00:00', 'Login', 1),
('2024-04-07 09:00:00', 'Alteração nas contas de usuário', 2);


-- JOINS

-- mostra a empresa, o funcionario, seu cargo e supervisor
SELECT empresa.nome AS Empresa, funcionario.nome AS Funcionário, funcionario.cargo AS Cargo, supervisor.nome AS Supervisor
FROM empresa
JOIN funcionario ON empresa.idEmpresa = funcionario.fkEmpresa
JOIN funcionario supervisor ON funcionario.fkSupervisor = supervisor.idFuncionario;

-- mostra o funcionario e a sua respectiva empresa

SELECT funcionario.nome AS 'Funcionário', empresa.nome AS 'Empresa'
FROM funcionario
JOIN empresa ON funcionario.fkEmpresa = empresa.idEmpresa;

-- exibi os dados do monitoramento junto com os dados do armazem
SELECT dm.data_hora AS 'Data e Hora', dm.temperatura AS 'Temperatura', dm.umidade AS 'Umidade', d.nome AS 'Dispositivo', a.localizacao AS 'Localização'
FROM dados_monitoramento dm
JOIN dispositivo_monitoramento d ON dm.fkDispositivo = d.idDispositivo
JOIN armazem a ON d.fkArmazem = a.idArmazem;

