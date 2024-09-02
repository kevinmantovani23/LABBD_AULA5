CREATE DATABASE ex2
USE ex2

/*
2. Fazer uma Function que retorne
a) a partir da tabela Produtos (codigo, nome, valor unitário e qtd estoque), quantos produtos
estão com estoque abaixo de um valor de entrada
*/


CREATE TABLE produtos (
codigo				INT,
nome				VARCHAR(100),
valor_unitario		DECIMAL(5,2),
qtd_estoque			INT,
PRIMARY KEY(codigo)
)

CREATE FUNCTION fn_estoqueabaixo(@valor INT)
RETURNS INT
AS
BEGIN
	DECLARE @qtd INT
	SET @qtd = (SELECT COUNT(codigo) FROM produtos WHERE qtd_estoque < @valor)
	RETURN @qtd
END

/*b) Uma tabela com o código, o nome e a quantidade dos produtos que estão com o estoque
abaixo de um valor de entrada
*/
CREATE FUNCTION fn_tabelaestoqueabaixo(@valor INT)
RETURNS @tabela TABLE(
codigo		INT,
nome		VARCHAR(100),
quantidade	INT
)
AS
BEGIN
	INSERT INTO @tabela(codigo, nome, quantidade)
		SELECT codigo, nome, qtd_estoque FROM produtos 
			WHERE qtd_estoque < @valor
	RETURN
END

INSERT INTO produtos
VALUES(1, 'mamão', 4.50, 20)

INSERT INTO produtos
VALUES(2, 'feijão', 7, 30)

INSERT INTO produtos
VALUES(3, 'arroz', 8, 3)

INSERT INTO produtos
VALUES(4, 'macarrão', 10, 1)

INSERT INTO produtos
VALUES(5, 'chiclete', 12, 8)

SELECT dbo.fn_estoqueabaixo(20)

SELECT * 
FROM fn_tabelaestoqueabaixo(20)