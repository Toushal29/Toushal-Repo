--EXECUTES BLOCK IN ORDER

--1.--CREATE DATABASE
create database product_inv_mgmt;
----------------------------------------------------------------------------------------------------------------------------
--2.--CREATE TABLE
--Users TABLE
CREATE TABLE Users(
userID			INT				PRIMARY KEY		IDENTITY(25000001,2),
fname			VARCHAR(50)		NOT NULL,
lname			VARCHAR(50)		NOT NULL,
username		VARCHAR(25)		UNIQUE		NOT NULL,
email			VARCHAR(100)	UNIQUE		NOT NULL	CHECK(email LIKE'%@%.%'),
phone_no		VARCHAR(15)		NOT NULL,
address			TEXT,
user_type		VARCHAR(20)		NOT NULL	CHECK(user_type IN ('Customer','Employee')),
created_date	DATETIME		DEFAULT GETDATE()
);

--Categories TABLE
CREATE TABLE Categories(
catID			CHAR(3)			PRIMARY KEY		CHECK(catID LIKE 'C%'),
category_name	VARCHAR(50)		UNIQUE			NOT NULL,
);

--Suppliers TABLE
CREATE TABLE Suppliers(
supID			VARCHAR(10)				PRIMARY KEY		CHECK(supID LIKE 'SU%'),
supplier_name	VARCHAR(100)			NOT NULL,
contact_person	VARCHAR(100),
phone_no		VARCHAR(15)				NOT NULL,
email			VARCHAR(100)			UNIQUE			CHECK(email LIKE'%@%.%') ,
address			TEXT
);

--Products TABLE
CREATE TABLE Products(
prodID			CHAR(10)		PRIMARY KEY,
prod_name		VARCHAR(100)	NOT NULL,
description		TEXT,
price			DECIMAL(7,2)	NOT NULL		CHECK(price>0),
stock_qty		INT				NOT NULL		DEFAULT 0,
catID			CHAR(3)			NOT NULL,
supID			VARCHAR(10)		NOT NULL,
FOREIGN KEY (catID) REFERENCES Categories(catID) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (supID) REFERENCES Suppliers(supID) ON DELETE CASCADE ON UPDATE CASCADE
);

--Orders TABLE
CREATE TABLE Orders(
orderID			INT				PRIMARY KEY		IDENTITY(1010100001,1),
userID			INT				NOT NULL,
total_amount	DECIMAL(10,2)	NOT NULL,
order_date		DATETIME		DEFAULT GETDATE(),
order_sts		VARCHAR(20)		CHECK(order_sts IN ('Processing', 'Completed', 'Cancelled'))		DEFAULT 'Processing',
FOREIGN KEY(userID) REFERENCES Users(userID)
);

--OrderDetails TABLE
CREATE TABLE OrderDetails(
orderID			INT				NOT NULL,
prodID			CHAR(10)		NOT NULL,
quantity		INT				NOT NULL		CHECK(quantity>0),
subtotal		DECIMAL(10,2),
PRIMARY KEY(orderID, prodID),
FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (prodID) REFERENCES Products(prodID) ON DELETE CASCADE ON UPDATE CASCADE
);

--Payments TABLE
CREATE TABLE Payments(
paymentID			INT				PRIMARY KEY		IDENTITY(111000000,2),
orderID				INT				NOT NULL,
payment_method		VARCHAR(20)		NOT NULL		CHECK(payment_method IN('Card','Juice','Cash on Delivery')),
payment_sts			VARCHAR(10)		NOT NULL		CHECK(payment_sts IN('Paid','Pending','Refunded','Cancelled'))		DEFAULT 'Pending',
trans_date			DATETIME,
FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);

--Shipping TABLE
CREATE TABLE Shipping(
shippingID			INT				PRIMARY KEY		IDENTITY(1000000001,3),
orderID				INT				NOT NULL,
carrier				VARCHAR(25),
shipping_sts		VARCHAR(20)		CHECK(shipping_sts IN('Pending processing','Shipped','Delivered','Cancelled'))		DEFAULT 'Pending processing',
estimated_delivery	DATE			DEFAULT DATEADD(DAY, 3, GETDATE()),
FOREIGN KEY(orderID) REFERENCES Orders(orderID)
);

----------------------------------------------------------------------------------------------------------------------------
--CREATE STORE PROCEDURE
--1. SP to Add User
CREATE PROCEDURE sp_add_user @fname VARCHAR(50), @lname VARCHAR(50), @username VARCHAR(25), @email VARCHAR(100), @phone_no VARCHAR(15), @address TEXT, @user_type VARCHAR(20)
AS
BEGIN
    BEGIN TRY
		BEGIN TRANSACTION;
		IF @fname IS NULL    --check for null fname input
        BEGIN
            RAISERROR('First Name is incomplete.',16,1);
            RETURN;
        END

		IF @lname IS NULL    --check for null lname input
        BEGIN
            RAISERROR('Last Name is incomplete.',16,1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Users WHERE username = @username)    --check for unique username input
        BEGIN
            RAISERROR('Username must be unique. Username already exists',16,1);
            RETURN;
        END

		IF @username IS NULL    --check for null username input
        BEGIN
            RAISERROR('Username is incomplete.',16,1);
            RETURN;
        END

		IF @email IS NOT NULL AND @email NOT LIKE '%@%.%'		--check email format (if provided)
        BEGIN
            RAISERROR('Email format is invalid.', 16, 1);
            RETURN;
        END

		IF EXISTS (SELECT 1 FROM Users WHERE email = @email)    --chech if email exist since it is unique
        BEGIN
            RAISERROR('Email already exist.',16,1);
            RETURN;
        END

        IF @email IS NULL       --check for null email input
        BEGIN
            RAISERROR('Email is incomplete.',16,1);
            RETURN;
        END

		IF @phone_no IS NULL       --check for null phone_no input
        BEGIN
            RAISERROR('Phone number is incomplete.',16,1);
            RETURN;
        END

        IF @user_type NOT IN ('Employee', 'Customer')       --check if user_type is customer or employee
        BEGIN
            RAISERROR('User type must be either employee or customer.', 16, 1);
            RETURN;
        END

        INSERT INTO Users(fname, lname, username, email, phone_no, address, user_type) VALUES
		(@fname, @lname, @username, @email, @phone_no, @address, @user_type);

		COMMIT TRANSACTION;

		PRINT'INSERT SUCCESSFUL';
    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
		DECLARE @error_msg VARCHAR(250);
		SET @error_msg = 'Error message as ' + ERROR_MESSAGE() + ' With error code ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT @error_msg;
	END CATCH
END;

--2. SP to Add a Supplier
CREATE PROCEDURE sp_add_supplier @SupId VARCHAR(10), @SupplierName VARCHAR(100), @ContactPerson VARCHAR(100), @Phone_No VARCHAR(15), @email VARCHAR(100), @Address TEXT
AS
BEGIN
    BEGIN TRY
		BEGIN TRANSACTION;

        IF @SupId IS NULL					--check for null SupId
        BEGIN
            RAISERROR('Supplier ID is incomplete.', 16, 1);
            RETURN;
        END

        IF @SupplierName IS NULL			--check for null SupplierName
        BEGIN
            RAISERROR('Supplier Name is incomplete.', 16, 1);
            RETURN;
        END

		IF @Phone_No IS NULL			--check for null phone number
        BEGIN
            RAISERROR('Phone number is incomplete.', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Suppliers WHERE supID = @SupId)	--check if SupId already exists (primary key check)
        BEGIN
            RAISERROR('Supplier ID already exists.', 16, 1);
            RETURN;
        END

        IF @SupId NOT LIKE 'SU%'			--check SupId format (must start with 'SU')
        BEGIN
            RAISERROR('Supplier ID must start with ''SU''.', 16, 1);
            RETURN;
        END

        IF @email IS NOT NULL AND @email NOT LIKE '%@%.%'		--check email format (if provided)
        BEGIN
            RAISERROR('Email format is invalid.', 16, 1);
            RETURN;
        END

		IF @email IS NOT NULL AND EXISTS (SELECT 1 FROM Suppliers WHERE email = @email)		--check if email is unique only if is entered
        BEGIN
            RAISERROR('This email is already registered.', 16, 1);
            RETURN;
        END

        INSERT INTO Suppliers (supID, supplier_name, contact_person, phone_no, email, address) 
        VALUES (@SupId, @SupplierName, @ContactPerson, @Phone_No, @email, @Address);

		COMMIT TRANSACTION;

        PRINT 'INSERT SUCCESSFUL';
    END TRY
    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
        DECLARE @error_msg VARCHAR(250);
		SET @error_msg = 'Error message as ' + ERROR_MESSAGE() + ' With error code ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT @error_msg;
    END CATCH
END;

--3. SP to Add a Category
CREATE PROCEDURE sp_add_category @catID CHAR(3), @category_name VARCHAR(50)
AS
BEGIN
    BEGIN TRY
		BEGIN TRANSACTION;

        IF @catID IS NULL				--check for null catID
        BEGIN
            RAISERROR('Category ID is incomplete.', 16, 1);
            RETURN;
        END

        IF @category_name IS NULL		--check for null category_name
        BEGIN
            RAISERROR('Category Name is incomplete.', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Categories WHERE catID = @catID) --check if catID already exists (primary key check)
        BEGIN
            RAISERROR('Category ID already exists.', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Categories WHERE category_name = @category_name)	--check if category_name already exists (unique constraint)
        BEGIN
            RAISERROR('Category Name already exists.', 16, 1);
            RETURN;
        END

        IF @catID NOT LIKE 'C%'			-- Check catID format (must start with 'C')
        BEGIN
            RAISERROR('Category ID must start with ''C''.', 16, 1);
            RETURN;
        END

        INSERT INTO Categories (catID, category_name) 
        VALUES (@catID, @category_name);

		COMMIT TRANSACTION;

        PRINT 'INSERT SUCCESSFUL';
    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
        DECLARE @error_msg VARCHAR(250);
		SET @error_msg = 'Error message as ' + ERROR_MESSAGE() + ' With error code ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT @error_msg;
    END CATCH
END;

--4. SP to Add Product
CREATE PROCEDURE sp_add_product @prodId CHAR(10), @ProdName VARCHAR(100), @Descrption TEXT, @Price DECIMAL(7,2), @stock_qty INT, @CatId CHAR(3), @SupId VARCHAR(10)
AS
BEGIN
    BEGIN TRY
		BEGIN TRANSACTION;

        IF @prodId IS NULL			-- Check for null prodId
        BEGIN
            RAISERROR('Product ID is incomplete.', 16, 1);
            RETURN;
        END

		IF EXISTS (SELECT 1 FROM Products WHERE prodID = @prodId)		--check if prodId already exists (primary key check)
        BEGIN
            RAISERROR('Product ID already exists.', 16, 1);
            RETURN;
		END

        IF @ProdName IS NULL		--check for null ProdName
        BEGIN
            RAISERROR('Product Name is incomplete.', 16, 1);
            RETURN;
        END

        IF @Price IS NULL			--check for null Price
        BEGIN
            RAISERROR('Price is incomplete.', 16, 1);
            RETURN;
        END

		IF @Price IS NOT NULL AND @Price<= 0		--check if Price is positive
        BEGIN
            RAISERROR('Price must be greater than 0.', 16, 1);
            RETURN;
        END

		IF @stock_qty IS NOT NULL AND @stock_qty < 0		--check if quantity is >= 0 if entered
        BEGIN
            RAISERROR('Qunatity entered must be greater than 0.', 16, 1);
            RETURN;
        END

        IF @CatId IS NULL			--check for null CatId
        BEGIN
            RAISERROR('Category ID is incomplete.', 16, 1);
            RETURN;
        END

		IF @CatId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Categories WHERE catID = @CatId)	--check if CatId exists in Categories
        BEGIN
            RAISERROR('Category ID for this Product does not exist.', 16, 1);
            RETURN;
        END

		IF @SupId IS NULL 			--check if SupId is null
        BEGIN
            RAISERROR('Supplier ID is incomplete.', 16, 1);
            RETURN;
        END

		IF @SupId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Suppliers WHERE supID = @SupId)		--check if SupId exists in Suppliers (if provided, since it’s nullable)
        BEGIN
            RAISERROR('Supplier ID does not exist.', 16, 1);
            RETURN;
        END

        INSERT INTO Products (prodID, prod_name, description, price, stock_qty, catID, supID) 
        VALUES (@prodId, @ProdName, @Descrption, @Price, @stock_qty, @CatId, @SupId);

		COMMIT TRANSACTION;

        PRINT 'INSERT SUCCESSFUL';
    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
        DECLARE @error_msg VARCHAR(250);
		SET @error_msg = 'Error message as ' + ERROR_MESSAGE() + ' With error code ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT @error_msg;
    END CATCH
END;

--5. SP to Buy products
CREATE PROCEDURE sp_buying_product 
@username VARCHAR(25),
@prod1_ID CHAR(10), @prod1_qty INT = 1,			--req. default 1
@prod2_ID CHAR(10) = NULL, @prod2_qty INT = 1,	--opt. default 1
@prod3_ID CHAR(10) = NULL, @prod3_qty INT = 1,	--opt. default 1
@prod4_ID CHAR(10) = NULL, @prod4_qty INT = 1,	--opt. default 1
@prod5_ID CHAR(10) = NULL, @prod5_qty INT = 1,	--opt. default 1
@payment_mtd VARCHAR(20)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		DECLARE @UserId INT;			--declare a variable to store the userid
        SELECT @UserId = userID
        FROM Users
        WHERE username = @username;

		--declare variables to calculate the subtotal of each product
		DECLARE @subtotal_prod1 DECIMAL(10,2) = 0;
		DECLARE @subtotal_prod2 DECIMAL(10,2) = 0;
		DECLARE @subtotal_prod3 DECIMAL(10,2) = 0;
		DECLARE @subtotal_prod4 DECIMAL(10,2) = 0;
		DECLARE @subtotal_prod5 DECIMAL(10,2) = 0;

		--calculate sub_total
		SET @subtotal_prod1 = (SELECT price * @prod1_qty FROM Products WHERE prodID = @prod1_ID);							--prod1 is mandatory

		IF @prod2_ID IS NOT NULL																							--prod2 to prod5 optional, use not null validation if there is product
			SET @subtotal_prod2 = (SELECT price * @prod2_qty FROM Products WHERE prodID = @prod2_ID);

		IF @prod3_ID IS NOT NULL
			SET @subtotal_prod3 = (SELECT price * @prod3_qty FROM Products WHERE prodID = @prod3_ID);

		IF @prod4_ID IS NOT NULL
			SET @subtotal_prod4 = (SELECT price * @prod4_qty FROM Products WHERE prodID = @prod4_ID);

		IF @prod5_ID IS NOT NULL
			SET @subtotal_prod5 = (SELECT price * @prod5_qty FROM Products WHERE prodID = @prod5_ID);

		
		DECLARE @total_amount DECIMAL(10,2) = 0;																			--declare variable to calculate total_amount

		SET @total_amount = @subtotal_prod1 + @subtotal_prod2 + @subtotal_prod3 + @subtotal_prod4 + @subtotal_prod5;		--calculate total amount using subtotals varailbe

		IF @total_amount <= 0																								--chck if there is a problem when calculating the sum
			RAISERROR('An error has occur when calculating the total sum of this order.',16,1);


		IF @payment_mtd NOT IN ('Card', 'Juice', 'Cash on Delivery')														--check payment method
            RAISERROR('Invalid payment method. Must be Card, Juice, or Cash on Delivery.', 16, 1);

		--Once the subtotal and total is calculated, the data is inserted in table
		DECLARE @OrderId INT;																								--variable declare for use to track orderid 
		INSERT INTO Orders (userID, total_amount) VALUES (@UserId, @total_amount);											--insert order in order table
        SET @OrderId = SCOPE_IDENTITY();																					--track recent orderId use

		--insert the details of the order in the orderdetails table
		INSERT INTO OrderDetails (orderID, prodID, quantity, subtotal) VALUES (@OrderId, @prod1_ID, @prod1_qty, @subtotal_prod1);

		IF @prod2_ID IS NOT NULL
			INSERT INTO OrderDetails (orderID, prodID, quantity, subtotal) VALUES (@OrderId, @prod2_ID, @prod2_qty, @subtotal_prod2);

		IF @prod3_ID IS NOT NULL
			INSERT INTO OrderDetails (orderID, prodID, quantity, subtotal) VALUES (@OrderId, @prod3_ID, @prod3_qty, @subtotal_prod3);

		IF @prod4_ID IS NOT NULL
			INSERT INTO OrderDetails (orderID, prodID, quantity, subtotal) VALUES (@OrderId, @prod4_ID, @prod4_qty, @subtotal_prod4);

		IF @prod5_ID IS NOT NULL
			INSERT INTO OrderDetails (orderID, prodID, quantity, subtotal) VALUES (@OrderId, @prod5_ID, @prod5_qty, @subtotal_prod5);

		--insert into payment table
		DECLARE @pay_status VARCHAR(20);																					--declare variables
		DECLARE @trans_date DATETIME;

		IF @payment_mtd = 'Card'																							--if payment mtd is card, pay_sts will be set to Paid
		BEGIN
			SET @pay_status = 'Paid'
			SET @trans_date = GETDATE();
		END;
		ELSE																												--if payment mtd is other, pay_sts will be set to pending
		BEGIN
			SET @pay_status = 'Pending';
			SET @trans_date = NULL;
		END;

		INSERT INTO Payments (orderID, payment_method, payment_sts, trans_date) VALUES (@OrderId, @payment_mtd, @pay_status, @trans_date);

		INSERT INTO Shipping (orderID, estimated_delivery) VALUES (@OrderId, DATEADD(DAY, 3, GETDATE()));	--insert into shipping table

		COMMIT TRANSACTION;

		DECLARE @message VARCHAR(100)  -- print order id with success
		SET @message = 'Order successful with OrderId ' + CAST(@OrderId AS VARCHAR(10))
		PRINT @message
	END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
        DECLARE @error_msg VARCHAR(500);
		SET @error_msg = ERROR_MESSAGE() + ' With error code ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT @error_msg;
    END CATCH
END;

--6.SP to Cancel a Buy Order
CREATE PROCEDURE sp_cancel_order @orderID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Orders WHERE orderID = @orderID)
        BEGIN
            RAISERROR('Order does not exist.', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Orders o JOIN Shipping s ON o.orderID = s.orderID
					WHERE o.orderID = @orderID
					AND (o.order_sts = 'Completed'
					OR s.shipping_sts IN ('Shipped','Delivered')))
        BEGIN
            RAISERROR('Cannot cancel a completed, shipped, or delivered order.', 16, 1);
            RETURN;
        END

        UPDATE Orders 
        SET order_sts = 'Cancelled' 
        WHERE orderID = @orderID;

		UPDATE Shipping
		SET shipping_sts = 'Cancelled'
		WHERE orderID = @orderID;

		UPDATE Payments
		SET payment_sts = 'Refunded',
			trans_date = GETDATE()
		WHERE orderID = @orderID
		AND payment_method IN ('Card','Juice')
		AND payment_sts = 'Paid';

		UPDATE Payments
        SET payment_sts = 'Cancelled'
        WHERE orderID = @orderID 
        AND payment_method = 'Cash on Delivery'

        COMMIT TRANSACTION;
        PRINT 'Order has been cancelled successfully';
    END TRY
    
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @error_msg VARCHAR(250);
        SET @error_msg = 'Error message: ' + ERROR_MESSAGE() + ' With error code: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT @error_msg;
    END CATCH
END;

--7. SP to Update a juice Payment
CREATE PROCEDURE sp_upd_juice_payment_sts @orderID INT
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;

		IF NOT EXISTS (SELECT 1 FROM Orders WHERE orderID = @orderID)			--check for exist orderId
        BEGIN
            RAISERROR('OrderID does not exist.', 16, 1);
			RETURN;
        END

		IF NOT EXISTS (SELECT 1 FROM Payments WHERE orderID = @orderID AND payment_method = 'Juice')		--check if payment for that orderid is juice
        BEGIN
            RAISERROR('This order does not use Juice payment method.', 16, 1);
			RETURN;
        END

		UPDATE Payments
		SET payment_sts = 'Paid',
			trans_date = GETDATE()
		WHERE orderID = @orderID;

		IF @@ROWCOUNT = 0								--check if update has occur
        BEGIN
            RAISERROR('Update payment status fail for this order.', 16, 1);
			RETURN;
        END

        COMMIT TRANSACTION;

        PRINT 'Juice payment status updated to Paid for OrderID ' + CAST(@orderID AS VARCHAR(10));
    END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
        DECLARE @error_msg VARCHAR(250);
		SET @error_msg = ERROR_MESSAGE() + ' With error code ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT @error_msg;
    END CATCH
END;

--8. SP to Complete an Order Delivery
CREATE PROCEDURE sp_order_delivered @orderID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Orders WHERE orderID = @orderID)
        BEGIN
            RAISERROR('OrderID not exist.', 16, 1);
            RETURN;
        END

        DECLARE @payment_method VARCHAR(20);
        SELECT @payment_method = payment_method 
        FROM Payments 
        WHERE orderID = @orderID;

        UPDATE Shipping
        SET shipping_sts = 'Delivered'
        WHERE orderID = @orderID;

        COMMIT TRANSACTION;

		IF @payment_method = 'Cash on Delivery'
		BEGIN
			PRINT 'Order: ' + CAST(@orderID AS VARCHAR(10)) + ' Payment Paid, Delivered and Completed';
			RETURN;
		END
		ELSE
		BEGIN
			PRINT 'Order: ' + CAST(@orderID AS VARCHAR(10)) + ' Delivered and Completed';
			RETURN;
		END

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @error_msg VARCHAR(250);
        SET @error_msg = 'Error: ' + ERROR_MESSAGE() + ' With error code: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT @error_msg;
    END CATCH
END;

--9. SP to Update Shipping Status
CREATE PROCEDURE sp_order_shipped @orderID INT
AS
BEGIN
    BEGIN TRY
		BEGIN TRANSACTION;
		IF NOT EXISTS (SELECT 1 FROM Orders WHERE orderID = @orderID)				--check if orderid exist
        BEGIN
            RAISERROR('OrderID not exist.', 16, 1);
        END

        DECLARE @payment_method VARCHAR(20);
        SELECT @payment_method = payment_method 
        FROM Payments 
        WHERE orderID = @orderID;

        IF @payment_method = 'Cash on Delivery'
        BEGIN
            UPDATE Shipping
            SET carrier = 'SELF',
                shipping_sts = 'Shipped'
            WHERE orderID = @orderID;
        END
        ELSE
        BEGIN
            UPDATE Shipping
            SET carrier = 'FedEx',
                shipping_sts = 'Shipped'
            WHERE orderID = @orderID;
        END

		COMMIT TRANSACTION;

        PRINT 'Order '+ CAST(@orderID AS VARCHAR(10)) + ' has shipping status updated to Shipped.'

    END TRY
    BEGIN CATCH
		IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @error_msg VARCHAR(250);
        SET @error_msg = ERROR_MESSAGE() + ' With error code ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT @error_msg;
    END CATCH
END;

--10. SP to Restock a Product Stock
CREATE PROCEDURE sp_restock_product @prod_id CHAR(10), @quantity INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Products WHERE prodID = @prod_id)
        BEGIN
            RAISERROR('Product does not exist.', 16, 1);
            RETURN;
        END

        IF @quantity <= 0
        BEGIN
            RAISERROR('Quantity must be a positive number.', 16, 1);
            RETURN;
        END

        UPDATE Products
        SET stock_qty = stock_qty + @quantity
        WHERE prodID = @prod_id;

        COMMIT TRANSACTION;

        PRINT 'Product ' + @prod_id + ' Restocked: ' + CAST(@quantity AS VARCHAR(10));
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @error_msg VARCHAR(250);
        SET @error_msg = 'Error: ' + ERROR_MESSAGE() + ' With error code: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT @error_msg;
    END CATCH
END;

--11.SP to Check product low stock
CREATE PROCEDURE sp_check_low_stock @prod_id CHAR(10) = NULL, @threshold INT = NULL
AS
BEGIN
    BEGIN TRY
		IF @threshold < 0
        BEGIN
            RAISERROR('Threshold must be a non-negative number.', 16, 1);
            RETURN;
        END

		IF @prod_id IS NULL AND @threshold IS NULL			--if no input(both inpput null) will display all prodcut qunatity
		BEGIN
			SELECT prodID, prod_name, stock_qty, supID
			FROM Products
			ORDER BY stock_qty ASC;
		END

		ELSE IF @prod_id IS NOT NULL AND @threshold IS NULL	--if prodid only input will display that product qunatity
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Products WHERE prodID = @prod_id)	--check if exists
            BEGIN
                RAISERROR('Product ID not exist.', 16, 1);
                RETURN;
            END

            SELECT prodID, prod_name, stock_qty, supID
            FROM Products
            WHERE prodID = @prod_id;
        END

        ELSE IF @prod_id IS NULL AND @threshold IS NOT NULL	--if threshold only input will display all prodcut qunatity less than threshold
        BEGIN
            IF @threshold < 0
            BEGIN
                RAISERROR('Threshold must be a non-negative number.', 16, 1);	--check if -ve input
                RETURN;
            END

            SELECT prodID, prod_name, stock_qty, supID
            FROM Products
            WHERE stock_qty <= @threshold
            ORDER BY stock_qty ASC;
		END
		
		ELSE IF @prod_id IS NOT NULL AND @threshold IS NOT NULL		--if both input
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Products WHERE prodID = @prod_id)	--check for pro id exists
            BEGIN
                RAISERROR('Product ID does not exist.', 16, 1);
                RETURN;
            END

			DECLARE @stock_qty INT;				---declare variable
			DECLARE @status VARCHAR(20);

			SELECT @stock_qty = stock_qty 
			FROM Products 
			WHERE prodID = @prod_id;

            SELECT prodID, prod_name, stock_qty, supID
            FROM Products
            WHERE prodID = @prod_id;

            IF @stock_qty >= @threshold
                PRINT 'Product ' + @prod_iD + '. Stock: ' + CAST(@stock_qty AS VARCHAR(10));	--only apply if stock quantity is highter than threshold
        END
    END TRY
    BEGIN CATCH
        DECLARE @error_msg VARCHAR(250);
        SET @error_msg = 'Error: ' + ERROR_MESSAGE() + ' With error code: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT @error_msg;
    END CATCH
END;

--12.SP to get details of a customer details
CREATE PROCEDURE sp_UserOrders @username VARCHAR(25), @OrderID INT = NULL
AS
BEGIN
	DECLARE @userID INT
	SELECT @userID = userID
	FROM Users
	WHERE username = @username

    IF @OrderID IS NULL			--if orderid is null, displays all orders of that user/customer
    BEGIN
        SELECT o.orderID, o.order_date, o.total_amount, o.order_sts, p.paymentID, p.payment_method, p.payment_sts, p.trans_date, s.shippingID, s.carrier, s.shipping_sts
        FROM Orders o
		JOIN Payments p ON o.orderID = p.orderID
		JOIN Shipping s ON o.orderID = s.orderID
        WHERE @UserID = o.userID;
    END
    ELSE					--if orderid input, will display the details of that order
	BEGIN
        SELECT od.prodID, p.prod_name, od.quantity, od.subtotal, p.price
        FROM OrderDetails od
        JOIN Products p ON od.prodID = p.prodID
        WHERE od.orderID = @OrderID;
    END
END;

--13. SP to print the status of an order
CREATE PROCEDURE sp_prt_OrderSts  @orderID INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Orders WHERE orderID = @orderID)
        BEGIN
            RAISERROR('Order does not exist', 16, 1);
            RETURN;
        END
        DECLARE @orderStatus VARCHAR(20);
        SELECT @orderStatus = order_sts FROM Orders WHERE orderID = @orderID;
        
        PRINT 'Order Status: ' + @orderStatus;
    END TRY
    
    BEGIN CATCH
        DECLARE @error_msg VARCHAR(250);
        SET @error_msg = 'Error message: ' + ERROR_MESSAGE();
        PRINT @error_msg;
    END CATCH
END;

--14. SP to Update price of a product
CREATE PROCEDURE sp_update_product_price @username VARCHAR(25), @prodID CHAR(10), @new_price DECIMAL(7,2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
		DECLARE @UserId int;
    
		SELECT @UserId = userID
		FROM Users
		WHERE username = @Username;

		IF NOT EXISTS (SELECT 1 FROM Users WHERE userID = @UserId AND user_type = 'Employee')		--check if user is employee
		BEGIN
			RAISERROR ('User is not an employee. CAnnot update price', 16, 1);
			RETURN;
		END

        IF NOT EXISTS (SELECT 1 FROM Products WHERE prodID = @prodID)
        BEGIN
            RAISERROR('Product ID does not exist.', 16, 1);
            RETURN;
        END

        IF @new_price IS NULL
        BEGIN
            RAISERROR('Price cannot be NULL.', 16, 1);
            RETURN;
        END

        IF @new_price <= 0
        BEGIN
            RAISERROR('Price must be greater than 0.', 16, 1);
            RETURN;
        END

        UPDATE Products
        SET price = @new_price
        WHERE prodID = @prodID;

        COMMIT TRANSACTION;
        PRINT 'Product ' + @prodID + ' price updated successfully. New price is : ' + @new_price;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @error_msg VARCHAR(250);
        SET @error_msg = 'Error: ' + ERROR_MESSAGE() + ' With error code: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT @error_msg;
    END CATCH
END;

--15.SP to Update supplier contact person
CREATE PROCEDURE sp_update_supplier_contact_person @supID VARCHAR(10), @contact_person VARCHAR(100)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE supID = @supID)
        BEGIN
            RAISERROR('Supplier ID does not exist.', 16, 1);
            RETURN;
        END

        UPDATE Suppliers
        SET contact_person = @contact_person
        WHERE supID = @supID;

        COMMIT TRANSACTION;
        PRINT 'Supplier of ' + @supID + ' has new contact person: ' + @contact_person;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @error_msg VARCHAR(250);
        SET @error_msg = 'Error: ' + ERROR_MESSAGE() + ' With error code: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT @error_msg;
    END CATCH
END;

--16.SP to update User's Address
CREATE PROCEDURE sp_update_user_address @username VARCHAR(25), @new_address TEXT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
		DECLARE @uid INT
		SELECT @uid = userID
		FROM Users
		WHERE @username = username

        IF NOT EXISTS (SELECT 1 FROM Users WHERE userID = @uid)
        BEGIN
            RAISERROR('User  does not exist.', 16, 1);
            RETURN;
        END

        UPDATE Users
        SET address = @new_address
        WHERE userID = @uid;

        COMMIT TRANSACTION;
        PRINT 'User ID ' + CAST(@uid AS VARCHAR(10));
		PRINT 'Address updated successfully.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @error_msg VARCHAR(250);
        SET @error_msg = 'Error: ' + ERROR_MESSAGE() + ' With error code: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT @error_msg;
    END CATCH
END;

--17.SP to update username of an existinig user
CREATE PROCEDURE sp_update_user_username @old_username VARCHAR(25), @new_username VARCHAR(25)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
		DECLARE @userID INT

		SELECT @userID = userID
		FROM Users
		WHERE @old_username = username

        IF NOT EXISTS (SELECT 1 FROM Users WHERE userID = @userID)
        BEGIN
            RAISERROR('User ID does not exist.', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Users WHERE username = @new_username AND userID != @userID)
        BEGIN
            RAISERROR('Username is already taken.', 16, 1);
            RETURN;
        END

        UPDATE Users
        SET username = @new_username
        WHERE userID = @userID;

        COMMIT TRANSACTION;
        PRINT 'User ID ' + CAST(@userID AS VARCHAR(10));
		PRINT 'Username updated successfully.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @error_msg VARCHAR(250);
        SET @error_msg = 'Error: ' + ERROR_MESSAGE() + ' With error code: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT @error_msg;
    END CATCH
END;

----------------------------------------------------------------------------------------------------------------------------
--TRIGGERs
--1. Trigger to activate when an order is cancel to restock the product
CREATE TRIGGER trg_RestockCancel
ON Orders
AFTER UPDATE
AS
BEGIN
	BEGIN TRY
		IF EXISTS( SELECT 1 FROM Orders WHERE order_sts = 'Cancelled')
		BEGIN
			UPDATE Products
			SET stock_qty = stock_qty + od.quantity
			FROM Products p
			JOIN OrderDetails od ON p.prodID = od.prodID
			JOIN Orders o ON od.orderID = o.orderID
			WHERE o.order_sts = 'Cancelled';
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
		DECLARE @error_msg VARCHAR(500);
		SET @error_msg = ERROR_MESSAGE() + ' With error code ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT @error_msg;
	END CATCH
END;

--2. Trigger to complete an order status when order is delivered
CREATE TRIGGER trg_AutoCompleteOrderOnDelivery
ON Shipping
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        IF UPDATE(shipping_sts)
        BEGIN
            UPDATE Orders
            SET order_sts = 'Completed'
            FROM Orders o
            JOIN inserted i ON o.orderID = i.orderID
            WHERE i.shipping_sts = 'Delivered';
        END
    END TRY
    BEGIN CATCH
        DECLARE @error_msg VARCHAR(500);
        SET @error_msg = 'Trigger error: ' + ERROR_MESSAGE() + ' With error code: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT @error_msg;
        THROW;
    END CATCH
END;

--3. Trigger to check for enough product when SP buying product
CREATE TRIGGER trg_CheckStockQuantity
ON OrderDetails
INSTEAD OF INSERT
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT 1 FROM inserted i JOIN Products p ON i.prodID = p.prodID WHERE p.stock_qty < i.quantity)
		BEGIN
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
			RAISERROR ('Insufficient stock for one or more products.', 16, 1);
		END
		ELSE
		BEGIN
			INSERT INTO OrderDetails (orderID, prodID, quantity, subtotal)
			SELECT orderID, prodID, quantity, subtotal FROM inserted;
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
		DECLARE @error_msg VARCHAR(500);
		SET @error_msg = ERROR_MESSAGE() + ' With error code ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT @error_msg;
	END CATCH
END;

--4. Trigger auto update a payment of COD to paid when delivered
CREATE TRIGGER trg_UpdatePaymentOnDelivery
ON Shipping
AFTER UPDATE
AS
BEGIN
    BEGIN TRY
        IF UPDATE(shipping_sts)
        BEGIN
            UPDATE Payments
            SET payment_sts = 'Paid',
                trans_date = GETDATE()
            FROM Payments p
            JOIN inserted i ON p.orderID = i.orderID
            WHERE i.shipping_sts = 'Delivered'
            AND p.payment_method = 'Cash on Delivery';
        END
    END TRY
    BEGIN CATCH
        DECLARE @error_msg VARCHAR(500);
        SET @error_msg = 'Trigger error: ' + ERROR_MESSAGE() + ' With error code: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT @error_msg;
        THROW;
    END CATCH
END;

--5. Trigger that will reduce the stock of for a product after purchase
CREATE TRIGGER trg_UpdateStockOrder
ON OrderDetails
AFTER INSERT
AS
BEGIN
	BEGIN TRY
		UPDATE Products
		SET stock_qty = stock_qty - i.quantity
		FROM Products p
		JOIN inserted i ON p.prodID = i.prodID
	END TRY
	BEGIN CATCH
		DECLARE @error_msg VARCHAR(500);
		SET @error_msg = ERROR_MESSAGE() + ' With error code ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
		PRINT @error_msg;
    END CATCH
END;

--------------------------------------------------------------------------------------------------------------------------------
--Create View on Table
--1. A view that will show the details of low stock product <= 10
CREATE VIEW vw_lowStock
AS
SELECT p.prodID,p.prod_name,p.stock_qty
FROM Products p
WHERE p.stock_qty <= 10;

--2. A view to see all order history
CREATE VIEW vw_CustomerOrderHistory
AS
SELECT o.orderID, o.order_date, o.total_amount, o.order_sts, u.username
FROM Orders o
JOIN Users u ON o.userID = u.userID
WHERE u.user_type = 'Customer';

--3. A view that will display the products, stock supplier name and catugory
CREATE VIEW vw_ProductStock
AS
SELECT p.prodID, p.prod_name, p.stock_qty, c.category_name, s.supplier_name
FROM Products p
JOIN Categories c ON p.catID = c.catID
JOIN Suppliers s ON p.supID = s.supID;

--4. An SP that will take a username and use the VIEW vw_CustomerOrderHistory to display that user order
CREATE PROCEDURE sp_GetCustomerOrders @username VARCHAR(25)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Users WHERE username = @username AND user_type = 'Customer')
        BEGIN
            RAISERROR('User does not exist or is not a Customer.', 16, 1);
            RETURN;
        END

        SELECT orderID, order_date, total_amount, order_sts
        FROM vw_CustomerOrderHistory
        WHERE username = @username
        ORDER BY order_date DESC;

        IF @@ROWCOUNT = 0
            PRINT 'No orders found for user: ' + @username;
        ELSE
            PRINT 'Order history retrieved for user: ' + @username;
    END TRY
    BEGIN CATCH
        DECLARE @error_msg VARCHAR(250);
        SET @error_msg = 'Error: ' + ERROR_MESSAGE() + ' With error code: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT @error_msg;
    END CATCH
END;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Exec SP to populate table
EXEC sp_add_user 'Michael', 'Brown', 'mikeB', 'michael.brown@outlook.com', '57785521', 'Pine Road, Port Louis, Mauritius', 'Customer';
EXEC sp_add_user 'Sarah', 'Davis', 's1234davis', 'sarahdavis@gmail.com', '50552345', 'Hassin Lane, Bell Air, Mauritius', 'Customer';
EXEC sp_add_user 'Laura', 'Martinez', 'martinez', 'martinezlaura@yahoo.com', '53054321', 'Paul Pierre Jack Street, Plaine Magnien, MU', 'Employee';
EXEC sp_add_user 'Robert', 'Taylor', 'taylorrob', 'robertGAMER@icloud.com', '57725666', NULL, 'Customer';
EXEC sp_add_user 'Jennifer', 'Anderson', 'Jenni', 'jennifer12345@gmail.com', '57028765', 'London Way Maghbourg, Mauritius', 'Employee';
EXEC sp_add_user 'Lisa', 'Hernandez', 'lisa01', 'lisahernandez@yahoo.com', '55127890', 'Aslan Lane, Surinam, Mauritius', 'Customer';
EXEC sp_add_user 'Pravin', 'Ramgoolam', 'pravinR', 'pranvinRam@outlook.com', '58455241', 'Morc. Pravin Navin Lane, Reduit, Mauritius', 'Customer';
EXEC sp_add_user 'Matthew', 'White', 'MaTTwhite', 'matthewwhite@aol.com', '58223210', 'Magnolia Road, Triollet, Mauritius', 'Customer';
EXEC sp_add_user 'Daniel', 'Clark', 'clark001', 'clark535@icloud.com', '59972100', NULL, 'Customer';
EXEC sp_add_user 'Kelly', 'Rodriguez', 'kellyR1234', 'kellyRod999@gmail.com', '59382678', NULL, 'Customer';

EXEC sp_add_category 'C02', 'Automotive & Tools';
EXEC sp_add_category 'C06', 'Office Supplies & Stationery';
EXEC sp_add_category 'C10', 'DIY & Home Improvement';
EXEC sp_add_category 'C12', 'Electronics & Accessories';
EXEC sp_add_category 'C13', 'Fashion & Apparel';
EXEC sp_add_category 'C14', 'Garden & Outdoor';
EXEC sp_add_category 'C18', 'Home & Kitchen';
EXEC sp_add_category 'C27', 'Sports & Outdoor';
EXEC sp_add_category 'C28', 'Toys & Games';

EXEC sp_add_supplier 'SU09003821', 'TechTrend Innovations', 'Robert Assirvaden', '58550123', 'john@techtrend.com', 'Tech Avenue, Ebene, MU';
EXEC sp_add_supplier 'SU00108552', 'Espace Maisson Supplies', 'Tee Lin Chan', '57655456', 'chen@emaison.com', '456 Builders Rd, Phoenix, MU';
EXEC sp_add_supplier 'SU00309200', 'OfficeMax Distributors', 'Chen', '58540789', 'robert@officemaxdist.com', 'Office Park, Bell Village, MU';
EXEC sp_add_supplier 'SU04040101', 'SportsGear Inc', 'Ravi Juggnat', '59321011', 'ravi@sportsgear.com', 'Fitness Way, Port Louis, MU';
EXEC sp_add_supplier 'SU00001016', 'GreenGarden Co', NULL, '58851617', 'ashil.M@greengarden.com', '303 Plant Lane, Rose Hill, MU';
EXEC sp_add_supplier 'SU20300217', 'FashionTrend Ltd', 'Renganaden PenaLaiti', '57761920', 'penaLaiti@fashiontrend.com', 'Style Blvd, Bell Air, MU';
EXEC sp_add_supplier 'SU20235558', 'FoodMasters Inc', NULL, '59882223', 'FM.purchasing@foodmasters.com', 'Culinary Dr, Curepipe, MU';
EXEC sp_add_supplier 'SU25251330', 'IndustrialTech', 'Paul Jagurnat', '55762829', 'p.jag@industrialtech.com', 'Machinery Rd, Phoenix, MU';

EXEC sp_add_product 'SPOR0003P1', 'Yoga Mat', 'Non-slip, 6mm thick', 350.00, 100, 'C27', 'SU04040101';
EXEC sp_add_product 'FITN0006R4', 'Running Shoes', 'Men’s size 10, lightweight', 2650.00, 45, 'C27', 'SU04040101';
EXEC sp_add_product 'BALL0005B3', 'Soccer Ball', NULL, 400.00, 150, 'C27', 'SU04040101';
EXEC sp_add_product 'ELEC00K9P2', 'Wireless Headphones', 'Bluetooth 5.0, Noise-Canceling', 3825.00, 50, 'C12', 'SU09003821';
EXEC sp_add_product 'GADGT55R72', 'LED TV 55-inch', '4K Ultra HD, Smart TV', 25900.00, 5, 'C12', 'SU09003821';
EXEC sp_add_product 'DCRL000LCP', 'Laptop Cooling Pad', 'RGB Lighting, 5 Fans', 975.00, 75, 'C12', 'SU09003821';
EXEC sp_add_product 'TECH002N8Q', 'Smartphone Charger', 'Fast-charging USB-C', 150.00, 200, 'C12', 'SU09003821';
EXEC sp_add_product 'SHRD00PS90', 'Paper Shredder', '10-sheet capacity, cross-cut', 3265.00, 0, 'C06', 'SU00309200';
EXEC sp_add_product 'NOTE000008', 'Sticky Notes Pack', 'Assorted colors, 500 sheets', 200.00, 500, 'C06', 'SU00309200';
EXEC sp_add_product 'SUPP0111F7', 'Printer Ink Set', '4-color pack, high yield 5000pgs', 1750.00, 100, 'C06', 'SU00309200';
EXEC sp_add_product 'FASHT002N3', 'Leather Jacket', NULL, 5500.00, 25, 'C13', 'SU20300217';
EXEC sp_add_product 'JEAN0008D9', 'Denim Jeans', 'Women’s size 8, slim fit', 1450.00, 100, 'C13', 'SU20300217';
EXEC sp_add_product 'INDUS008W4', 'Power Drill', 'Cordless, 20V', 4650.00, 25, 'C10', 'SU25251330';
EXEC sp_add_product 'GARHR00509', 'Garden Hose 50ft', 'Flexible, kink-resistant', 1350.00, 80, 'C14', 'SU00108552';
EXEC sp_add_product 'PATI9Y8B22', 'Patio Umbrella', '3Mt, UV-resistant', 1250.00, 8, 'C14', 'SU00108552';
EXEC sp_add_product 'AUTO0001T5', 'Car Wax', 'High-gloss finish, 500ml', 450.00, 60, 'C02', 'SU25251330';
EXEC sp_add_product 'DIY00003H7', 'Hammer', 'Steel head, rubber grip', 300.00, 80, 'C10', 'SU25251330';
EXEC sp_add_product 'HOME0007C3', 'Ceramic Vase', 'Hand-painted, 30cm', 1200.00, 15, 'C18', 'SU00108552';

EXEC sp_buying_product @username = 'mikeB', @prod1_ID = 'SPOR0003P1', @prod1_qty = 2, @prod2_ID = 'INDUS008W4', @prod2_qty = 1, @prod3_ID = 'NOTE000008', @prod3_qty = 4, @payment_mtd = 'Card';
EXEC sp_buying_product @username = 'Jenni', @prod1_ID = 'FASHT002N3', @prod1_qty = 1, @prod2_ID = 'JEAN0008D9', @prod2_qty = 2, @prod3_ID = 'TECH002N8Q', @prod3_qty = 3, @payment_mtd = 'Cash on Delivery';
EXEC sp_buying_product @username = 'MaTTwhite', @prod1_ID = 'GADGT55R72', @prod1_qty = 1, @prod2_ID = 'DCRL000LCP', @prod2_qty = 1, @payment_mtd = 'Card';
EXEC sp_buying_product @username = 'clark001', @prod1_ID = 'FITN0006R4', @prod1_qty = 2, @prod2_ID = 'BALL0005B3', @prod2_qty = 1, @payment_mtd = 'Card';
EXEC sp_buying_product @username = 'kellyR1234', @prod1_ID = 'PATI9Y8B22', @prod1_qty = 1, @prod2_ID = 'GARHR00509', @prod2_qty = 1, @payment_mtd = 'Cash on Delivery';
EXEC sp_buying_product @username = 'kellyR1234', @prod1_ID = 'PATI9Y8B22', @prod1_qty = 1, @prod2_ID = 'INDUS008W4', @prod2_qty = 3, @payment_mtd = 'Juice';

EXEC sp_upd_juice_payment_sts @orderID = 1010100006

EXEC sp_order_shipped @orderID = 1010100002
EXEC sp_order_shipped @orderID = 1010100003
EXEC sp_order_shipped @orderID = 1010100006

EXEC sp_order_delivered @orderID = 1010100002
EXEC sp_order_delivered @orderID = 1010100006





SELECT * FROM Users
SELECT * FROM Categories
SELECT * FROM Suppliers
SELECT * FROM Products
SELECT * FROM Orders
SELECT * FROM OrderDetails
SELECT * FROM Payments
SELECT * FROM Shipping
