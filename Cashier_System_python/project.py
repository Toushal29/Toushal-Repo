import datetime as dt

x = dt.datetime.now()
y_today = x.strftime("%x")
y_date_time = x.strftime("%x"),x.strftime("%X")

class Cashier_system:
    def Options(self):
        print()
        print("┌────────────────────── FlowMart ─────────────────────┐")
        print("│           Your Store Management Menu                │")
        print("├─────┬───────────────────────────────────────────────┤")
        print("│ No. │ Option                                        │")
        print("├─────┼───────────────────────────────────────────────┤")
        print("│ 1   │  a    --> Add Product                         │")
        print("│ 2   │  u    --> Update Price                        │")
        print("│ 3   │  s    --> Sale                                │")
        print("│ 4   │  ls   --> Last Sale Receipt                   │")
        print("│ 5   │  tr   --> Today Report                        │")
        print("│ 6   │  d    --> Product Details                     │")
        print("│ 7   │  r    --> Refund                              │")
        print("├─────┴───────────────────────────────────────────────┤")
        print("│ Press ENTER to exit                                 │")
        print("└─────────────────────────────────────────────────────┘")
        
        user_option = input("> Enter your option: ").lower()

        if user_option == "a" or user_option == "add product":
            print("┌" + "─" * 53 + "┐")
            print("│" + " " * 21 + "ADD PRODUCT" + " " * 21 + "│")
            print("└" + "─" * 53 + "┘")
            self.Add_product()
        elif user_option == "u" or user_option == "update price":
            print("┌" + "─" * 53 + "┐")
            print("│" + " " * 19 + "UPDATE PRODUCT" + " " * 20 + "│")
            print("└" + "─" * 53 + "┘")
            self.Update_price()
        elif user_option == "s" or user_option == "sale":
            print("┌" + "─" * 53 + "┐")
            print("│" + " " * 24 + "SALE" + " " * 25 + "│")
            print("└" + "─" * 53 + "┘")
            self.Sale()
        elif user_option == "ls" or user_option == "last sale receipt":
            print("┌" + "─" * 53 + "┐")
            print("│" + " " * 18 + "LAST SALE RECEIPT" + " " * 18 + "│")
            print("└" + "─" * 53 + "┘")
            self.Last_sale()
        elif user_option == "tr" or user_option == "today report":
            print("┌" + "─" * 53 + "┐")
            print("│" + " " * 20 + "TODAY REPORT" + " " * 21 + "│")
            print("└" + "─" * 53 + "┘")
            self.Today_report()
        elif user_option == "d" or user_option == "product details":
            print("┌" + "─" * 53 + "┐")
            print("│" + " " * 18 + "PRODUCTS DETAILS" + " " * 19 + "│")
            print("└" + "─" * 53 + "┘")
            self.Products_details()
        elif user_option == "r" or user_option == "refund":
            print("┌" + "─" * 53 + "┐")
            print("│" + " " * 21 + "REFUND MODE" + " " * 21 + "│")
            print("└" + "─" * 53 + "┘")
            self.Refund()
        elif user_option != "":
            print("┌" + "─" * 53 + "┐")
            print("│" + "INVALID option entered." + " " * 30 + "│")
            print("│" + "Select a valid option: a, u, s, ls, tr, d, r" + " " * 9 + "│")
            print("└" + "─" * 53 + "┘")
            return self.Options()
        else:
            print("┌" + "─" * 53 + "┐")
            print("│" + " " * 12 + "Application ENDED and CLOSED" + " " * 13 + "│")
            print("└" + "─" * 53 + "┘")
            exit()


    def Add_product(self):
        try:                                                                                        #tries to open file
            file_product = open("product_file.txt", "a+")                                           #a+ : open file in read and write/append mode
            file_product.seek(0)
            products = file_product.readlines()

            user_add_barcode = (input("> Enter a product barcode or press ENTER to EXIT: "))
            if user_add_barcode == "":                                                              #check if user input is empty or contain alphabets
                print("\n"+"ADD operation ENDED.")
                file_product.close()
                return Cashier_system.Options(self)
            elif user_add_barcode.isnumeric() == False:                
                print("\n"+"Barcode should be only numeric. ADD operation ABORTED.")
                file_product.close()
                return Cashier_system.Options(self)

            for line in products:
                try:                                                                                #check for corrupt data in file to compare
                    product_list = eval(line.strip())                                                       #convert lines of list into list
                    if int(user_add_barcode) == product_list[0]:
                        print("Barcode ALREADY EXISTS. Product name: " + product_list[1])                    #exit if user adds an existing barcode
                        file_product.close()
                        return Cashier_system.Options(self)
                except (ValueError, SyntaxError):                                                   #raise error if there is a mistake in the file
                    print("ERROR IN READING PRODUCT DETAILS IS FILE. PRODUCT DATA IN FILE IS CORRUPT.")
                    file_product.close()
                    return Cashier_system.Options(self)

            user_add_name = input("> Enter product name OR press ENTER to ABORT Add: ")
            if user_add_name == "":
                print("ADD operation ABORTED.")
                file_product.close()
                return Cashier_system.Options(self)
            
            while True:
                user_add_price = input("> Enter product price OR press ENTER to ABORT Add: ")
                if user_add_price == "":
                    print("ADD operation ABORTED.")
                    file_product.close()
                    return Cashier_system.Options(self)
                try:                                                                                #check for -ve price input or any alphabet input
                    if float(user_add_price) < 0:
                        print("Price cannot be negative(-ve).")
                        continue
                    break
                except ValueError:
                    print("Price should be numeric(1234).")
                    
            details = [int(user_add_barcode), user_add_name, float(user_add_price)]                 #create new product
            str_details = str(details)+"\n"
            file_product.write(str_details)                                                         #write/append in file
            print("")
            print("Product Added: ", details)

            file_product.close()
            return Cashier_system.Options(self)

        except(IOError):
            print("Missing File(s).")
            return Cashier_system.Options(self)


    def Sale(self):
        try:                                                                                    #tries to open files
            file_product = open("product_file.txt","r")
            file_product.seek(0)
            file_save = open("sale_file.txt", "a")
            products = file_product.readlines()
            
            receipt_time = [[x.strftime("%x"),x.strftime("%X")]]                                #datetime of making the sale is recorded in a list

            user_sale_barcode = input("> Enter product barcode or press ENTER to END Sale: ")
            if user_sale_barcode == "":                                                         #checks if input is "" so that it end the sale early
                file_save.close()
                file_product.close()
                return Cashier_system.Options(self)
            
            sale_end = False
            Total = 0

            while sale_end == False:
                product_exist = False                                                           #assuming no product exists
                if user_sale_barcode.isnumeric() == False:                                      #check fi input is numeric
                    print("Barcode must be numeric(e.g 1234).")
                    user_sale_barcode = input("> Enter product barcode or press ENTER to END Sale: ")
                    if user_sale_barcode == "":
                        sale_end = True
                    continue

                for lines in products:
                    try:                                                                        #raise error if reading from product file is not possible
                        ind_prod = eval(lines)                                                  #convert lines of list into list
                        if int(user_sale_barcode) == ind_prod[0]:
                            product_exist = True                                                #product found in file

                            user_sale_qty = input("> Enter qty or press ENTER if prod_qty is 1: ")
                            if user_sale_qty == "":
                                user_sale_qty = 1
                            elif user_sale_qty.isnumeric() == True:                                       #check if quantity is numeric
                                user_sale_qty = int(user_sale_qty)
                                if user_sale_qty < 1:
                                    print("Quantity must be greater 0.")
                                    continue
                            else:
                                print("Quantity must be +ve and numeric.")
                                continue

                            sum = 0                                                                     #initialize sum = 0 for each product
                            sum = ind_prod[2] * user_sale_qty                                           #calculate the sum of the product= prod[index price] * qty
                            Total += sum
                            cart_list = [user_sale_barcode, ind_prod[1], ind_prod[2], user_sale_qty, float(sum)]
                            receipt_time.append(cart_list)                                                          #append list to list
                            user_sale_barcode = input("> Enter product barcode or press ENTER to END SALE: ")         #loop repeat
                            
                            if user_sale_barcode == "":
                                sale_end = True
                            break
                    except(ValueError, SyntaxError, IndexError):
                        print("Error in processing input barcode: ", user_sale_barcode)
                        break
                if product_exist == False:                                                                  #if no product mattch on that barcode
                    print("Barcode not found.",end=" ")
                    user_sale_barcode = input("> Enter product barcode or press ENTER to END Sale: ")
                    if user_sale_barcode == "":
                        sale_end = True

            print("Total Amount = Rs %0.2f" % Total)

            remainig = Total
            Total_cash = 0
            Cash = 0
            change = 0.00

            if sale_end == True:
                while remainig > 0:
                    Cash = input("> Enter cash amount: ")
                    try:
                        if Cash == "":                          #if input cash empty, exact amount paid
                            Cash = remainig                     #cash is == to total/remaining
                            Total_cash += Cash
                            change = 0.00
                            print("Exact amount of cash paid.")                    
                            break

                        else:
                            Cash = float(Cash)
                            if Cash < 0:
                                print("Cash cannot be -ve.")
                                continue                                                #skip back to top input
                            Total_cash += Cash                                          #tracks total cash given
                            if Cash < remainig:                     
                                remainig -= Cash
                                print("Remaining Rs %0.2f" % remainig)
                            else:
                                change = Cash - remainig                                #if cash > remaining
                                remainig = 0
                                print("Return Rs %0.2f" % change)
                                break
                    except(ValueError):
                        print("Invalid cash amount entered.")
                        continue

            cash_mgmt = [float("%0.2f" % Total), float("%0.2f" % Total_cash), float("%0.2f" % change)]          #replace element in list
            receipt_time.append(cash_mgmt)

            receipt_str = str(receipt_time) + "\n"                                                              #convert list to str
            file_save.write(receipt_str)                                                                        #write/append to file
            
            file_save.close()
            file_product.close()

            Cashier_system.Last_sale(self)      ###################################################################

            return Cashier_system.Options(self)
                
        except(IOError):
            print("Missing Read File, File NOT found.")
            return Cashier_system.Options(self)



    def Update_price(self):
        try:
            file_product = open("product_file.txt", "r+")
            product = file_product.readlines()

            user_update_barcode = input("> Enter a barcode or press ENTER to END: ")
            if user_update_barcode == "":
                print("Update operation ENDED.")
                file_product.close()
                return Cashier_system.Options(self)

            if user_update_barcode.isnumeric() == False:
                print("Barcode should be numeric. UPDATE operation ABORTED.")
                file_product.close()
                return Cashier_system.Options(self)
            
            exists = False
            updated_product = []
            for line in product:
                prod_list = eval(line)
                if int(user_update_barcode) == prod_list[0]:
                    exists = True
                    user_update_price = input("> Enter a new price or press ENTER to END: ")

                    if user_update_price == "":
                        print("Update operation CANCELLED.")
                        file_product.close()
                        return Cashier_system.Options(self)
                    
                    try:
                        user_update_price = float(user_update_price)
                    except ValueError:
                        print("Price must be a valid number. UPDATE CANCELLED.")
                        file_product.close()
                        return Cashier_system.Options(self)
                        
                    if user_update_price <= 0:
                        print("Price cannot be negative or zero. UPDATE CANCELLED.")
                        file_product.close()
                        return Cashier_system.Options(self)
     
                    prod_list[2] = user_update_price
                    updated_product.append(str(prod_list) + "\n")
                    print("Update Successful: ", prod_list)

                else:
                    updated_product.append(line)
            
            if exists == False:
                print("Barcode not found.")

            file_product.seek(0)
            file_product.writelines(updated_product)
            file_product.truncate()

            file_product.close()
            return Cashier_system.Options(self)

        except(FileNotFoundError):
            print("Missing Read File, File NOT found.")
            return Cashier_system.Options(self)



    def Last_sale(self):                                                        #print latest sale receipt
        try:                                                                    #tries open file
            file_save = open("sale_file.txt","r")
            lines = file_save.readlines()

            try:                                                                #raise error if line is corrupt
                last_line = eval(lines[-1].strip())
            except(ValueError, SyntaxError, IndexError):
                print("Error in reading sale details from file.")
                file_save.close()
                return Cashier_system.Options(self)

            print("┌" + "─" * 53 + "┐")
            print("│" + " " * 18 + "FlowMart Receipt" + " " * 19 + "│")
            print("├" + "─" * 53 + "┤")
            print("│ {:<20}{:<32}│".format(str(last_line[0][0]), str(last_line[0][1])))
            print("├" + "─" * 53 + "┤")

            for items in last_line[1:-1]:
                barcode = str(items[0])[:10]
                name = str(items[1])[:42]
                price = float(items[2])
                qty = str(items[3])
                total = float(items[4])
                print("│ {:<10}{:<42}│".format(barcode, name))
                print("│ {:>19} @ea *{:>3} {:>23}│".format("Rs " + "{:.2f}".format(price), qty, "Rs " + "{:.2f}".format(total)))

            print("├" + "─" * 53 + "┤")
            print("│ {:<12}{:>13.2f}{:>1}│".format("Total                               Rs", float(last_line[-1][0]), ""))
            print("│ {:<12}{:>13.2f}{:>1}│".format("Cash                                Rs", float(last_line[-1][1]), ""))
            print("│ {:<12}{:>13.2f}{:>1}│".format("Change                              Rs", float(last_line[-1][2]), ""))
            print("└" + "─" * 53 + "┘")

            file_save.close()
            return Cashier_system.Options(self)

        except(IOError):                                                           #raise error if missing file
            print("Missing Read File, File NOT found.")
            return Cashier_system.Options(self)



    def Today_report(self):                                 #print today's sale details
        try:                                                #tries to open file, raise error if file missing
            sale_file = open("sale_file.txt", "r")
            refund_file = open("refund_file.txt", "r")
            sales_lines = sale_file.readlines()
            refund_lines = refund_file.readlines()

            Total_cash = 0
            sale_count = 0
            for sale in sales_lines:
                try:                                            #raise error if data line is corrupt in file during reading
                    if sale.strip():
                        sale = eval(sale.strip())
                except(ValueError, SyntaxError, IndexError):
                    print("An error has occur in sale file, a data line is corrupt.")
                    sale_file.close()
                    refund_file.close()
                    return Cashier_system.Options(self) 
                if sale[0][0] == y_today:
                    if sale[-1][0] != 0:
                        Total_cash += sale[-1][0]
                        sale_count += 1

            refund_cash = 0
            refund_count = 0
            for refund in refund_lines:
                try:                                            #raise error if data line is corrupt in file during reading
                    if refund.strip():
                        refund = eval(refund.strip())
                except(ValueError, SyntaxError, IndexError):
                    print("An error has occur in sale file, a data line is corrupt.")
                    sale_file.close()
                    refund_file.close()
                    return Cashier_system.Options(self) 
                if refund[0] == y_today:
                    refund_cash += refund[5]
                    refund_count += 1

            net_total = Total_cash - refund_cash

            print("Today Sale Report: Rs",Total_cash)
            print("Today sale made: ", sale_count)
            print("Today Refund Total Rs", refund_cash)
            print("Total refund made: ", refund_count)
            print("Net Sale Rs ", net_total)

            sale_file.close()
            refund_file.close()
            return Cashier_system.Options(self)

        except(IOError):
            print("Missing Read File, File NOT found.")
            return Cashier_system.Options(self)
    


    def Products_details(self):                         #print all product details
        try:                                                    #tries to open file, raise error if file missing
            file_product = open("product_file.txt","r")
            product = file_product.readlines()

            for lines in product:
                try:                                                #raise error if data in file is corrupt
                    prod_details = eval(lines.strip())
                except(ValueError, SyntaxError, IndexError):
                        print("Error in reading sale details from file. Line(s) in file is corrupt.")
                        file_product.close()
                        return Cashier_system.Options(self)
                barcode, name, price = prod_details
                print("{:<15}{:<30}Rs {:>7.2f}".format(barcode, name, price))
            file_product.close()
            return Cashier_system.Options(self)

        except IOError:
            print("Missing Read File, File NOT found.")
            return Cashier_system.Options(self)
        
    

    def Refund(self):
        try:                                                                    #tries open file, raise error if note xists
            file_save = open("product_file.txt","r")
            file_save.seek(0)
            file_refund = open("refund_file.txt","a")
            file_product = file_save.readlines()

            user_refund_barcode = input(">Enter Barcode to refund or press ENTER to END: ")
            if user_refund_barcode == "":
                file_save.close()
                file_refund.close()
                print("REFUND operation ENDED.")
            elif user_refund_barcode.isnumeric() == False:
                file_save.close()
                file_refund.close()
                print("Barcode should be numeric.")
            else:
                product_found = False
                for product in file_product:
                    try:                                                        #raise error if details in product file is corrupt
                        product = eval(product.strip())
                    except(ValueError, SyntaxError, IndexError):
                        print("Error in reading sale details from file. Line(s) in file is corrupt.")
                        file_save.close()
                        file_refund.close()
                        return Cashier_system.Options(self)
                    
                    if int(user_refund_barcode) == product[0]:
                        product_found = True

                        user_refund_qty = input("> Enter quantity or press ENTER to END: ")
                        if user_refund_qty == "":
                            print("REFUND operations CANCELLED.")
                            break
                        elif user_refund_qty.isnumeric() == True:
                            user_refund_qty = int(user_refund_qty)
                            if user_refund_qty < 1:
                                print("Quantity must be greater 0.")
                                continue
                        else:
                            print("Quantity must be +ve and numeric.")
                            print("NO REFUND EFFECTED.")
                            continue

                        refund_sum = 0
                        refund_date = x.strftime("%x")
                        refund_sum = product[2] * user_refund_qty

                        refund_list = [refund_date, product[0], product[1], product[2], user_refund_qty, float(refund_sum)]

                        file_refund.write(str(refund_list) + "\n")
                        print("Refund completed. Return Rs", refund_sum)
                        break

                if product_found == False:
                    print("Barcode does not exists in record ", user_refund_barcode)

            file_save.close()
            file_refund.close()
            return Cashier_system.Options(self)

        except(IOError):
            print("An Error has occur.")
            return Cashier_system.Options(self)


if __name__ == "__main__":
    system = Cashier_system()
    system.Options()