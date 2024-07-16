use Slesarev_MyBASE;

--task 01
set nocount on
if(exists (select * from sys.objects where OBJECT_ID = object_id('DBO.TABLE_T1')))
	drop table DBO.TABLE_T1

declare @c int, @flag char = 'c'
set IMPLICIT_TRANSACTIONS ON
create table DBO.TABLE_T1(id int, val int)
	insert DBO.TABLE_T1 values (1,12),(2,44),(3,53)
	set @c = (select count(*) from DBO.TABLE_T1)
	print '����� � ������� TABLE_T1: ' + cast(@c as varchar(5))
	if @flag='c' commit
	else rollback
set IMPLICIT_TRANSACTIONS OFF

if exists (select * from sys.objects where OBJECT_ID = object_id('DBO.TABLE_T1'))
	print '������� TABLE_T1 ����'
else print '������� TABLE_T1 ����'


--task 02
begin try
	begin tran
		update dbo.TABLE_T1 set val *= 2 where id = 2
		insert dbo.TABLE_T1 values (4,11)
		insert dbo.TABLE_T1 values ('jhhj',71)
		delete dbo.TABLE_T1 where id = 1
	commit tran
	print '���������� ���������'
end try
begin catch
	print '������: ' + case
	when error_number() = 2627 and patindex('%TABLE_T1%', error_message()) > 0
	then '������ ��������� ������ � �������'
	else '����������� ������: ' + cast(error_number() as varchar(5)) + error_message()
	end
	if @@TRANCOUNT > 0 rollback tran
end catch


--task 03
use UNIVER;
declare @point varchar(32)
begin try
	begin tran
		update PROGRESS set NOTE += 1 where SUBJECT = '����' and NOTE > 6 and NOTE < 8
		insert PROGRESS values ('��',1018,'2013-05-06',5)
		set @point = 'p1' save tran @point
		insert PROGRESS values ('����',1017,'2013-12-01',7)
		set @point = 'p2' save tran @point
		delete PROGRESS where SUBJECT = '���'
	commit tran
	print '���������� ��������� �������'
end try
begin catch
	print '������: '+case 
		when error_number() = 2627 and patindex('%TABLE_T1%',error_message()) > 0
		then '������ ��������� ������ � �������'
		else '����������� ������: '+cast(error_number() as varchar(5))+error_message()
		end
	if @@TRANCOUNT > 0
	begin
		print '����������� �����: '+@point
		rollback tran @point
		commit tran
	end
end catch


--task 04
--A--
set transaction isolation level read uncommitted  
begin transaction
---t1---
select @@SPID, 'insert SUBJECT' 'result',* from PROGRESS where PROGRESS.[SUBJECT] = '��'
commit
---t2---
--B--
begin transaction
select @@SPID
--delete from SUBJECT where SUBJECT = '��'
insert SUBJECT values ('��','���� ������','����') 
update PROGRESS set [SUBJECT] = '��' where [SUBJECT] = '����'
--update PROGRESS set [SUBJECT] = '����' where [SUBJECT] = '��'
---t1---
---t2---
rollback;


--task 05
--A--
set transaction isolation level read committed 
begin transaction
select count(*) from PROGRESS where SUBJECT = '��'
---t1---
---t2---
select 'update PROGRESS' 'result', count(*) from PROGRESS where SUBJECT = '��'
commit
--B--
begin transaction
---t1---
update PROGRESS set SUBJECT = '����' where IDSTUDENT = 1047
--update PROGRESS set SUBJECT = '��' where IDSTUDENT = 1047
commit
---t2---


--task 06
--A--
set transaction isolation level repeatable read
begin transaction 
--select SUBJECT from PROGRESS where PROGRESS.IDSTUDENT = 1023
select * from PROGRESS where PROGRESS.SUBJECT = '����'
---t1---
---t2---
--select SUBJECT from PROGRESS where PROGRESS.IDSTUDENT = 1023 
select * from PROGRESS where PROGRESS.SUBJECT = '����'
commit
--B--
begin transaction
---t1--- 
update PROGRESS set SUBJECT = '����' where IDSTUDENT = 1023
--update PROGRESS set SUBJECT = '��' where IDSTUDENT = 1023
commit
---t2---


--task 07
--A--
set transaction isolation level serializable
begin transaction
delete PROGRESS where IDSTUDENT = 1001
insert PROGRESS values ('����',1001,'2013-10-01',8)
update PROGRESS set SUBJECT = '��' where IDSTUDENT = 1001
select SUBJECT from PROGRESS where IDSTUDENT = 1001
---t1---
select SUBJECT from PROGRESS where IDSTUDENT = 1001
---t2---
commit
--B--
set transaction isolation level read committed
begin transaction
delete PROGRESS where IDSTUDENT = 1001
insert PROGRESS values ('����',1001,'2013-10-01',8)
update PROGRESS set SUBJECT = '��' where IDSTUDENT = 1001
select SUBJECT from PROGRESS where IDSTUDENT = 1001
---t1---
commit
select SUBJECT from PROGRESS where IDSTUDENT = 1001
---t2---


--task 08
begin try
	begin tran
		insert AUDITORIUM_TYPE values ('qwe','qwerty')
		--delete AUDITORIUM_TYPE where AUDITORIUM_TYPE.AUDITORIUM_TYPE = 'qwe'
		begin try
			begin tran
				insert AUDITORIUM values('888-8','qwe',99,'888-8')			
				--delete AUDITORIUM where AUDITORIUM.AUDITORIUM = '888-8'
			commit
		end try
		begin catch
			print '������ ��������� ����������'
			print cast(error_number() as varchar(5)) + error_message()
			if @@TRANCOUNT > 1 rollback tran
		end catch
		commit tran
end try
begin catch
	print '������ ������� ����������'
	print cast(error_number() as varchar(5)) + error_message()
	if @@TRANCOUNT > 0 rollback tran
end catch
	 

