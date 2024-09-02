CREATE DATABASE udf
USE udf
/*Criar uma database, criar as tabelas abaixo, definindo o tipo de dados e a rela��o PK/FK e popular
com alguma massa de dados de teste (Suficiente para testar UDFs)
Funcion�rio (C�digo, Nome, Sal�rio)
Dependendente (C�digo_Dep, C�digo_Funcion�rio, Nome_Dependente, Sal�rio_Dependente)
*/

CREATE TABLE funcionario(
codigo		INT,
nome		VARCHAR(100),
salario		DECIMAL(7,2),
PRIMARY KEY (codigo)
)

CREATE TABLE dependente(
codigo_dep			INT,
codigo_funcionario	INT,
nome_dependente		VARCHAR(100),
salario_dependente	DECIMAL(7,2),
FOREIGN KEY (codigo_funcionario) REFERENCES funcionario(codigo),
PRIMARY KEY (codigo_dep, codigo_funcionario)
)

INSERT INTO funcionario
VALUES(1, 'Jo�o', 1000)

INSERT INTO funcionario
VALUES(2, 'Maria', 11340)

INSERT INTO funcionario
VALUES(3, 'Josafa', 5000)

INSERT INTO funcionario
VALUES(4, 'Hebron', 7000)

INSERT INTO dependente
VALUES(1, 1, 'Larissa', 5000)


INSERT INTO dependente
VALUES(2, 1, 'Joana', 500)


INSERT INTO dependente
VALUES(3, 2, 'Paula', 6000)

/*
a) C�digo no Github ou Pastebin de uma Function que Retorne uma tabela:
(Nome_Funcion�rio, Nome_Dependente, Sal�rio_Funcion�rio, Sal�rio_Dependente)
*/
CREATE FUNCTION fn_dependentes ()
RETURNS @tabela TABLE(
nome_funcionario		VARCHAR(100),
nome_dependente			VARCHAR(100),
salario_funcionario		DECIMAL(7,2),
salario_dependente		DECIMAL(7,2)
)
AS
BEGIN
		INSERT INTO @tabela(nome_funcionario, nome_dependente, salario_funcionario, salario_dependente)
				SELECT func.nome as nome_funcionario, dep.nome_dependente, func.salario as salario_funcionario,
				dep.salario_dependente
				FROM funcionario func, dependente dep
				WHERE func.codigo = dep.codigo_funcionario
		RETURN
END

SELECT *
FROM fn_dependentes()

/*b) C�digo no Github ou Pastebin de uma Scalar Function que Retorne a soma dos Sal�rios dos
dependentes, mais a do funcion�rio.
*/ 

CREATE FUNCTION fn_somasalarios(@cod INT)
RETURNS DECIMAL(7,2)
AS
BEGIN
		DECLARE @soma DECIMAL(7,2)
		SET @soma = (SELECT salario FROM funcionario WHERE codigo = @cod)
		SET @soma = @soma + (SELECT SUM(dep.salario_dependente) FROM dependente dep, funcionario func
							 WHERE dep.codigo_funcionario = func.codigo AND func.codigo = @cod)

		RETURN @soma
END

SELECT dbo.fn_somasalarios(1) AS soma

SELECT *
FROM fn_dependentes()