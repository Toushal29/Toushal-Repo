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

EXEC sp_upd_juice_payment_sts @orderID = 1010100006	--##DONT EXECUTE will be done in SP test case

EXEC sp_order_shipped @orderID = 1010100002			--##DONT EXECUTE will be done in SP test case
EXEC sp_order_shipped @orderID = 1010100003			--##DONT EXECUTE will be done in SP test case
EXEC sp_order_shipped @orderID = 1010100006			--##DONT EXECUTE will be done in SP test case

EXEC sp_order_delivered @orderID = 1010100002		--##DONT EXECUTE will be done in SP test case
EXEC sp_order_delivered @orderID = 1010100006		--##DONT EXECUTE will be done in SP test case


SELECT * FROM USers
SELECT * FROM Shipping

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--TEEST CASES
--1. SP sp_add_user
--valid case user
EXEC sp_add_user 'Alice', 'Smith', 'alice_smith', 'alice.smith@mail.com', '51122334', 'Avenue Chemain Enden, Flacq', 'Customer';
EXEC sp_add_user 'Emma', 'Williams', 'emma_w', 'emma.williams@yahoo.com', '52233445', NULL, 'Customer';	--null address
--invalid case- 
EXEC sp_add_user NULL, 'Doe', 'john_doe', 'johndoe@email.com', '50011234', '123 Street, City, Country', 'Customer';			--null first name
EXEC sp_add_user 'John', NULL, 'john_doe', 'johndoe@email.com', '50011234', '123 Street, City, Country', 'Customer';		--null last name
EXEC sp_add_user 'John', 'Doe', NULL, 'johndoe@email.com', '50011234', '123 Street, City, Country', 'Customer';				--null username
EXEC sp_add_user 'John', 'Doe', 'john_doe', NULL, '50011234', '123 Street, City, Country', 'Customer';						--null email
EXEC sp_add_user 'John', 'Doe', 'john_doe', 'johndoe@email.com', NULL, '123 Street, City, Country', 'Employee';				--null phone number'
EXEC sp_add_user 'Pravin', 'Ramdonee', 'pravinR', 'pRamdonee@gmail.com', '59911244', 'Morc. Didi Cowlesur lane Surinam, Mauritius', 'Customer';	--duplicate username
EXEC sp_add_user 'Jenni', 'Fernandez', 'JenniFer', 'jennifer12345@gmail.com', '58828765', 'Potti Lane Souillac, Mauritius', 'Employee';		--duplicate email
EXEC sp_add_user 'Liam', 'Brown', 'liam_b', 'liambrownemail.com', '51122334', '12 Road, City, Country', 'Customer';			--wrong email format
EXEC sp_add_user 'Ethan', 'Davis', 'ethan_d', 'ethan.davis@mail.com', '53344556', '789 Blvd, City, Country', 'Admin';		--wrong user type

--2. SP sp_add_supplier
--valid supplier
EXEC sp_add_supplier 'SU10012012', 'EcoTech Solutions', 'Ashwin Beeharry', '58561234', 'ashwin@ecotech.com', 'Green Lane, Rose Hill, MU';
EXEC sp_add_supplier 'SU20031522', 'Mauritius Hardware Ltd', NULL, '59874512', 'info@mruhardware.com', 'Industrial Zone, Phoenix, MU';	--null cp
EXEC sp_add_supplier 'SU30099876', 'Island Marine Supplies', 'Kiran Chadee', '59031245', NULL, 'Harbor Lane, Port Louis, MU';	--null email
EXEC sp_add_supplier 'SU40078965', 'Star Electronics', 'Nivish Ramphul', '59482365', 'nivish@starelectro.com', NULL;			--null address
--invalid test case- 
EXEC sp_add_supplier NULL, 'Global Logistics Ltd', 'Pravesh Jugurnath', '59633478', 'p.jug@globallog.com', 'Warehouse Rd, Plaine Magnien, MU';	--null supID
EXEC sp_add_supplier 'SU50065432', NULL, 'Rishi Dowlut', '59741236', 'r.dowlut@supplyhub.com', 'Commerce St, Grand Baie, MU';		--null supplier name
EXEC sp_add_supplier 'SU60081234', 'MedHealth Distributors', 'Devesh Mohun', NULL, 'devesh@medhealth.com', 'Labourdonnais St, Curepipe, MU';	--null phone no
EXEC sp_add_supplier 'SU10012012', 'Another Tech Company', 'Sunil Ramkalawan', '58963412', 'sunil@anothertech.com', 'Tech City, Ebene, MU';		--duplicate supID
EXEC sp_add_supplier 'SU70091234', 'Textile Hub Ltd', 'Rajesh Bhugun', '59127834', 'nivish@starelectro.com', 'Garment Zone, Vacoas, MU';		--duplicate email
EXEC sp_add_supplier 'XX12345678', 'Automobile Solutions', 'Kevin Joomun', '58239876', 'kevin@autosol.com', 'Car City, Pailles, MU';		--wrong supId format: starts with XX
EXEC sp_add_supplier 'SU80012345', 'AgroTech Supplies', 'Vinay Rughoobur', '58895678', 'vinayrughoobur.com', 'Farm Road, Goodlands, MU';	--wrong email format

--3.SP sp_add_category
--valid category
EXEC sp_add_category 'C01', 'Health & Beauty';
EXEC sp_add_category 'C15', 'Gifts & Gifts Cards';
--invalid case- 
EXEC sp_add_category NULL, 'Pet Supplies';					--NUll catID
EXEC sp_add_category 'C05', NULL;							--Null cat_name
EXEC sp_add_category 'C02', 'Travel & Luggage';				--duplicate catID
EXEC sp_add_category 'C30', 'Electronics & Accessories';	--duplicate cat_name
EXEC sp_add_category 'X10', 'Watches & Jewelry';			--wrong format not statr with C

--4. SP sp_add_product
--valid case
EXEC sp_add_product 'ELEC9999X1', 'Smart Speaker', 'Wi-Fi enabled, voice assistant', 4500.00, 2, 'C12', 'SU09003821';
EXEC sp_add_product 'HOMK0002V5', 'Wall Clock', NULL, 1250.00, 20, 'C18', 'SU00108552';		--null description
EXEC sp_add_product 'OFFC0004T8', 'Desk Organizer', 'Metal mesh, black finish', 950.00, 0, 'C06', 'SU00309200';		--no stock so default is set to 0
--invalid case
EXEC sp_add_product NULL, 'Gaming Mouse', 'RGB Lighting, ergonomic', 1200.00, 50, 'C12', 'SU09003821';				--null prodId
EXEC sp_add_product 'TECH001A5P', NULL, 'Fast-charging adapter', 899.00, 100, 'C12', 'SU09003821';					--null prodName
EXEC sp_add_product 'GADGT88Z7X', 'VR Headset', 'Wireless, immersive experience', NULL, 25, 'C12', 'SU09003821';	--null price
EXEC sp_add_product 'GADGT77Z5X', 'Bluetooth Speaker', 'Waterproof, portable', -999.00, 50, 'C12', 'SU09003821';	--price negative
EXEC sp_add_product 'AUTO0099C1', 'Car Dashboard Cleaner', 'Anti-dust, 500ml', 350.00, 45, NULL, 'SU25251330';		--null catId
EXEC sp_add_product 'HOME0005J9', 'Curtains Set', 'Blackout, 2 panels', 1800.00, 30, 'C18', NULL;					--null supid
EXEC sp_add_product 'SHRD00PS90', 'Industrial Shredder', '20-sheet capacity', 5000.00, 10, 'C06', 'SU00309200';		--duplicate prodId
EXEC sp_add_product 'HOME0023L1', 'Table Lamp', 'Wooden base, LED bulb', 1750.00, 40, 'C99', 'SU00108552';			--catId not exists
EXEC sp_add_product 'AUTO0041M8', 'Engine Oil', '5W-30, synthetic', 950.00, 60, 'C02', 'SU99999999';				--supId not exists
EXEC sp_add_product 'ELEC0099K5', 'Laptop Stand', 'Adjustable height, foldable', 2800.00, -5, 'C12', 'SU09003821';	--stock quantity is negative

--5.SP sp_buying_product
--valid case: Sufficient stock
EXEC sp_buying_product @username = 'mikeB', @prod1_ID = 'SPOR0003P1', @prod1_qty = 2, @prod2_ID = 'INDUS008W4', @prod2_qty = 1, @prod3_ID = 'NOTE000008', @prod3_qty = 4, @payment_mtd = 'Juice';
--valid case: full stock purchase. stock of that product is reduced to 0 ##DEPEND ON ABOVE EXEC PROCEDURE OF ADD PRODUCT
EXEC sp_buying_product @username = 'MaTTwhite', @prod1_ID = 'HOMK0002V5', @prod1_qty = 20, @prod2_ID = 'DCRL000LCP', @prod2_qty = 1, @payment_mtd = 'Card';
--invalid case: Insufficient Stock
EXEC sp_buying_product @username = 'Jenni', @prod1_ID = 'GADGT55R72', @prod1_qty = 6, @prod2_ID = 'INDUS008W4', @prod2_qty = 2, @payment_mtd = 'Cash on Delivery';
--invalid case: Attemp to buy a product out of stock		##DEPEND ON ABOVE ADD PRODUCT
EXEC sp_buying_product @username = 'clark001', @prod1_ID = 'OFFC0004T8', @prod1_qty = 1, @prod2_ID = 'BALL0005B3', @prod2_qty = 1, @payment_mtd = 'Card';

--7. SP sp_upd_juice_payment_sts
--valid case:
EXEC sp_upd_juice_payment_sts @orderID = 1010100006		-- OrderID 1010100006
EXEC sp_upd_juice_payment_sts @orderID = 1010100007		-- OrderID 1010100007 ##NEED ABOVE EXEC SP procedure
--invalid case
EXEC sp_upd_juice_payment_sts @orderID = 9999999;		--update for a non existent payment
EXEC sp_upd_juice_payment_sts @orderID = 1010100004;	--update a payment for card

--8. sp_order_shipped
--valid case
EXEC sp_order_shipped @orderID = 1010100001
EXEC sp_order_shipped @orderID = 1010100002
EXEC sp_order_shipped @orderID = 1010100005
EXEC sp_order_shipped @orderID = 1010100006
--invalid case
EXEC sp_order_shipped @orderID = 9999999;		--non exists orderid

--9 SP sp_order_delivered
--valid case
EXEC sp_order_delivered @orderID = 1010100002
EXEC sp_order_delivered @orderID = 1010100006

--6. SP sp_cancel_order
--valid cancel
EXEC sp_cancel_order @orderID = 1010100003
--invalid cancel order has been shipped or delivered
EXEC sp_cancel_order @orderID = 1010100004
EXEC sp_cancel_order @orderID = 1010100006

--10. SP sp_restock_product
--valid case
EXEC sp_restock_product @prod_id = 'SHRD00PS90', @quantity = 10
EXEC sp_restock_product @prod_id = 'OFFC0004T8', @quantity = 5			--##REQUIRE ABOVE EXEC TO BE EXEC- SP sp_add_product
--invalid case
EXEC sp_restock_product @prod_id = 'SRDDD0PS90', @quantity = 10			--not existant prodID
EXEC sp_restock_product @prod_id = 'SHRD00PS90', @quantity = -10		--restock with -ve stock

--11. SP sp_check_low_stock
EXEC sp_check_low_stock @prod_id = NULL, @threshold = NULL		--valid case, both null so display all
EXEC sp_check_low_stock @prod_id = NULL, @threshold = 50		--valid case, prod_id null so display all prod with less than threshold
EXEC sp_check_low_stock @prod_id = 'BALL0005B3', @threshold = NULL		--valid case, prod_id input, threshold is NULL so display the prod stock
--DISPLAY STOCK BUT PRINT A MESSAGE FOR IT
EXEC sp_check_low_stock @prod_id = 'BALL0005B3', @threshold = 50		--valid case, prod_id input, threshold is less 50. still display the prod stock
EXEC sp_check_low_stock @prod_id = 'BALL0005B3', @threshold = 100		--valid case, prod_id input, threshold is less 50. still display the prod stock + PRINT A MESSAGE FOR IT
--invalid case
EXEC sp_check_low_stock @prod_id = 'BALL0005B3', @threshold = -12		--(-ve) sttock
EXEC sp_check_low_stock @prod_id = 'BAL0LL05B3', @threshold = 12		--non existent prodId

--12. SP sp_UserOrders
EXEC sp_UserOrders @username = 'kellyR1234'									--all orders
EXEC sp_UserOrders @username = 'kellyR1234', @Orderid = '1010100006'		--specific order id
--invalid test cases
EXEC sp_UserOrders @username = 'kellyR4321'									--invalid username
EXEC sp_UserOrders @username = 'kellyR1234', @Orderid = '1010100004'		--wrong order id

--13. SP sp_prt_OrderSts
EXEC sp_prt_OrderSts @orderID = 1010100001		--valid orderId
EXEC sp_prt_OrderSts @orderID = 1010100003		--valid orderID
EXEC sp_prt_OrderSts @orderID = 1010100006		--valid OrderID
--invalid order id
EXEC sp_prt_OrderSts @orderID = 1010102212

--14. SP sp_update_product_price
EXEC sp_update_product_price 'Jenni', 'GADGT55R72', 27500.00		--valid case
EXEC sp_update_product_price 'martinez', 'INDUS008W4', 2750.00		--valid case
--invalid case
EXEC sp_update_product_price 'pravinR', 'GADGT55R72', 32500.00		--invalid case, wrong user type: customer
EXEC sp_update_product_price 'martinez', 'INDUS008W4', -2750.00		-- -ve price
EXEC sp_update_product_price 'Jenni', 'INDUS122W4', 2750.00		--wrong/ not existant prodID

--15 SP sp_update_supplier_contact_person
EXEC sp_update_supplier_contact_person @supID = 'SU00001016', @contact_person = 'Paul Pierre Jack'		--valid id with a null contact person
EXEC sp_update_supplier_contact_person @supID = 'SU20031522', @contact_person = 'Jolly jumper'			--valid id with a null contact person
EXEC sp_update_supplier_contact_person @supID = 'SU20235558', @contact_person = 'Tom Newzealand'		--valid id with a null contact person
EXEC sp_update_supplier_contact_person @supID = 'SU09003821', @contact_person = 'Jonny Nis'				--valid id with a new update contact person
--invalid case
EXEC sp_update_supplier_contact_person @supID = 'SU00213313', @contact_person = 'Pierre Jack Paul'		--invalid supId

--16. SP sp_update_user_address
EXEC sp_update_user_address @username = 'taylorrob', @new_address = 'Sookdy Lane, La Rosa Mauritius'		--valid username with null address
EXEC sp_update_user_address @username = 'clark001', @new_address = 'Route Royal Road, Cascavelle Mauritius'		--valid username with null address
EXEC sp_update_user_address @username = 'kellyR1234', @new_address = 'Raisin Street, St Pierre'		--valid username with null address
EXEC sp_update_user_address @username = 'emma_w', @new_address = 'Invalid Road, Morc Blueprint Surinam, MU'		--valid username with null address
EXEC sp_update_user_address @username = 'adwdwda', @new_address = 'Bagasse Street, St Pierre'		--invalid username and new address

--17. SPsp_update_user_username
EXEC sp_update_user_username @old_username = 'mikeB', @new_username = 'mitchBrown'		--valid case
--invalid
EXEC sp_update_user_username @old_username = 'mikeB', @new_username = 'michelleBrwn';		--invalid username does not exists
EXEC sp_update_user_username @old_username = 'alice_smith', @new_username = 'kellyR1234';		--invalid new username already exists


--EXEC VIEW sp_GetCustomerOrders
EXEC sp_GetCustomerOrders @username = 'kellyR1234'		--valid case
EXEC sp_GetCustomerOrders @username = 'kellyR4321'		--invalid cas, username not exists