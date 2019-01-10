drop database  ff_shop					--���� ������������� ��� ����� �� ���� ������� ������� ����,� ������� ��������
go	

create database [ff_shop]
go

use  [ff_shop]
go

drop table  dbo.[add_inf]				--���� ������������� ��� ����� �� ���� ������� ������� �������,� ������� ��������
drop table  dbo.[users]					--��� ���� ������� �� ����� ��'��� �����(foreigm key) �� ���� �������� �� ��� �� �����
drop table  dbo.[products]				--���� ���� ������� ������� � ���������� ������� �� ������ �������� ����� 2 ������� ���� ��� 
drop table  dbo.[storage]				--���� ��
drop table  dbo.[order]					--

create table dbo.[add_inf](
[id_inf] int not null primary key identity(1,1),
[password] nvarchar(1000) not null,
[email] nvarchar(50) not null unique(email),
[type_of_user] nvarchar(50) not null default 'user'					--�� �������,������ ����������� ���� ������� �� ���������� �����
)
go

create table dbo.[users](
[id] int not null primary key identity(1,1),
[surname] nvarchar(50) not null,
[name] nvarchar(50) not null,
[address] nvarchar(150) not null,
[id_inf] int not null foreign key references dbo.[add_inf]([id_inf])
)
go

create table dbo.[products](
[id_p] int not null primary key identity(1,1),
[name] nvarchar(100) not null,
[price] decimal(10,2) not null,
[description] nvarchar(1000) not null
)
go

create table dbo.[storage](
[id_s] int not null primary key identity(1,1),
[address] nvarchar(150) not null,
[count] int not null check ([count] >= 0),							--�-��� �������� �� ����� �� ���� ���� �������� (-1,-2,..) ,���� ����� ����� �������� 
[id_p] int not null foreign key references dbo.[products]([id_p])
)
go

create table dbo.[order](
[id_o] int not null primary key identity(1,1),
[surname] nvarchar(50) not null,
[name] nvarchar(50) not null,
[product_name] nvarchar(150) not null,
[count] int not null check ([count] >=1),						--���� ���� ������ ���������� �� �������� �-��� ������ �� ���� ���� ����� �������� ��� 0,���� ����� ����� ����� ��������
[price] decimal(10,2) not null,
[From] nvarchar(150) not null,
[To] nvarchar(150) not null,
[date_of_order] datetime not null,
[id] int not null foreign key references dbo.[users]([id]),
[id_s] int not null foreign key references dbo.[storage]([id_s])
)
go

