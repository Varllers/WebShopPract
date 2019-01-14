--�����.��������� ������� �� ������� order ,�� ������ ��������� �-��� ������ �� �����:
--������ �1 ���� ��������� �� ����� �-��� ������ � ��������� ���� � order,���� �-��� ������ � ����� ����� �� �� ����� ,�� ���'� ������� ,���� � ,��
--����� ��������� �-��� ������ � �������� �� � �����
--������ �2 ,���� �� � ������ �������� ���������� �� �-��� ������ ��� ���� ��� �������� ��������� ����� �� �����,����� ���� �� ����� ������� 5(�-��� ������) ,� � ����� 3(�-��� ������),�
--�� �������� ���������� �� �� ����� ������� ���� ���� ��������� ���������� 8(�-��� ������)
--������ �3, ���� �-��� ������ � ����� ��������� �� ����� �� ����� �� �� ����� ����� ��������� �� ������ �-��� ������

use ff_shop
go

--���������� ������ ���� � �������
insert into dbo.[add_inf] ([password],[email],[type_of_user]) values		--���������� � dbo.[add_inf] ���
('admin','myemail@.com','user');				
go

select * from dbo.[add_inf]
go
		
insert into dbo.[users] ([surname],[name],[address],[id_inf]) values		--���������� � dbo.[users] ���
('Petrov','Petro','Lviv,kyivska 12/1',1);				
go

select * from dbo.[users]
go
		
insert into dbo.[products] ([name],[price],[description]) values		--���������� � dbo.[products] ���
('mivina',05.50,'very good for your health');				
go

select * from dbo.[products]
go

insert into dbo.[storage] ([address],[count],[id_p]) values				--���������� � dbo.[storage] ��� � ������� �-��� 10,��� ���� ��������� ������
('Ukraine,Lviv,Stepanivni',10,1);
go

select * from dbo.[storage]
go

--��������� �������,���� ���� ���������� �-��� �������� � ������� storage ,���� �� ���������� ���� � order
--������ �1
create trigger trOrderInsert
on [order]
for insert
as

if @@ROWCOUNT = 0
	return

set nocount on		--�� ��� �� �������� ����� ��� ���� ��� ��� ��� �� ������ ���� ��� � ��� �� �����

update dbo.[storage] 
set [count] = s.[count] - i.[count]
from dbo.[storage] as s JOIN
(select id_s ,sum([count]) as [count] from inserted 
group by id_s) i 
ON s.id_s=i.id_s

--��������� �������,���� ���� ����������� �-��� �������� � ������� storage ,���� �� ���������  ���� � order
--������ �2
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

--��������� ������� ,���� ���� ����� ������� ������ � storage ��� ����� ���� �-�� � order
--������ �3
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

--�������� ������ �������
--������ �1
insert into dbo.[order] ([surname],[name],[product_name],[count],[price],[From],[To],[date_of_order],[id],[id_s]) values
('Petrov','Petro','mivina',11,5.50,'Ukraine','Poland',getdate(),1,1); 
go

select * from [order]
select * from dbo.[storage]
go

--������ �2
delete from dbo.[order]
where surname='Petrov'

select * from [order]
select * from dbo.[storage]
go

--������ �3
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