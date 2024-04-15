USE aluno;



-- UMA TABELA PARA AS EMPRESAS QUE CONTRATAREM OS NOSSOS SERVIÇOS
CREATE TABLE empresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    cnpj VARCHAR(20) UNIQUE NOT NULL,
    nome VARCHAR(255) NOT NULL,
    categoria VARCHAR(255),
    endereco VARCHAR(255),
    contato VARCHAR(255),
    representante VARCHAR(255)
);


-- Tabela para os funcionarios fazerem login no site para acessar os gráficos
CREATE TABLE funcionario (
    idFuncionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    cargo VARCHAR(255) NOT NULL,
    senha VARCHAR(255),
    fkEmpresa INT,
      CONSTRAINT fkEmpresaFuncionario FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa),
    fkSupervisor INT,
	 CONSTRAINT fkSupervisorFuncionario FOREIGN KEY (fkSupervisor) REFERENCES funcionario(idFuncionario)
);

-- Tabela para manter registro da localização de cada armazem 
CREATE TABLE armazem (
    idArmazem INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    localizacao VARCHAR(255),
    capacidade_toneladas INT
);


-- Tabela de Dispositivos para sabermos a localização de cada um deles e entregar um melhor monitoramento, já que se por exemplo o alerta aparecer que algum local está com a temp ou 
-- umidade abaixo do recomendado, vai ser mais fácil localizar se você souber o local onde está ocorrendo isso
CREATE TABLE dispositivo_monitoramento (
    idDispositivo INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    localizacao VARCHAR(255),
    fkArmazem INT,
		CONSTRAINT fkDispositivoArmazem FOREIGN KEY (fkArmazem) REFERENCES armazem(idArmazem)
);

-- Tabela pra receber os dados capturados do arduino
CREATE TABLE dados_monitoramento (
    idDados INT PRIMARY KEY AUTO_INCREMENT,
	data_hora DATETIME,
    temperatura DECIMAL(5,2),
    umidade DECIMAL(5,2),
    fkDispositivo INT,
    CONSTRAINT fkDadosDispositivo FOREIGN KEY (fkDispositivo) REFERENCES dispositivo_monitoramento(idDispositivo)
);

-- Tabela para monitorar quem entrou no sistema, a data e hora e o que a pessoa fez
CREATE TABLE registro_sistema (
    idRegistro INT PRIMARY KEY AUTO_INCREMENT,
    data_hora DATETIME,
    acao VARCHAR(255),
    fkFuncionario INT,
    CONSTRAINT fkRegistroFuncionario FOREIGN KEY (fkFuncionario) REFERENCES funcionario(idFuncionario)
);

-- só um check para os funcionarios
ALTER TABLE funcionario
ADD CONSTRAINT Check_Cargo CHECK (cargo IN ('Gerente', 'Supervisor', 'Funcionário'));


INSERT INTO empresa (cnpj, nome, categoria, endereco, contato, representante) VALUES
('123456789', 'Empresa Mamacitas no poder do café', 'Alimentos', 'Rua Mimimi, 123', 'mamacitas@empresa.com', 'Laura Seda'),
('987654321', 'Empresa CafeinaVeia', 'Agricultura', 'Avenida Atléti Comi Nero, 456', 'cafenaveiao@empresa.com', 'Ice de pego');

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
SELECT empresa.nome AS 'Empresa', funcionario.nome AS 'Funcionário', funcionario.cargo AS 'Cargo', supervisor.nome AS 'Supervisor'
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

