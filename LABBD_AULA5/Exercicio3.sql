/*3. 

Criar, uma UDF, que baseada nas tabelas abaixo, retorne
Nome do Cliente, Nome do Produto, Quantidade e Valor Total, Data de hoje
Tabelas iniciais:
Cliente (Codigo, nome)
Produto (Codigo, nome, valor)
*/

CREATE DATABASE ex3
GO
USE ex3

CREATE TABLE cliente(
codigo		INT,
nome		VARCHAR(100),

PRIMARY KEY(codigo)
)

CREATE TABLE produto(
codigo		INT,
nome		VARCHAR(100),
valor		DECIMAL(7,2),

PRIMARY KEY (codigo)
)

CREATE FUNCTION fn_realizarcompra(@codProd INT, @codCliente INT, @quantidade INT)
RETURNS @tabela TABLE(
nome_cliente		VARCHAR(100),
nome_produto		VARCHAR(100),
quantidade			INT,
valor_total			DECIMAL(7,2),
data				DATE
)
AS
BEGIN
		INSERT INTO @tabela(nome_cliente)
			SELECT nome FROM cliente WHERE codigo = @codCliente

		UPDATE @tabela SET nome_produto = (SELECT nome FROM produto WHERE codigo = @codProd)
		UPDATE @tabela SET quantidade = @quantidade
		UPDATE @tabela SET valor_total = @quantidade * (SELECT valor FROM produto WHERE codigo = @codProd)
		UPDATE @tabela SET data = GETDATE()

		RETURN
END

INSERT INTO cliente 
VALUES(1, 'Jonas')

INSERT INTO cliente 
VALUES(2, 'João')

INSERT INTO cliente 
VALUES(3, 'Fadel')

INSERT INTO produto
VALUES(1, 'cabo usb', 10)

INSERT INTO produto
VALUES(2, 'RTX 3080',3000)

INSERT INTO produto
VALUES(3, 'SSD 500GB', 500)

SELECT * from fn_realizarcompra(2, 3, 5)