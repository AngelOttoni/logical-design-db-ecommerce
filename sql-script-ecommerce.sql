-- Criação do DB para o cenário de E-commerce

SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
create database if not exists ecommerce;
use ecommerce;

-- 4criar tabela client
create table clients(
IdClient int auto_increment primary key,
Contact char(11) not null,
Address varchar(300) not null,
Client_Type enum('Legal Person', 'Natural Person') default 'Legal Person'
);

alter table clients auto_increment=1;

-- 1criar tabela Natural Person
create table naturalPerson(
IdNaturalPerson int auto_increment primary key,
IdClientNP int,
CPF char(11) not null,
constraint unique_cpf_client unique (CPF),
Fname varchar(15) not null,
Mname varchar(20),
Lname varchar(20) not null,
Bdate date not null,
LN_Type enum('Client', 'Seller') default 'Client',
constraint fk_np_client foreign key (IdClientNP) references clients(IdClient)
);

-- 2Criar tabela Legal Person
create table legalPerson(
IdLegalPerson int auto_increment primary key,
CNPJ char(14) not null,
Corporate_Name varchar(45),
Trade_Name varchar(45),
LP_Type enum('Client', 'Supplier', 'Seller') not null,
constraint unique_cnpj_lp unique (CNPJ)
);

-- 3criar tabela product
create table product(
IdProduct int auto_increment primary key,
Category varchar(45) not null,
Description_Product varchar(500) not null,
Value_Product float not null,
Evaluation float
);

-- 5criar tabela boleto
create table boleto(
IdBoleto int auto_increment primary key,
Value_Boleto float not null
);

-- 6criar tabela PIX
create table pix(
IdPix int auto_increment primary key,
Type_Key enum('CPF', 'CNPJ', 'Phone', 'E-mail', 'Random Key') default 'CPF'
);

-- 7criar tabela cred card
create table credCard(
IdCredCard int auto_increment primary key,
Card_Number char(16) not null,
Expiration_Date date not null,
Name_on_Card varchar(45) not null,
Security_Code int(3) not null,
Installments_Plan int default 1
);

-- 8para ser continuado no desafio: termine de implementar a tabela e crie a conexão com as tabelas necessárias
-- além disso, reflita essa modificação no diagrama de esquema relacional
-- criar constraints relacionadas ao pagamento
create table payment(
IdPayment int auto_increment primary key,
IdPayClient int,
IdPayBoleto int,
IdPayPix int,
IdPayCredCard int,
Payment_Type enum('Boleto', 'Cred Card', 'PIX'), -- esqueci de colocar nn
constraint fk_payment_client foreign key (IdPayClient) references clients(IdClient),
constraint fk_payment_boleto foreign key (IdPayBoleto) references boleto(IdBoleto),
constraint fk_payment_pix foreign key (IdPayPix) references pix(IdPix),
constraint fk_payment_credcard foreign key (IdPayCredCard) references credCard(IdCredCard)
);
desc payment;

show variables like 'sql_mode';

-- 9criar tabela de envio/frete
create table shipping(
IdShipping int auto_increment primary key,
Status_Shipping enum('Order delivered to carrier','On carriage','Delivered') not null,
Shipping_Date date not null,
Tracking_Code varchar(30) not null
);
desc shipping;

-- 10criar tabela order
create table orders(
IdOrder int auto_increment primary key,
IdOrderClient int,
IdOrderShipping int,
Status_Order enum('Order made', 'Payment accept', 'Preparing to ship', 'On carriage', 
					'Order delivered', 'Canceled') not null,
Order_Description varchar(300) not null,
Shipping_Value float default 10,
Payment_Cash boolean default false, 
constraint fk_orders_client foreign key (IdOrderClient) references clients(IdClient),
constraint fk_orders_shipping foreign key (IdOrderShipping) references shipping(IdShipping)
);
desc orders;

-- drop table productsStorage;
-- 11criar tabela de estoque
create table productStorage(
IdStorage int auto_increment primary key,
Category_Name varchar(45) not null,
Quantity_by_Category float default 100,
Storage_Location varchar(300) not null,
Total_Amount_Products float default 1000
);
desc productStorage;


-- 12criar tabela do fornecedor
create table supplier(
IdSupplier int auto_increment primary key,
IdSupplierLP int,
CNPJ char(14) not null,
Corporate_Name varchar(45) not null,
Contact_Supplier char(11) not null,
constraint unique_cnpj_supplier unique (CNPJ),
constraint pk_supplier_lp foreign key (IdSupplierLP) references legalPerson(IdLegalPerson)
);
desc supplier;

-- 13criar tabela do vendedor
create table seller(
IdSeller int auto_increment primary key,
IdSellerLP int,
IdSellerNP int,
Corporate_Name varchar(45) not null,
Trade_Name varchar(45) not null,
Address_Seller varchar(300) not null,
Contact_Seller char(11) not null,
Seller_Type enum('Legal Person', 'Natural Person') default 'Natural Person',
constraint pk_seller_lp foreign key (IdSellerLP) references legalPerson(IdLegalPerson),
constraint pk_seller_np foreign key (IdSellerNP) references naturalPerson(IdNaturalPerson)
);
desc seller;

-- 14criar tabela Products_by_Seller
create table productSeller(
IdPSeller int, 
IdPproduct int,
Prod_Quantity int default 1,
primary key (IdPSeller, IdPproduct),
constraint fk_proSeller_seller foreign key (IdPSeller) references seller(IdSeller),
constraint fk_proSeller_product foreign key (IdPproduct) references product(IdProduct)
);
desc productSeller;

-- drop table productOrder;
-- 15criar tabela Relação_Procuct/Order
create table productOrder(
IdPOProduct int,
IdPOrder int,
PO_Quantity int default 1,
PO_Status enum('Available', 'Unavailable') default 'Available',
primary key (IdPOProduct, IdPOrder),
constraint fk_prodOrder_product foreign key (IdPOProduct) references product(IdProduct),
constraint fk_prodOrder_orders foreign key (IdPOrder) references orders(IdOrder)
);
desc productOrder;

-- 16Criar tabela Product_has_Storage
create table storageLocation(
IdLProduct int,
IdLStorage int,
Location varchar(300),
primary key (IdLProduct, IdLStorage),
constraint fk_storageLocation_product foreign key (IdLProduct) references product(IdProduct),
constraint fk_storageLocation_storage foreign key (IdLStorage) references productStorage(IdStorage)
);
desc storageLocation;

-- drop table disponibilizaProduct;
-- 17Criar tabela Disponibiliza_Product
create table disponibilizaProduct(
IdDisProdSupplier int,
IdDisProd int,
Quantity int not null,
primary key(IdDisProdSupplier, IdDisProd),
constraint fk_disProduct_supplier foreign key (IdDisProdSupplier) references supplier(IdSupplier),
constraint fk_disProduct_product foreign key (IdDisProd) references product(IdProduct)
);
desc disponibilizaProduct;

show tables;

show databases;
use information_schema;
show tables;
-- desc TABLE_CONSTRAINTS;
desc referential_constraints;
select * from referential_constraints;
select * from referential_constraints where constraint_schema = 'ecommerce';
