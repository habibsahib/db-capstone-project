select max(TotalCost) from Orders;
Select TableNo, (TotalCost) from Orders group by TableNo;
select max(tq.stq) from (select sum(Quantity) as stq from Orders_Details group by OrderID) as tq;
delimiter //
create procedure GetMaxQuantity()
begin
select max(tq.stq) as 'Max Quantity Order' from (select sum(Quantity) as stq from Orders_Details group by OrderID) as tq;
end //
delimiter ;
call GetMaxQuantity();
select c.CustomerID, o.OrderID, o.TotalCost from Orders as o inner join Bookings as b on
b.BookingID = o.BookingID
inner join Customers as c on b.CustomerID = c.CustomerID
where c.CustomerID = 2;
prepare GetOrderDetails from "
select c.CustomerID, o.OrderID, o.TotalCost from Orders as o inner join Bookings as b on
b.BookingID = o.BookingID
inner join Customers as c on b.CustomerID = c.CustomerID
where c.CustomerID = ?";
set @var=4;
execute GetOrderDetails using @var;
delimiter //
create procedure CancelOrder(in oid int)
begin
delete from OrderDelivery where OrderID = oid;
delete from Orders_Details where OrderID = oid;
delete from Orders where OrderID = oid;
Select concat("Order Number: ", oid, " Cancelled.") as Confirmation;
end //
delimiter ;
call CancelOrder(5);
select * from Bookings;
delimiter //
create procedure CheckBooking(in dt varchar(45), in tbl int)
Begin
select case 
when TableNo= tbl
then concat("Table No: ",tbl," is not available") 
else concat("Table No: ",tbl," is available") end 
as Booking_info from Bookings where BookingDate = dt ;
end //
delimiter ;
call CheckBooking('2023-09-21 11:30:00', 5);
delimiter //
create procedure AddBooking(in bid int, in cid int, in dt varchar(45), in tno int, in sid int)
begin
	insert into Bookings(BookingID, BookingDate, CustomerID, TableNo, StaffID)
    values(bid, dt, cid, tno, sid);
    select "New Booking Added." as Confirmation;
end //
delimiter ;
call AddBooking(13, 3, "2023-09-30 18:00:00", 5, 4);
-- create update booking procedure
delimiter //
create procedure UpdateBooking(in bid int, in dt varchar(30))
begin
	set @bid_check = (select BookingID from Bookings where BookingID=bid);
    if @bid_check then
		update Bookings set BookingDate = dt where BookingID = bid;
        select "New booking added." as Confirmation;
	else
		select concat("No booking found with BookingID: ",bid) as "Alert";
	end if;
end //
delimiter ;
call UpdateBooking(2, "2023-09-22 12:00:00");
