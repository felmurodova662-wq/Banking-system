--creating database.
create database DA_Bank;

use DA_Bank;

--creating schema.
create schema CoreBanking authorization dbo;
create schema DigBankNPayment authorization dbo;
create schema LoansCredits authorization dbo;
create schema ComplianceRiskManag authorization dbo;
create schema HumanResourcePayroll authorization dbo;
create schema InvestmentsTreasury authorization dbo;
create schema InsuranceSecurity authorization dbo;
create schema MerchantServices authorization dbo;

----------------------------------------------------------------------------------------------------------------
                                        --creating tables.
--table1
create table CoreBanking.Customers (CustomerID int primary key , Fullname varchar(100) not null, Date_birth date, Email varchar(50) not null unique, Phone_number varchar(50), Address varchar(50), NationalID int, TaxID int, Employment_status varchar(50), Annual_income decimal(18, 2), CreatedAT date not null, Updatedat date not null);
alter  table CoreBanking.Customers
alter column Email varchar(50) not null;

--table2
create table CoreBanking.Accounts (AccountID int primary key, CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), Account_type varchar(50), Balance decimal(18, 2) not null, Currency char(3), Status varchar(50), BranchID int not null  , Created_date date);
alter table CoreBanking.Accounts 
add constraint fk_Branches_Accounts
foreign key (BranchID)
references CoreBanking.Branches(BranchID);

--table3
create table CoreBanking.Transactions (TransactionID int primary key, AccountID int not null foreign key references CoreBanking.Accounts(AccountID), Transaction_type varchar(50), Amount decimal(18, 2), Currency char(3), Date date, Status varchar(50),   Reference_no varchar(50) not null unique);

--table4
create table CoreBanking.Branches (BranchID int primary key, Branch_name varchar(50), Address varchar(50), City varchar(50), State varchar(50), Country varchar(50), ManagerID int not null , Contact_number varchar(50));

alter table CoreBanking.Branches
add constraint FK_CoreBanking_Branchesle_HumanResourcePayroll_Departments
foreign key (ManagerID)
references HumanResourcePayroll.Departments(ManagerID);

--table5 
create table CoreBanking.Employees (EmployeeID int primary key, BranchID int not null foreign key references CoreBanking.Branches(BranchID), Fullname varchar(100)not null, Position varchar(50), DepartmentID int not null , Salary decimal(10, 2), Hire_date date not null, Status varchar(50));

alter table CoreBanking.Employees
add constraint fk_CoreBanking_Employees_HumanResourcePayroll_Departments
foreign key (DepartmentID)
references HumanResourcePayroll.Departments(DepartmentID)

--table6
create table DigBankNPayment.CreditCards (CardID int primary key, CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), Card_number int not null, Card_type varchar(50), CVV char(4), Expiry_date date, Limit decimal(18, 2), Status varchar(50));

--table7
create table DigBankNPayment.CreditCardTransactions (TransactionID int primary key, CardID int not null foreign key references DigBankNPayment.CreditCards(CardID), Merchant varchar(50), Amount decimal(18, 2), Currency char(3),Date date, Status varchar(50));

--table8
create table DigBankNPayment.OnlineBankingUsers (UserID int primary key, CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), User_name varchar(50), Password_hash varchar(16), Last_login datetime); 

--table9
create table DigBankNPayment.BillPayments (PaymentID int primary key, CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), Biller_name varchar(50), Amount decimal(18, 2), Date date, Status varchar(50));

--table10
create table DigBankNPayment.MobileBankingTransactions (TransactionID int primary key, CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), DeviceID int, App_version varchar(50), Transaction_type varchar(50),Amount decimal(18, 2), Date date);

--table11
create table LoansCredits.Loans (LoanID int not null primary key, CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), Loan_type varchar(50), Amount decimal(18, 2), Interest_rate decimal(5, 4), Start_date date, End_date date, Status varchar(50));

--table12
create table LoansCredits.LoanPayments (PaymentID int primary key, LoanID int not null foreign key references LoansCredits.Loans(LoanID), Amount_paid decimal(18, 2), Payment_date date, Remaining_balance decimal(18, 2));

--table13
create table LoansCredits.CreditScores (CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), Credit_score  int, Updatedat date not null );

--table14
create table LoansCredits.DebtCollection (DebtID int primary key, CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), Amount_due decimal(18, 2), Due_date date, Collector_assigned int);

--table15
create table ComplianceRiskManag.KnowYourCustomer (KYCID int primary key,CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), Document_type varchar(50), Document_number int, Verified_by int );

--table16
create table ComplianceRiskManag.FraudDetection (FraudID int primary key,CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), TransactionID int, Risk_level varchar(50), Reported_date date);
alter table ComplianceRiskManag.FraudDetection
add constraint fk_Transaction_FraudDetection
foreign key (TransactionID)
references CoreBanking.Transactions(TransactionID)

--table17 
create table ComplianceRiskManag.AntiMoneyLaundering (CaseID int primary key,CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), Case_type varchar(50), Status varchar(50), InvertigatorID int);

--table18
create table ComplianceRiskManag.RegulatoryReports (ReportID int primary key, Report_type varchar(50), Submission_date date)

--table19
create table HumanResourcePayroll.Departments (DepartmentID int   , Department_name varchar(50), ManagerID int not null unique,
primary key (DepartmentID, ManagerID));

alter table  HumanResourcePayroll.Departments 
alter column DepartmentID int not null;

alter table  HumanResourcePayroll.Departments 
add constraint uq_HumanResourcePayroll_Departments 
unique (DepartmentID);

--table20
create table HumanResourcePayroll.Salaries (SalaryID int primary key, EmployeeID int not null foreign key references CoreBanking.Employees(EmployeeID), Base_salary decimal(18,2), Bonus decimal(18, 2), Deductions decimal(18, 2), Payment_date date);

--table21
create table HumanResourcePayroll.EmployeeAttendance (AttendanceID int primary key,EmployeeID int not null foreign key references CoreBanking.Employees(EmployeeID),  Checkin_time datetime, Checkout_time datetime, Total_hours decimal(10, 2));

--table22
create table InvestmentsTreasury.Investments (InvestmentID int primary key,CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), Investment_type varchar(50), Amount decimal(18,2), Return_onInvestment decimal(5, 2), Maturity_date date );

--table23
create table InvestmentsTreasury.StockTradingAccounts (AccountID int primary key, CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), Brokerage_firm varchar(50), Total_inverted decimal(18, 2), current_value decimal(18, 2));

--table24
create table InvestmentsTreasury.ForeignExchange (FXID int primary key, CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), Current_pair nvarchar(20), Exchange_rate decimal(10, 6), Amount_exchanged decimal(18, 2));

--table25
create table InsuranceSecurity.InsurancePolicies (PolicyID int primary key,  CustomerID int not null foreign key references CoreBanking.Customers(CustomerID), Insurance_type varchar(50), Premium_amount decimal(18, 2),  Coverage_amount decimal(18, 2));

--table26
create table InsuranceSecurity.Claims (ClaimID int primary key, PolicyID int not null foreign key references InsuranceSecurity.InsurancePolicies(PolicyID), Claim_amount decimal(18, 2), Status varchar(50), Filed_date date);

--table27
 create table InsuranceSecurity.UserAccessLogs (LogID int primary key, UserID int, Action_type varchar(50), Time_stamp datetime);

 alter table InsuranceSecurity.UserAccessLogs 
 add constraint fk_InsuranceSecurity_UserAccessLogs_DigBankNPayment_OnlineBankingUsers
 foreign key (UserID)
 references DigBankNPayment.OnlineBankingUsers(UserID);

 --table28
 create table InsuranceSecurity.CyberSecurityIncidents (IncidentID int primary key, Affected_system nvarchar(50) not null, Reported_date date, Resolution_status varchar(50));

 --table29
 create table MerchantServices.Merchants (MerchantID int primary key, Merchant_name varchar(50), Industry varchar(50), Location nvarchar(100), CustomerID int not null foreign key  references CoreBanking.Customers(CustomerID));

 --table30
 create table MerchantServices.MerchantTransactions (TransactionID int primary key, MerchantID int not null foreign key references  MerchantServices.Merchants(MerchantID), Amount decimal(18, 2), Payment_method varchar(50), Date date);

 ----------------------------------------------------------------------------------------------------------------
                                      --inserting values.

 --inserting values into  CoreBanking.Customers.
SET NOCOUNT ON;

WITH Numbers AS (
    SELECT TOP (1500)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a CROSS JOIN sys.objects b
),
FirstNames AS (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id, Name
    FROM (VALUES
    ('aziz'),('jasur'),('bekzod'),('shoxrux'),('dilshod'),
    ('alisher'),('oybek'),('sardor'),('temur'),('diyor'),
    ('malika'),('dilnoza'),('gulnoza'),('zarina'),('nigora'),
    ('madina'),('shahnoza'),('feruza'),('laylo'),('aziza')
    ) fn(Name)
),
LastNames AS (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id, Name
    FROM (VALUES
    ('karimov'),('toshmatov'),('rakhimov'),('ismoilov'),('abdullayev'),
    ('yusupov'),('saidov'),('qodirov'),('ergashev'),('nazarov'),
    ('aliyev'),('rasulov'),('mamatov'),('usmonov'),('salimov')
    ) ln(Name)
)

INSERT INTO CoreBanking.Customers
(
    CustomerID,
    Fullname,
    Date_birth,
    Email,
    Phone_number,
    Address,
    NationalID,
    TaxID,
    Employment_status,
    Annual_income,
    CreatedAT,
    Updatedat
)
SELECT 
    n,

    CONCAT(
        UPPER(LEFT(fn.Name,1)) + LOWER(SUBSTRING(fn.Name,2,LEN(fn.Name))), ' ',
        UPPER(LEFT(ln.Name,1)) + LOWER(SUBSTRING(ln.Name,2,LEN(ln.Name)))
    ),

    DATEADD(YEAR, - (18 + (n % 47)), GETDATE()),

    CONCAT(fn.Name, '.', ln.Name, n, '@gmail.com'),

    CONCAT('+99890', RIGHT('0000000' + CAST(n AS VARCHAR), 7)),

    CONCAT('Street ', n, ', Tashkent'),

    100000000 + n,
    200000000 + n,

    CASE 
        WHEN n % 5 = 0 THEN 'Unemployed'
        WHEN n % 5 = 1 THEN 'Employed'
        WHEN n % 5 = 2 THEN 'Self-Employed'
        WHEN n % 5 = 3 THEN 'Student'
        ELSE 'Retired'
    END,

    CAST(2000 + (n % 50) * 500 AS DECIMAL(18,2)),

    DATEADD(DAY, - (n % 365), GETDATE()),
    GETDATE()

FROM Numbers n
JOIN FirstNames fn ON fn.id = ((n.n - 1) % 20) + 1
JOIN LastNames ln ON ln.id = ((n.n - 1) % 15) + 1;

--inserting values into  HumanResourcePayroll.Departments.
INSERT INTO HumanResourcePayroll.Departments
(DepartmentID, Department_name, ManagerID)
VALUES
(1, 'Operations', 101),
(2, 'Retail Banking', 102),
(3, 'Corporate Banking', 103),
(4, 'Risk Management', 104),
(5, 'IT', 105),
(6, 'Finance', 106);

--inserting values into CoreBanking.Branches
INSERT INTO CoreBanking.Branches
(BranchID, Branch_name, Address, City, State, Country, ManagerID, Contact_number)
VALUES
(1, 'Tashkent Main', 'Amir Temur St 1', 'Tashkent', 'Tashkent', 'Uzbekistan', 101, '+998901111111'),
(2, 'Samarkand Branch', 'Registan St 5', 'Samarkand', 'Samarkand', 'Uzbekistan', 102, '+998902222222'),
(3, 'Bukhara Branch', 'Center St 10', 'Bukhara', 'Bukhara', 'Uzbekistan', 103, '+998903333333'),
(4, 'Fergana Branch', 'Independence St 7', 'Fergana', 'Fergana', 'Uzbekistan', 104, '+998904444444');

--inserting values into CoreBanking.Accounts.
SET NOCOUNT ON;

WITH Numbers AS (
    SELECT TOP (2000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a CROSS JOIN sys.objects b
)
INSERT INTO CoreBanking.Accounts
(
    AccountID,
    CustomerID,
    Account_type,
    Balance,
    Currency,
    Status,
    BranchID,
    Created_date
)
SELECT
    n,

    ((n - 1) % 1500) + 1,

    CASE 
        WHEN n % 3 = 0 THEN 'Savings'
        WHEN n % 3 = 1 THEN 'Checking'
        ELSE 'Business'
    END,

    CASE 
        WHEN n % 200 = 0 THEN 500000 + (n * 10)
        ELSE 1000 + (n % 5000)
    END,

    'USD',

    CASE 
        WHEN n % 10 = 0 THEN 'Inactive'
        ELSE 'Active'
    END,

    ((n - 1) % 4) + 1,

    DATEADD(DAY, - (n % 365), GETDATE())

FROM Numbers;

--inserting values into LoansCredits.Loans.
WITH Numbers AS (
    SELECT TOP (500)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)
INSERT INTO LoansCredits.Loans
(
    LoanID,
    CustomerID,
    Loan_type,
    Amount,
    Interest_rate,
    Start_date,
    End_date,
    Status
)
SELECT
    n,

    ((n - 1) % 200) + 1,

    CASE 
        WHEN n % 3 = 0 THEN 'Mortgage'
        WHEN n % 3 = 1 THEN 'Personal'
        ELSE 'Auto'
    END,

    5000 + (n * 100),

    CAST(0.05 + (n % 5) * 0.01 AS DECIMAL(5,4)),

    DATEADD(DAY, - (n % 1000), GETDATE()),
    DATEADD(YEAR, 5, GETDATE()),

    CASE 
        WHEN n % 4 = 0 THEN 'Closed'
        ELSE 'Active'
    END

FROM Numbers;

--inserting values into CoreBanking.Transactions.
WITH Numbers AS (
    SELECT TOP (8000)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a CROSS JOIN sys.objects b
)
INSERT INTO CoreBanking.Transactions
(
    TransactionID,
    AccountID,
    Transaction_type,
    Amount,
    Currency,
    Date,
    Status,
    Reference_no
)
SELECT
    n,

    ((n - 1) % 2000) + 1,

    CASE 
        WHEN n % 2 = 0 THEN 'Debit'
        ELSE 'Credit'
    END,

    CASE 
        WHEN n % 50 = 0 THEN 15000 + (n * 2)
        ELSE 50 + (n % 5000)
    END,

    'USD',

    DATEADD(DAY, - (n % 30), GETDATE()),

    CASE 
        WHEN n % 20 = 0 THEN 'Failed'
        ELSE 'Completed'
    END,

    CONCAT('REF', n)

FROM Numbers;

--inserting values into ComplianceRiskManag.FraudDetection.
WITH Numbers AS (
    SELECT TOP (50)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)
INSERT INTO ComplianceRiskManag.FraudDetection
(
    FraudID,
    CustomerID,
    TransactionID,
    Risk_level,
    Reported_date
)
SELECT
    n,

    ((n - 1) % 1500) + 1,

    ((n - 1) % 8000) + 1,

    CASE 
        WHEN n % 3 = 0 THEN 'High'
        WHEN n % 3 = 1 THEN 'Medium'
        ELSE 'Low'
    END,

    GETDATE()

FROM Numbers;
----------------------------------------------------------------------------------------------------------------
select * from CoreBanking.Customers;
select * from HumanResourcePayroll.Departments;
select * from CoreBanking.Branches;
select * from CoreBanking.Accounts;
select * from LoansCredits.Loans;
select * from  CoreBanking.Transactions;
select * from  ComplianceRiskManag.FraudDetection;

                                               --KPIs

--•1	Top 3 Customers with the Highest Total Balance Across All Accounts
;with TotalBalanceByCustomers as (
					select AccountID,
				           CustomerID,
					       sum(Balance) as total_balance
					from CoreBanking.Accounts
					group by AccountID,CustomerID)
select top 3 cc.Fullname,
             t.total_balance
from TotalBalanceByCustomers as t 
join CoreBanking.Customers as cc
	on t.CustomerID = cc.CustomerID
order by t.total_balance desc;

--•2	Customers Who Have More Than One Active Loan
select cc.CustomerID,
       cc.Fullname,
       count(ll.LoanID) as Loan_count
from LoansCredits.Loans as ll
join CoreBanking.Customers as cc
	on ll.CustomerID = cc.CustomerID
where ll.Status like 'Active'
group by  cc.CustomerID, cc.Fullname
having count(ll.LoanID)>1;

--•3	Transactions That Were Flagged as Fraudulent                                                
select cc.Fullname, 
       ct.TransactionID,
	   ct.Amount,
	   cf.Risk_level,
	   cf.Reported_date
from CoreBanking.Transactions as ct
join ComplianceRiskManag.FraudDetection as cf
	on ct.TransactionID = cf.TransactionID
join CoreBanking.Customers as cc
	on cf.CustomerID = cc.CustomerID;


--•4	Total Loan Amount Issued Per Branch
select cb.Branch_name,
       sum(ll.Amount) as total_loan
from LoansCredits.Loans as ll
join CoreBanking.Accounts as ca
	on ll.CustomerID = ca.CustomerID
join CoreBanking.Branches as cb
	on cb.BranchID = ca.BranchID
group by cb.Branch_name;

--•5	Customers who made multiple large transactions (above $10,000) within a short time frame (less than 1 hour apart)
select distinct cc.CustomerID
from CoreBanking.Transactions ct1
join CoreBanking.Transactions ct2
    on ct1.AccountID = ct2.AccountID
   and ct1.TransactionID <> ct2.TransactionID
   and ct1.Date < ct2.Date
   join CoreBanking.Accounts ca
    on ct1.AccountID = ca.AccountID
join CoreBanking.Customers cc
    on ca.CustomerID = cc.CustomerID
   where  ct1.Amount > 10000
   and ct2.Amount > 10000
   and datediff(minute, ct1.date, ct2.date) < 60;


   --•6	Customers who have made transactions from different countries within 10 minutes, a common red flag for fraud.
select distinct
    c.CustomerID,
    c.Fullname,
    t1.TransactionID as transactionID1,
    t2.TransactionID as transactionID2,
    t1.date as Time1,
    t2.date as Time2,
    b1.Country as Country1,
    b2.Country as Country2
from CoreBanking.Transactions t1
join CoreBanking.Transactions t2 
    on t1.AccountID = t2.AccountID 
    and t1.TransactionID <> t2.TransactionID
join CoreBanking.Accounts a 
on t1.AccountID = a.AccountID
join CoreBanking.Customers c
on a.CustomerID = c.CustomerID
join CoreBanking.Branches b1
on a.BranchID = b1.BranchID
join CoreBanking.Branches b2 
on a.BranchID = b2.BranchID
where b1.Country <> b2.Country
  and t1.Date < t2.Date
  and datediff(minute, t1.Date, t2.Date) <= 10;
