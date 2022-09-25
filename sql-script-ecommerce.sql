-- Criação do DB para o cenário de E-commerce
create database if not exists ecommerce;
use ecommerce;

-- 1criar tabela Natural Person
create table natural_person(
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
create table legal_person(
IdLegalPerson int auto_increment primary key,
CNPJ char(14) not null,
Corporate_Name varchar(45),
Trade_Name varchar(45),
LP_Type enum('Client', 'Supplier', 'Seller') default 'Client, Supplier or Seller',
constraint unique_cnpj_lp unique (CNPJ)
);

-- 3criar tabela product
create table product(
IdProduct int auto_increment primary key,
Category varchar(45) not null,
Description_Product varchar(100) not null,
Value_Product float not null,
Evaluation float
);

-- 4criar tabela client
create table clients(
IdClient int auto_increment primary key,
Contact char(11) not null,
Address varchar(300) not null,
Client_Type enum('Legal Person', 'Natural Person') default 'Legal Person'
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
create table cred_card(
IdCredCard int auto_increment primary key,
Card_Number char(16) not null,
Expiration_Date date not null,
Name_on_Card varchar(45) not null,
Security_Code int(3) not null,
Installments_Plan INT default 1
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
Payment_Type enum('Boleto', 'Cred Card', 'PIX'),
constraint fk_payment_client foreign key (IdPayClient) references clients(IdClient),
constraint fk_payment_boleto foreign key (IdPayBoleto) references boleto(IdBoleto),
constraint fk_payment_pix foreign key (IdPayPix) references pix(IdPix),
constraint fk_payment_credcard foreign key (IdPayCredCard) references cred_card(IdCredCard)
);

-- 9criar tabela de envio/frete
create table shipping(
IdShipping int auto_increment primary key,
Status_Shipping enum('Order delivered to carrier', 'On carriage', 'Delivered') default 'Order dispatched',
Shipping_Date date not null,
Tracking_Code varchar(30) not null
);

-- 10criar tabela order
create table orders(
IdOrder int auto_increment primary key,
IdOrderClient int,
IdOrderShipping int,
Status_Order enum('Order made', 'Payment accept', 'Preparing to ship', 'On carriage', 
					'Order delivered', 'Canceled') default 'Processing',
Order_Description varchar(300) not null,
Shipping_Value float default 10,
PaymentCash bool default false,
-- IdPayment 
constraint fk_orders_client foreign key (IdOrderClient) references clients(IdClient),
constraint fk_orders_shipping foreign key (IdOrderShipping) references shipping(IdShipping)
);

-- 11criar tabela de estoque
create table products_storage(
IdStorage int auto_increment primary key,
Category_Name varchar(45),
Quantity_by_Category float default 1,
Storage_Location varchar(300),
Total_Amount_Products float default 0
);

-- 12criar tabela do fornecedor
create table supplier(
IdSupplier int auto_increment primary key,
CNPJ char(14) not null,
Corporate_Name varchar(45),
Contact_Supplier char(11) not null,
constraint unique_cnpj_supplier unique (CNPJ),
constraint pk_supplier_lp foreign key (IdSupplierLP) references legal_person(IdLegalPerson)
);

-- 13criar tabela do vendedor
create table seller(
IdSeller int auto_increment primary key,
IdSellerLP int,
IdSellerNP int,
Corporate_Name varchar(45),
Trade_Name varchar(45),
Address_Seller varchar(100),
Contact_Seller char(11) not null,
Seller_Type enum('Legal Person', 'Natural Person') default 'Natural Person',
constraint pk_seller_lp foreign key (IdSellerLP) references legal_person(IdLegalPerson),
constraint pk_seller_np foreign key (IdSellerNP) references natural_person(IdNaturalPerson)
);

-- 14criar tabela Products_by_Seller
create table productSeller(
IdPSeller int,
IdPproduct int,
Prod_Quantity int default 1,
primary key (IdPSeller, IdPproduct),
constraint fk_product_seller foreign key (IdPSeller) references seller(IdSeller),
constraint fk_product_product foreign key (IdPproduct) references product(IdProduct)
);

-- 15criar tabela Relação_Procuct/Order
create table productOrder(
IdPOProduct int,
IdPOrder int,
PO_Quantity int default 1,
PO_Status enum('Available', 'Unavailable') default 'Available',
primary key (IdPOProduct, IdPOrder),
constraint fk_product_seller foreign key (IdPOProduct) references product(IdProduct),
constraint fk_product_product foreign key (IdPOrder) references orders(IdOrder)
);

-- 16Criar tabela Product_has_Storage
create table storageLocation(
IdLProduct int,
IdLStorage int,
Location varchar(200),
primary key (IdLProduct, IdLStorage),
constraint fk_product_seller foreign key (IdLProduct) references product(IdProduct),
constraint fk_product_product foreign key (IdLStorage) references products_storage(IdStorage)
);

-- 17Criar tabela Disponibiliza_Product
create table disponibiliza_product(
IdDisProdSupplier int,
IdDisProd int,
primary key(IdDisProdSupplier, IdDisProd),
constraint fk_dis_product_supplier foreign key (IdDisProdSupplier) references supplier(IdSupplier),
constraint fk_dis_product_product foreign key (IdDisProd) references product(IdProduct)
);