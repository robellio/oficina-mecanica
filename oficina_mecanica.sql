CREATE DATABASE workshop;

use workshop;

-- Clientes
CREATE TABLE clients(
	idClient INT auto_increment PRIMARY KEY,
	fullName VARCHAR(45) NOT NULL,
	email VARCHAR(45),
	address VARCHAR(45) NOT NULL,
    number INT,
	neighborhood VARCHAR(45),
	contact CHAR(12) NOT NULL,
	state CHAR(2) NOT NULL,
	city VARCHAR(45) NOT NULL
);

ALTER TABLE clients auto_increment=1;

DESC clients;

-- Clientes CNPJ
CREATE TABLE client_pj(
	idClientPJ INT PRIMARY KEY,
    idPJclient INT,
    socialName VARCHAR(45),
    CNPJ CHAR(14),
    CONSTRAINT fk_pj_client FOREIGN KEY(idPJclient) REFERENCES clients(idClient)
);

desc client_pj;

-- Clientes CPF
CREATE TABLE client_pf(
	idClientPF INT PRIMARY KEY,
    idPFclient INT,
    CPF CHAR(11),
    CONSTRAINT unique_cpf_client unique(CPF),
    CONSTRAINT fk_pf_client FOREIGN KEY (idPFclient) REFERENCES clients(idClient)
);


desc client_pf;

-- Veículo
CREATE TABLE vehicles(
	idVehicle INT auto_increment PRIMARY KEY,
    idVehicleClient INT,
    type VARCHAR(45) NOT NULL,
    brand VARCHAR(45) NOT NULL,
    model VARCHAR(45) NOT NULL,
    color VARCHAR(20) NOT NULL,
    year CHAR(4) NOT NULL,
    CONSTRAINT fk_vehicle_client FOREIGN KEY (idVehicleClient) REFERENCES clients(idClient)
);

ALTER TABLE vehicles auto_increment=1;

desc vehicles;

-- Orçamento 
CREATE TABLE budget(
	idBudget INT auto_increment PRIMARY KEY,
    IdBudgetClient INT,
    serviceDescription VARCHAR(100) NOT NULL,
    budgetDate DATE NOT NULL,
    completionTime DATE NOT NULL,
    amount DECIMAL(10, 2),
    CONSTRAINT fk_buget_client FOREIGN KEY (IdBudgetClient) REFERENCES clients(idClient)
);

ALTER TABLE budget auto_increment=1;

-- Revisão 
CREATE TABLE revision(
	idRevision INT auto_increment PRIMARY KEY,
    idRevisionVehicle INT,
    reviewDescription TEXT NOT NULL,
    revisionDate Date NOT NULL,
    CONSTRAINT fk_revision_vehicle FOREIGN KEY (idRevisionVehicle) REFERENCES vehicles(idVehicle) 
);

ALTER TABLE revision auto_increment=1;

-- Fornecedor
CREATE TABLE supplier(
	idSupplier INT auto_increment PRIMARY KEY,
    socialName VARCHAR(45)  NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    contact CHAR(12) NOT NULL
);

ALTER TABLE supplier auto_increment=1;
-- Funcionários 
CREATE TABLE employees(
	idEmployee INT auto_increment PRIMARY KEY,
    fullName VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    CPF CHAR(11) NOT NULL,
    dateOfBirth DATE,
    address VARCHAR(45) NOT NULL,
    neighborhood VARCHAR(45),
    city VARCHAR(45) NOT NULL,
    state CHAR(2) NOT NULL,
    contact CHAR(12) NOT NULL,
    profession VARCHAR(45) NOT NULL,
    hiringDate Date NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    CONSTRAINT unique_cpf_employee unique(CPF)
);

ALTER TABLE employees auto_increment=1;

-- Boleto 
CREATE TABLE bills(
	idBills INT auto_increment PRIMARY KEY,
    amount DECIMAL(10, 2) NOT NULL,
    dueDate DATE NOT NULL,
    billNumber VARCHAR(45) NOT NULL
);

ALTER TABLE bills auto_increment=1;

-- Crédito 
CREATE TABLE creditcard(
	idCreditCard INT auto_increment PRIMARY KEY,
    creditCardNumber CHAR(20) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    installments INT NOT NULL,
    installmentAmount DECIMAL(10, 2) 
);

ALTER TABLE creditcard auto_increment=1;

-- Ordem de Serviço 
CREATE TABLE services(
	idService INT auto_increment PRIMARY KEY,
    idServiceVehicle INT,
    idServiceEmployee INT,
    start DATE NOT NULL,
    serviceCompletion DATE NOT NULL,
    serviceDescription TEXT NOT NULL,
    status ENUM('Agendado', 'Iniciado', 'Concluido') default 'Agendado' NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_service_vehicle FOREIGN KEY (idServiceVehicle) REFERENCES vehicles(idVehicle),
    CONSTRAINT  fk_service_employee FOREIGN KEY (idServiceEmployee) REFERENCES employees(idEmployee)
    );
    
    ALTER TABLE services auto_increment=1;
    
    -- Peças de Reposição
    CREATE TABLE spareParts(
		idsparePart INT auto_increment PRIMARY KEY, 
        idsparePartsEmployee INT,
        partName VARCHAR(45) NOT NULL,
        description TEXT,
        partValue DECIMAL(10, 2) NOT NULL,
        CONSTRAINT fk_spareParts_employee FOREIGN KEY (idsparePartsEmployee) REFERENCES employees(idEmployee)
    );
  
    ALTER TABLE spareParts auto_increment=1;
  
    -- Relação Ordem de Serviço/Peças de reposição
    CREATE TABLE serviceSpareParts(
		idServiceSparePart INT,
        idOrder INT,
        CONSTRAINT fk_relation_service FOREIGN KEY (idServiceSparePart) REFERENCES services(idService),
        CONSTRAINT fk_relation_spareParts FOREIGN KEY (idOrder) REFERENCES spareParts(idsparePart)
    );
    
  -- Estoque 
  CREATE TABLE stock(
	idStock INT auto_increment PRIMARY KEY,
    idStocksparePart INT,
    location VARCHAR(150) NOT NULL,
	quantity INT NOT NULL,
    CONSTRAINT fk_stock_sparePart FOREIGN KEY(idStocksparePart) REFERENCES spareParts(idsparePart)
  );
  
  ALTER TABLE stock auto_increment=1;
  
-- Relação Fornecedor e peças de reposição 
CREATE TABLE sparePartSupplier(
	idsparePartSupplier INT,
    idPartSupplier INT,
    CONSTRAINT fk_spare_supplier FOREIGN KEY (idsparePartSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_spare_service FOREIGN KEY (idPartSupplier) REFERENCES spareParts(idsparePart)
);

-- Pagamento
CREATE TABLE payment(
	idPayment INT auto_increment PRIMARY KEY,
    idBillPayment INT,
    idCardPayment INT,
    typeOfPayment VARCHAR(45) NOT NULL,
    paymentAmount DECIMAL(10, 2) NOT NULL,
    status ENUM('Aguardando pagamento', 'Pagamento Confirmado') default 'Aguardando pagamento',
    CONSTRAINT fk_bill_payment FOREIGN KEY (idBillPayment) REFERENCES bills(idBills),
    CONSTRAINT fk_credit_payment FOREIGN KEY (idCardPayment) REFERENCES creditcard(idCreditCard)
);

 ALTER TABLE payment auto_increment=1;

-- Relação (orçamento e pagamento)
CREATE TABLE budgetpayment(
	idBudgetPayment INT,
    idBudgetPay INT,
    CONSTRAINT fk_budget_payment FOREIGN KEY (idBudgetPayment) REFERENCES budget(idBudget),
    CONSTRAINT fk_pay_budget FOREIGN KEY (idBudgetPay) REFERENCES payment(idPayment)
);


-- Inserindo clientes
INSERT INTO clients(fullName, email, address, neighborhood, contact, state, city)
	VALUES('Paulo Silva', 'paulo@hotmail.com','Rua Floriano Peixoto 58,', 'Horizonte', 119999444451, 'SP', 'São Paulo'),
		  ('Paula Santana', 'paula@hotmail.com','Rua Floriano Peixoto 59,', 'Horizonte', 119999444471, 'SP', 'São Paulo'),
		  ('Fernado Salles', 'fernando@hotmail.com','Rua Floriano Peixoto 20,', 'Horizonte', 119999444452, 'SP', 'São Paulo'),
		  ('Felipe Ferreira', 'felipe@hotmail.com','Rua Floriano Peixoto 22,', 'Horizonte', 119999444453, 'SP', 'São Paulo'),
		  ('Ana Paula Mendes', 'ana@hotmail.com','Rua Floriano Peixoto 23,', 'Horizonte', 119999444454, 'SP', 'São Paulo'),
		  ('Roberto Duarte', 'roberto@hotmail.com','Rua Floriano Peixoto 40,', 'Horizonte', 119999444455, 'SP', 'São Paulo'),
		  ('Roberval Santos', 'roberval@hotmail.com','Rua Floriano Peixoto 44,', 'Horizonte', 119999444457, 'SP', 'São Paulo'),
		  ('Jamile Silva', 'jamile@hotmail.com','Rua Andrade Silva 44,', '2 de julho', 759999444458, 'BA', 'Abaíra'),
		  ('Eduardo Novais', 'edu@hotmail.com','Rua Andrade Silva 42,', '2 de julho', 759999444450, 'BA', 'Abaíra'),
		  ('Diego Novais', 'diego@hotmail.com','Rua Andrade Silva 42,', '2 de julho', 759999444481, 'BA', 'Abaíra');
          
          
  INSERT INTO client_pj( idClientPJ, idPJclient, socialName, CNPJ)
		VALUES(1, 1, 'Mecânica Silva', 15151515151515),
			  (5, 5, 'Mecânica Duarte', 15151515151512),
			  (7, 7, 'Mecânica lima', 15151515151514);
	
INSERT INTO client_pf(idClientPF, idPFclient,  CPF)
		VALUES(2, 2, 32323232321),
			  (3, 3, 32323232322),
			  (4, 4, 32323232323),
			  (6, 6, 32323232324),
			  (8, 8, 32323232325),
			  (9, 9, 32323232327),
			  (10, 10, 32323232328);
              
 INSERT INTO vehicles(idVehicleClient, type, brand, model, color, year)
		VALUES(1, 'Carro', 'BMW', 'B13548W', 'Azul', '2010'),
		      (5, 'Carro', 'TOYOTA', 'T47893A', 'Prata', '2020'),
		      (7, 'Carro', 'PALIO', 'P49893L', 'Vermelho', '2012'),
		      (2, 'Moto', 'HONDA', 'HN253ND', 'Prata', '2023'),
		      (3, 'Caminhão', 'Mercedes-Benz', 'MRB7414S', 'Azul', '2023'),
		      (4, 'Caminhão', 'Mercedes-Benz', 'MRB7415S', 'Prata', '2023'),
		      (9, 'Caminhão', 'Mercedes-Benz', 'MRB8415S', 'Prata', '2023'),
		      (6, 'Caminhão', 'Volvo', 'VLB8415S', 'Prata', '2023'),
			  (8, 'Moto', 'HONDA', 'HN35ND', 'Azul', '2023'),
			  (10, 'Moto', 'HONDA', 'HN3578ND', 'Prata', '2023');
              
INSERT INTO budget(IdBudgetClient, serviceDescription,  budgetDate, completionTime, amount)
		VALUES(1, 'Avaria no Motor', '2023-09-03', '2023-09-04', 30000),            
			  (2, 'Avaria no Motor', '2023-09-04', '2023-09-05', 3000),            
			  (3, 'Avaria no Motor', '2023-02-03', '2023-02-04', 3000),            
			  (4, 'Avaria no Motor', '2023-05-03', '2023-05-04', 5000),            
			  (5, 'Avaria no Motor', '2023-05-20', '2023-05-21', 50000),            
			  (6, 'Pequena problema na parte elétrica', '2022-02-09', '2022-02-10', 500),            
			  (7, 'Pequena problema na parte elétrica', '2022-02-11', '2022-02-12', 800),
			  (8, 'Pequena problema na parte elétrica', '2022-02-12', '2022-02-14', 1800),
			  (9, 'Pequena problema na parte elétrica', '2022-02-15', '2022-02-17', 2000),
              (10, 'Avaria no Motor', '2022-02-20', '2022-02-22', 150000);
			             
			              
  
SELECT * FROM clients; 
      
SELECT * FROM client_pj;
       
SELECT * FROM client_pf;
 
SELECT * FROM vehicles;

SELECT * FROM budget;
 
-- Buscar todos os campos da tabela cliente e incluir somente os que tem CNPJ
SELECT
	c.idClient,
    c.fullName,
    c.email,
    c.Address,
    c.Number,
    c.neighborhood,
	c.contact,
	c.state,
    c.city,
    pj.socialName,
	pj.CNPJ
FROM
		clients c
LEFT JOIN
     client_pj pj ON c.idClient = pj.idClientPJ
WHERE
	CNPJ IS NOT NULL;  
    
-- Buscar todos os campos da tabela cliente e incluir somente os que tem CPF
 SELECT
	c.idClient,
    c.fullName,
    c.email,
    c.Address,
    c.Number,
    c.neighborhood,
	c.contact,
	c.state,
    c.city,
	pf.CPF
FROM
		clients c
LEFT JOIN
     client_pf pf ON c.idClient = pf.idClientPF
WHERE
	CPF IS NOT NULL;  
 
 -- Buscando todos os campos dos clientes que tenham o sobrenome 'Novais'
SELECT * FROM clients WHERE fullName LIKE '%Novais';