--Mortgage_Project files
--Borrower:

CREATE TABLE [dbo].[Borrower_details](
[SSN] [int] NOT NULL,
[Borrower FirstName] [varchar](50) NULL,
[Borrower LastName] [varchar](50) NULL,
[Borrower Email] [varchar](50) NULL,
[Home Phone] [varchar](50) NULL,
[Cell Phone] [varchar](50) NULL,
[Marital Status] [varchar](50) NULL,
[Date of Birth] [datetime] NULL,
[Current Street Address] [varchar](50) NULL,
[City] [varchar](50) NULL,
[State] [varchar](50) NULL,
[Zip] [varchar](50) NULL,
[YearsAtThisAddress] [int] NULL,
[Sex] [varchar](50) NULL,
[Ethnicity] [varchar](50) NULL,
[Race] [varchar](50) NULL
)

--Financial:

CREATE TABLE [dbo].[Financial_details](
[SSN] [int] NOT NULL,
[MonthlyIncome] [varchar](50) NULL,
[Bonuses] [varchar](50) NULL,
[Commission] [varchar](50) NULL,
[OtherIncome] [varchar](50) NULL,
[Rent or Own] [varchar](50) NULL,
[Checking] [int] NULL,
[Savings] [int] NULL,
[RetirementFund] [int] NULL,
[MutualFund] [int] NULL
)


--Loan:

CREATE TABLE [dbo].[Loan_details](
[Loan_ID] [int] NOT NULL,
[SSN] [int] NOT NULL,
[Property_ID] [int] NOT NULL,
[Purpose of Loan] [varchar](50) NULL,
[LoanAmount] [int] NULL,
[Purchase Price] [int] NULL,
[CreditCardAuthorization] [varchar](50) NULL,
[Number of Units] [int] NULL,
[Refferal] [varchar](50) NULL,
[Co-Borrower SSN] [int] NOT NULL,
[Loan Date] [date] not null
)


--	Property:

CREATE TABLE [dbo].[Property_details](
[Property_ID] [int] NOT NULL,
[SSN] [int] NOT NULL,
[Property Usage] [varchar](50) NULL,
[Property City] [varchar](50) NULL,
[Property State] [varchar](50) NULL,
[Property Zip] [int] NULL,
[RealEstateAgentName] [varchar](50) NULL,
[RealEstateAgentPhone] [varchar](50) NULL,
[RealEstateAgentEmail] [varchar](50) NULL
)

--- Insert new data to tables 7+ rows each table 
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (2, 'Sarine', 'Aindrais', 'saindrais1@ted.com', '210-183-4604', '918-434-3652', '17.241.150.144', '1/29/2019', 'Fordem', 'San Antonio', 'Texas', '78220', 1, '30.149.113.10', '9.220.195.251', 'Nicaraguan');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (3, 'Rayshell', 'Galliver', 'rgalliver2@twitpic.com', '626-285-9151', '573-348-8503', '53.149.74.122', '6/11/2019', 'Orin', 'Pasadena', 'California', '91125', 48, '101.7.106.146', '145.19.28.218', 'Cambodian');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (4, 'Daffie', 'Kilty', 'dkilty3@bloomberg.com', '361-929-4099', '415-106-2708', '196.214.225.16', '11/3/2018', 'Crownhardt', 'Corpus Christi', 'Texas', '78475', 44, '40.140.201.100', '223.59.8.218', 'Chippewa');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (5, 'Grete', 'Brouncker', 'gbrouncker4@chicagotribune.com', '215-839-4816', '713-714-6558', '164.33.144.114', '8/5/2018', 'Scofield', 'Philadelphia', 'Pennsylvania', '19146', 14, '55.129.37.199', '194.0.220.143', 'Laotian');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (6, 'Sher', 'Flecknell', 'sflecknell5@t.co', '704-556-7010', '512-524-6825', '214.238.255.198', '3/23/2019', 'Gateway', 'Charlotte', 'North Carolina', '28278', 40, '27.45.164.222', '142.15.0.239', 'Nicaraguan');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (7, 'Marc', 'Bellow', 'mbellow6@newyorker.com', '479-196-2638', '603-443-1406', '104.224.100.27', '3/14/2019', 'Forest Run', 'Fort Smith', 'Arkansas', '72916', 67, '111.213.205.98', '177.203.199.217', 'Nicaraguan');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (8, 'Kimball', 'Collin', 'kcollin7@ycombinator.com', '614-995-6326', '405-470-8189', '219.225.111.94', '10/15/2018', 'Spenser', 'Columbus', 'Ohio', '43210', 67, '227.170.34.41', '204.85.136.70', 'Chinese');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (9, 'Leela', 'Canelas', 'lcanelas8@freewebs.com', '206-199-5882', '720-709-4853', '100.90.148.19', '12/21/2018', 'Anhalt', 'Tacoma', 'Washington', '98424', 43, '235.90.30.209', '88.126.252.74', 'Iroquois');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (10, 'Lula', 'Habershaw', 'lhabershaw9@addtoany.com', '202-841-5634', '202-112-1094', '234.187.176.183', '2/19/2019', 'Beilfuss', 'Washington', 'District of Columbia', '20226', 40, '80.144.59.146', '235.192.52.117', 'Yakama');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (11, 'Kelley', 'Milella', 'kmilellaa@youtu.be', '256-281-6307', '801-123-4315', '157.40.116.34', '12/27/2018', 'Toban', 'Huntsville', 'Alabama', '35895', 41, '57.20.139.162', '180.169.139.222', 'Sri Lankan');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (12, 'Ericka', 'Lintin', 'elintinb@comcast.net', '951-834-3188', '918-325-9941', '23.211.107.34', '12/25/2018', 'Nelson', 'San Bernardino', 'California', '92410', 44, '227.118.235.252', '34.106.37.131', 'Filipino');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (13, 'Odelle', 'Bennedsen', 'obennedsenc@wunderground.com', '646-268-0653', '214-691-0928', '142.5.31.122', '2/3/2019', 'Pankratz', 'New York City', 'New York', '10099', 75, '197.247.225.90', '96.59.220.89', 'American Indian');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (14, 'Orland', 'Alyonov', 'oalyonovd@tinyurl.com', '215-712-3356', '315-402-9668', '19.68.29.101', '3/9/2019', 'Clove', 'Philadelphia', 'Pennsylvania', '19125', 51, '215.229.85.102', '81.10.55.238', 'Indonesian');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (15, 'Krystalle', 'Kubu', 'kkubue@infoseek.co.jp', '718-935-5198', '203-758-3554', '93.82.140.105', '10/25/2018', 'Forest Run', 'Jamaica', 'New York', '11447', 74, '170.126.173.105', '26.147.23.196', 'Ecuadorian');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (16, 'Stormie', 'Rivalant', 'srivalantf@addtoany.com', '813-756-4577', '281-983-9254', '9.12.77.125', '1/2/2019', 'Aberg', 'Tampa', 'Florida', '33647', 89, '45.59.220.250', '254.209.244.116', 'Comanche');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (17, 'Kaine', 'Greaves', 'kgreavesg@ning.com', '360-675-0472', '304-381-1376', '152.88.107.118', '6/3/2019', 'Westend', 'Vancouver', 'Washington', '98682', 13, '61.5.108.126', '138.95.219.198', 'Paiute');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (18, 'Donnamarie', 'Millhouse', 'dmillhouseh@blogs.com', '860-327-8854', '801-179-5598', '107.2.64.193', '1/26/2019', 'Mariners Cove', 'Hartford', 'Connecticut', '06120', 96, '132.44.228.147', '0.42.74.196', 'Creek');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (19, 'Scotty', 'Mosedale', 'smosedalei@bandcamp.com', '612-505-7054', '314-361-4958', '163.4.192.202', '3/28/2019', 'Forest Dale', 'Minneapolis', 'Minnesota', '55436', 51, '185.221.215.209', '197.46.20.201', 'Puerto Rican');
insert into BORROWER_DETAILS(SSN, [Borrower FirstName], [Borrower LastName], [Borrower Email], [Home Phone], [Cell Phone], [Marital Status], [Date of Birth], [Current Street Address], City, State, Zip, YearsAtThisAddress, Sex, Ethnicity, Race) values (20, 'Amalita', 'Deshorts', 'adeshortsj@so-net.ne.jp', '813-138-5640', '915-662-0003', '13.180.161.251', '5/8/2019', 'Forest Run', 'Clearwater', 'Florida', '33758', 74, '233.120.94.111', '242.21.230.151', 'Bangladeshi');


Select * From [dbo].[Borrower_details]

-- for Financial_details table rows

insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (422-33-9814, 85, 35, 56, 83, 'Rent', 6349, 6035, 11980, 59856);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (359-08-6247, 96, 28, 56, 16, 'Rent', 5695, 6513, 11430, 50631);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (654-33-0577, 60, 56, 85, 95, 'Rent', 6574, 6454, 10146, 51470);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (845-58-2572, 95, 86, 46, 6, 'Rent', 6463, 5517, 10672, 55312);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (899-64-6061, 24, 95, 55, 98, 'Rent', 6157, 5120, 10848, 54134);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (407-91-9418, 95, 72, 46, 14, 'Rent', 5767, 5856, 10454, 51447);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (536-91-7372, 17, 75, 4, 79, 'Rent', 6477, 5995, 10926, 52796);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (813-87-1967, 98, 71, 71, 71, 'Rent', 5011, 6997, 10494, 54220);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (575-79-5566, 10, 83, 3, 14, 'Rent', 6577, 5440, 10640, 56126);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (763-85-3529, 74, 33, 7, 21, 'Rent', 5982, 6065, 11546, 52546);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (153-38-3853, 57, 1, 79, 74, 'Rent', 6343, 6431, 11707, 58722);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (704-66-9109, 27, 89, 49, 90, 'Rent', 6899, 6355, 10654, 53455);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (897-84-7482, 5, 33, 60, 86, 'Rent', 5401, 6849, 11934, 58736);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (873-33-0856, 21, 45, 6, 3, 'Rent', 5518, 6389, 10535, 53334);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (586-53-3792, 25, 16, 28, 77, 'Rent', 6111, 5019, 10465, 57991);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (125-19-2177, 23, 17, 27, 61, 'Rent', 6259, 6569, 11700, 51436);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (825-25-4263, 44, 87, 37, 33, 'Rent', 5365, 6432, 10894, 55110);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (682-46-0725, 28, 77, 52, 68, 'Rent', 5076, 6065, 11105, 50894);
insert into Financial_details (SSN, MonthlyIncome, Bonuses, Commission, OtherIncome, [Rent or Own], Checking, Savings, RetirementFund, MutualFund) values (158-31-4730, 72, 76, 87, 50, 'Rent', 6715, 5382, 10275, 50741);

Select	*
From	[dbo].[Financial_details]


--For Loan_details table rows
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (59, 123, 3, 'PURPOSE OF its use', 255271, 123, 'Agree', 1, 'Null', 123, '9/7/2008');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (45, 123, 48, 'PURPOSE OF its use', 320283, 123, 'Agree', 1, 'Null', 123, '9/1/2005');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (40, 123, 53, 'PURPOSE OF its use', 348404, 123, 'Agree', 1, 'Null', 123, '9/11/2000');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (57, 123, 81, 'PURPOSE OF its use', 270455, 123, 'Agree', 1, 'Null', 123, '8/4/2011');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (56, 123, 74, 'PURPOSE OF its use', 323687, 123, 'Agree', 1, 'Null', 123, '8/31/2001');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (51, 123, 27, 'PURPOSE OF its use', 269809, 123, 'Agree', 1, 'Null', 123, '12/4/2003');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (45, 123, 28, 'PURPOSE OF its use', 300801, 123, 'Agree', 1, 'Null', 123, '4/18/2006');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (45, 123, 8, 'PURPOSE OF its use', 329068, 123, 'Agree', 1, 'Null', 123, '6/18/2014');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (44, 123, 19, 'PURPOSE OF its use', 341489, 123, 'Agree', 1, 'Null', 123, '8/10/2000');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (58, 123, 34, 'PURPOSE OF its use', 330020, 123, 'Agree', 1, 'Null', 123, '8/17/2003');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (56, 123, 75, 'PURPOSE OF its use', 250377, 123, 'Agree', 1, 'Null', 123, '7/29/2008');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (39, 123, 85, 'PURPOSE OF its use', 339544, 123, 'Agree', 1, 'Null', 123, '4/18/2016');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (42, 123, 32, 'PURPOSE OF its use', 252465, 123, 'Agree', 1, 'Null', 123, '1/31/2013');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (48, 123, 57, 'PURPOSE OF its use', 268948, 123, 'Agree', 1, 'Null', 123, '6/19/2001');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (51, 123, 23, 'PURPOSE OF its use', 336650, 123, 'Agree', 1, 'Null', 123, '1/11/2013');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (39, 123, 29, 'PURPOSE OF its use', 349095, 123, 'Agree', 1, 'Null', 123, '1/25/2012');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (41, 123, 25, 'PURPOSE OF its use', 263446, 123, 'Agree', 1, 'Null', 123, '12/19/2004');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (55, 123, 88, 'PURPOSE OF its use', 321472, 123, 'Agree', 1, 'Null', 123, '7/22/2016');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (41, 123, 69, 'PURPOSE OF its use', 310107, 123, 'Agree', 1, 'Null', 123, '5/7/2004');
insert into Loan_details (Loan_ID, SSN, Property_ID, [Purpose of Loan], LoanAmount, [Purchase Price], CreditCardAuthorization, [Number of Units], Refferal, [Co-Borrower SSN], [Loan Date]) values (57, 123, 44, 'PURPOSE OF its use', 344117, 123, 'Agree', 1, 'Null', 123, '2/2/2002');

Select *
From	[dbo].[Loan_details]


--Property_details table rows

insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (37, 123, 'property usage', 'Louisville', 'Kentucky', '40215', 'Yulma Hillin', '502-588-5251', 'yhillin0@bbc.co.uk');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (10, 123, 'property usage', 'Nashville', 'Tennessee', '37235', 'Vincenty Balkwill', '615-555-5503', 'vbalkwill1@toplist.cz');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (81, 123, 'property usage', 'Huntsville', 'Alabama', '35810', 'Art Grigsby', '256-111-8052', 'agrigsby2@e-recht24.de');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (30, 123, 'property usage', 'Gainesville', 'Florida', '32605', 'Jimmie Grout', '352-524-4836', 'jgrout3@ebay.com');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (74, 123, 'property usage', 'Minneapolis', 'Minnesota', '55470', 'Zondra O''Howbane', '612-578-4455', 'zohowbane4@sakura.ne.jp');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (99, 123, 'property usage', 'Columbia', 'Missouri', '65218', 'Paulie Leynagh', '573-434-2043', 'pleynagh5@woothemes.com');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (66, 123, 'property usage', 'Atlanta', 'Georgia', '31106', 'Bren Greser', '404-828-3036', 'bgreser6@yahoo.com');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (99, 123, 'property usage', 'Fort Wayne', 'Indiana', '46862', 'Tremaine Southworth', '260-413-7607', 'tsouthworth7@vk.com');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (98, 123, 'property usage', 'Toledo', 'Ohio', '43615', 'Cynde Becke', '419-957-5359', 'cbecke8@oaic.gov.au');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (4, 123, 'property usage', 'Santa Rosa', 'California', '95405', 'Benn Brittan', '707-579-7813', 'bbrittan9@moonfruit.com');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (95, 123, 'property usage', 'Worcester', 'Massachusetts', '01654', 'Renate Myall', '508-670-6322', 'rmyalla@gizmodo.com');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (70, 123, 'property usage', 'Huntington', 'West Virginia', '25770', 'Petey Treble', '304-669-1721', 'ptrebleb@google.pl');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (40, 123, 'property usage', 'Pensacola', 'Florida', '32511', 'Marybeth Reolfi', '850-677-5562', 'mreolfic@indiegogo.com');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (25, 123, 'property usage', 'Cincinnati', 'Ohio', '45223', 'Dore Faulkner', '513-732-7792', 'dfaulknerd@slideshare.net');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (82, 123, 'property usage', 'Dallas', 'Texas', '75287', 'Rosemonde Kulvear', '214-649-9668', 'rkulveare@intel.com');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (3, 123, 'property usage', 'Los Angeles', 'California', '90065', 'Dre Crome', '213-117-7525', 'dcromef@homestead.com');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (16, 123, 'property usage', 'Las Vegas', 'Nevada', '89193', 'Ethel Howsego', '702-528-9568', 'ehowsegog@creativecommons.org');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (25, 123, 'property usage', 'Syracuse', 'New York', '13224', 'Isaiah Pietasch', '315-271-7649', 'ipietaschh@theglobeandmail.com');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (78, 123, 'property usage', 'Amarillo', 'Texas', '79176', 'Boy Traill', '806-651-2370', 'btrailli@soundcloud.com');
insert into Property_details (Property_ID, SSN, [Property Usage], [Property City], [Property State] , [Property Zip], RealEstateAgentName, RealEstateAgentPhone, RealEstateAgentEmail) values (84, 123, 'property usage', 'Corpus Christi', 'Texas', '78415', 'Rodd Benner', '361-613-8998', 'rbennerj@cnbc.com');

Select	*
From	Property_details

Truncate Table [dbo].[Borrower_details]
Truncate Table [dbo].[Financial_details]
Truncate Table [dbo].[Loan_details]
Truncate Table [dbo].[Property_details]


Select	*
From	[dbo].[Borrower_details]

Select	*
From	[dbo].[Financial_details]

Select	*
From	[dbo].[Loan_details]


Select	*
From	[dbo].[Property_details]

--for xml data in to var to xml file
Select *
From	[dbo].[Borrower_details]
for xml RAW('Borrowers'),Root('Borrower_details'),Elements --  auto


