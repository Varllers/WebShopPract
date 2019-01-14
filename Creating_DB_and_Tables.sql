drop database  ff_shop					--ÿêùî ïåðåçàïóñêàòè êîä çíîâó òî âîíî âèäàëÿº ³ñíóþ÷ó áàçó,³ ñòâîðþº çàíàíîâî
go	

create database [ff_shop]
go

use  [ff_shop]
go

drop table  dbo.[add_inf]				--ÿêùî ïåðåçàïóñêàòè êîä çíîâó òî âîíî âèäàëÿº ³ñíóþ÷³ òàáëèö³,³ ñòâîðþº çàíàíîâî
drop table  dbo.[users]					--àëå âîíî òàáëèö³ ÿê³ ìàþòü çâ'ÿçí³ êëþ÷³(foreigm key) íå áóäå âèäàëÿòè áî òàê íå ìîæíà
drop table  dbo.[products]				--òîìó ÿêùî âèíèêíå ïîìèëêà ç âèäàëåííÿì òàáëèöü òî ïðîñòî çàþçàéòå ïåðø³ 2 ðÿäî÷êà êîäó ïðî 
drop table  dbo.[storage]				--äðîï ÁÄ
drop table  dbo.[order]					--

create table dbo.[add_inf](
[id_inf] int not null primary key identity(1,1),
[password] nvarchar(1000) not null,
[email] nvarchar(50) not null unique(email),
[type_of_user] nvarchar(50) not null default 'user'					--ïî äåôîëòó,íîâîãî êîðèñòóâà÷à áóäå ñòàâèòè ÿê çâè÷àéíîãî þçåðà
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
[count] int not null check ([count] >= 0),							--ê-ñòü ïðîäóêò³â íà ñêëàä³ íå ìîæå áóòè ì³íóñîâîþ (-1,-2,..) ,òîìó ñòî¿òü óìîâà ïåðåâ³ðêè 
[id_p] int not null foreign key references dbo.[products]([id_p])
)
go

create table dbo.[order](
[id_o] int not null primary key identity(1,1),
[surname] nvarchar(50) not null,
[name] nvarchar(50) not null,
[product_name] nvarchar(150) not null,
[count] int not null check ([count] >=1),						--êîëè þçåð ðîáèòü çàìîâäåííÿ òî â³äïîâ³äíî ê-ñòü òîâàðó íå ìîæå áóòè òàêîæ ì³íóñîâîþ àáî 0,òîìó òàêîæ ñòî¿òü óìîâà ïåðåâ³ðêè
[price] decimal(10,2) not null,
[total] as [count]*[price],
[From] nvarchar(150) not null,
[To] nvarchar(150) not null,
[date_of_order] datetime not null,
[id] int not null foreign key references dbo.[users]([id]),
[id_s] int not null foreign key references dbo.[storage]([id_s])
)
go

