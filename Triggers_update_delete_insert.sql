--логіка.створюємо тригери до таблиці order ,які будуть перевіряти к-сть товару на складі:
--тригер №1 буде перевіряти на складі к-сть товару і вставляти його в order,якщо к-сть товару в ордері більша ніж на складі ,то виб'є помилка ,якщо ні ,то
--відніме необхідну к-сть товару і добавить її в ордер
--тригер №2 ,якщо ми з ордеру видалимо замовлення то к-сть товару яке було при замовлені вернеться назад на склад,тобто якщо на складі залишок 5(к-сть товару) ,а в ордері 3(к-сть товару),і
--ми видалили замовлення то на складі повинно бути після видалення замовлення 8(к-сть товару)
--тригер №3, якщо к-сть товару в ордері змінюється на більше чи менше то на складі також віднімається чи додаєть к-сть товару

use ff_shop
go

--вставляємо тестові данні в таблиці
insert into dbo.[add_inf] ([password],[email],[type_of_user]) values		--вставляємо в dbo.[add_inf] дані
('admin','myemail@.com','user');				
go

select * from dbo.[add_inf]
go
		
insert into dbo.[users] ([surname],[name],[address],[id_inf]) values		--вставляємо в dbo.[users] дані
('Petrov','Petro','Lviv,kyivska 12/1',1);				
go

select * from dbo.[users]
go
		
insert into dbo.[products] ([name],[price],[description]) values		--вставляємо в dbo.[products] дані
('mivina',05.50,'very good for your health');				
go

select * from dbo.[products]
go

insert into dbo.[storage] ([address],[count],[id_p]) values				--вставляємо в dbo.[storage] дані і ставимо к-сть 10,щоб потім перевірити тригер
('Ukraine,Lviv,Stepanivni',10,1);
go

select * from dbo.[storage]
go

--створення тригера,який буде зменшувати к-сть продукту в таблиці storage ,коли ми добавляємо його в order
--тригер №1
create trigger trOrderInsert
on [order]
for insert
as

if @@ROWCOUNT = 0
	return

set nocount on		--це щоб не вибивала якась доп інфа про дані яка на даному етапі нас і так не нужна

update dbo.[storage] 
set [count] = s.[count] - i.[count]
from dbo.[storage] as s JOIN
(select id_s ,sum([count]) as [count] from inserted 
group by id_s) i 
ON s.id_s=i.id_s

--створення тригера,який буде збільшуваити к-сть продукту в таблиці storage ,коли ми видаляємо  його з order
--тригер №2
create trigger trOrderDelete
on [order]
for delete
as

if @@ROWCOUNT = 0
	return

set nocount on		

update dbo.[storage] 
set [count] = s.[count] + d.[count]
from dbo.[storage] as s JOIN
(select id_s ,sum([count]) as [count] from deleted
group by id_s) d
ON s.id_s=d.id_s

--створення тригера ,який буде міняти залишок товару в storage при змінені його к-сті в order
--тригер №3
create trigger trOrderUpdate
on [order]
for update
as

if @@ROWCOUNT = 0
	return

if not update ([count])
	RETURN
	 
set nocount on		

update dbo.[storage] 
set [count] = s.[count] - (i.[count] - d.[count])
from dbo.[storage] as s JOIN
(select id_s ,sum([count]) as [count] from deleted
group by id_s) d
ON s.id_s=d.id_s
JOIN
(select id_s ,sum([count]) as [count] from inserted 
group by id_s) i  
ON s.id_s=i.id_s

--перевірка роботи тригерів
--тригер №1
insert into dbo.[order] ([surname],[name],[product_name],[count],[price],[From],[To],[date_of_order],[id],[id_s]) values
('Petrov','Petro','mivina',11,5.50,'Ukraine','Poland',getdate(),1,1); 
go

select * from [order]
select * from dbo.[storage]
go

--тригер №2
delete from dbo.[order]
where surname='Petrov'

select * from [order]
select * from dbo.[storage]
go

--тригер №3
update dbo.[order]
set [count] = 3
where surname='Petrov'

select * from [order]
select * from dbo.[storage]
go

update dbo.[order]
set [count] = 6
where surname='Petrov'

select * from [order]
select * from dbo.[storage]
go