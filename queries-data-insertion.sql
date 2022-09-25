-- Inserting Data and Queries

use ecommerce;
show tables;

insert into clients (Contact, Address, Client_Type)
values('53994471386', 'Rua Robes Pinto Silva, 424, Industrial I, Bagé, RS', 'Natural Person');


insert into clients (Contact, Address, Client_Type) 
values('11991675659', 'Rua Biritiba Mirim, 698, Paisagem Renoir, Cotia, SP', 'Legal Person');

select * from clients;