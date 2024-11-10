-- Create database
create database db_bank
on  primary (name='db_bank', filename='C:\mssql\data\db_bank.mdf',     size=50Mb, maxsize=150Mb, filegrowth=25Mb)
log on (name='db_bank_log',  filename='C:\mssql\data\db_bank_log.ldf', size=30Mb, maxsize=100Mb, filegrowth=25Mb); 


-- Retrieve stored symmetric keys
select * from sys.symmetric_keys

-- Create symmetric key (master database)
create master key encryption by password = '23987hxJKL95QYV4369#ghf0%lekjg5k3fd117r$$#1946kcj$n44ncjhdlj'



-- Create a certificate
create certificate secure_credit_cards with subject = 'customer credit card number';


-- Create symmetric key (current database)
create symmetric key lscck_01
	with alrithm = aes_256
    encryption by certificate secure_credit_cards;


use db_bank


-- Create example table
create table usuario(
	idusuario int not null,
	nombre varchar(30) not null,
	correo varchar(30) not null,
	usuario varchar(30) not null,
	clave varchar(30) not null,
    rol int not null,
	estatus int not null,
)

alter table usuario add constraint fk_roles foreign key(rol) references rol(cusID);


-- Create example table
create table roles(
	idrol int not null,
	cusName varchar(30) not null
)

alter table roles add constraint pk_roles primary key(idrol);

-- Create example table
create table customer(
	cusID int not null,
	cusName varchar(30) not null
)

alter table customer add constraint pk_customer primary key(cusID);


-- Create example table
create table card_list(
	creditCard varchar(16) not null,
	encryptedCC varbinary(256) not null,
	customer int not null 
)

alter table card_list add constraint pk_card_list primary key(creditCard);

alter table card_list add constraint fk_customer foreign key(customer) references customer(cusID);


-- EncryptByKey(par_1, par_2, par_3, par_4)
--   par_1: key_GUID to be used to encrypt
--   par_2: value to be stored
--   par_3: add authenticator, only if value = 1
--   par_4: authenticator value

-- Open the symmetric key with which to encrypt the data.
open symmetric key lscck_01 decryption by certificate secure_credit_cards;

-- Insert data
insert into customer
values(1,'Merlina Addams');

insert into customer
values(2,'Morticia Addams');


insert into customer
values(12,'Homero Addams');


insert into card_list
values('6041710012564010',EncryptByKey(Key_GUID('lscck_01'),'6041710012564010',0),1);

insert into card_list
values('6081610022564010',EncryptByKey(Key_GUID('lscck_01'),'6041710012564010',1, HashBytes('SHA1',convert(varbinary,506))),12);


-- Close the key
close symmetric key lscck_01;


-- Retrieve data 
select * from customer

select * from card_list

-- Open the symmetric key with which to decrypt data.
open symmetric key lscck_01 decryption by certificate secure_credit_cards;

select  c.cusName, cl.creditCard, cl.encryptedCC, cl.customer,
       CONVERT(varchar, DecryptByKey(cl.encryptedCC)) decryptedCC
from customer c inner join card_list cl
on c.cusID = cl.customer

select c.cusName, cl.creditCard, cl.encryptedCC, cl.encryptedCC,
       CONVERT(varchar, DecryptByKey(cl.encryptedCC,1,HashBytes('SHA1',convert(varbinary,506)))) decryptedCC, cl.customer
from customer c inner join card_list cl
on c.cusID = cl.customer

-- Close the key
close symmetric key lscck_01;
