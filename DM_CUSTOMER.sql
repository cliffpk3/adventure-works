USE STG_ADVWORKS;
CREATE TABLE SALES.DM_CUSTOMER (
    NK_CUSTOMER INT NOT NULL, 
	DS_TYPE	NVARCHAR(255) NOT NULL,
    DS_FIRSTNAME NVARCHAR(255) NOT NULL,
    DS_LASTNAME NVARCHAR(255) NOT NULL,
	DS_STORENAME NVARCHAR(255) NOT NULL,
	DS_PHONE NVARCHAR(255),
	DS_EMAIL NVARCHAR(255),
    DT_REGUPDATE_BE DATETIME,
    DT_REGUPDATE_C DATETIME,
    DT_REGUPDATE_P DATETIME,
    DT_DELETE DATETIME,
    DT_CARGA DATETIME NOT NULL
);

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'SALES.DEL_DM_CUSTOMER') 
           AND [TYPE] IN (N'U'))
BEGIN
   DROP TABLE SALES.DEL_DM_CUSTOMER;
END

CREATE TABLE SALES.DEL_DM_CUSTOMER (
				NK_CUSTOMER INT NOT NULL
)

USE DW_ADVWORKS;
CREATE TABLE SALES.DM_CUSTOMER (
    SK_CUSTOMER NUMERIC(10) IDENTITY(1,1) NOT NULL,
    NK_CUSTOMER INT NOT NULL, 
	DS_TYPE	NVARCHAR(255) NOT NULL,
    DS_FIRSTNAME NVARCHAR(255) NOT NULL,
    DS_LASTNAME NVARCHAR(255) NOT NULL,
	DS_STORENAME NVARCHAR(255) NOT NULL,
	DS_PHONE NVARCHAR(255),
	DS_EMAIL NVARCHAR(255),
    DT_REGUPDATE_BE DATETIME,
    DT_REGUPDATE_C DATETIME,
    DT_REGUPDATE_P DATETIME,
	DT_UPDATE DATETIME,
    DT_DELETE DATETIME,
    DT_CARGA DATETIME NOT NULL,
	CONSTRAINT DMCUSPK PRIMARY KEY (SK_CUSTOMER)
);

USE ADVENTUREWORKS2019
SELECT 		C.CUSTOMERID			NK_CUSTOMER,
			IIF(FIRSTNAME IS NULL, 'NOT APPLIED', FIRSTNAME) DS_FIRSTNAME,
			IIF(LASTNAME IS NULL, 'NOT APPLIED', LASTNAME)				DS_LASTNAME,
			IIF(S.NAME IS NULL, 'NOT APPLIED', S.NAME)					DS_STORENAME,
			BE.MODIFIEDDATE			DT_REGUPDATE_BE,			
			C.MODIFIEDDATE			DT_REGUPDATE_C,
			P.MODIFIEDDATE			DT_REGUPDATE_P,
			GETDATE()				DT_CARGA
FROM		(SELECT C.CUSTOMERID, IIF(C.PERSONID IS NULL, C.STOREID, C.PERSONID) BUSINESSENTITYID, C.MODIFIEDDATE FROM SALES.CUSTOMER C) C
JOIN		PERSON.BUSINESSENTITY BE ON C.BUSINESSENTITYID = BE.BUSINESSENTITYID
LEFT JOIN	PERSON.PERSON P ON C.BUSINESSENTITYID = P.BUSINESSENTITYID
LEFT JOIN	SALES.STORE S ON C.BUSINESSENTITYID = S.BUSINESSENTITYID 
WHERE		1=1


WITH CUSTOMER AS (
SELECT C.CUSTOMERID, IIF(C.PERSONID IS NULL, C.STOREID, C.PERSONID) BUSINESSENTITYID, C.MODIFIEDDATE FROM SALES.CUSTOMER C
)

, PERSONTYPE AS (
SELECT 'SC' PERSONTYPE, 'STORE CONTACT' DS_TYPE UNION ALL
SELECT 'IN' PERSONTYPE, 'INDIVIDUAL' DS_TYPE UNION ALL
SELECT 'SP' PERSONTYPE, 'SALES PERSON ' DS_TYPE UNION ALL
SELECT 'EM' PERSONTYPE, 'EMPLOYEE ' DS_TYPE UNION ALL
SELECT 'VC' PERSONTYPE, 'VENDOR ' DS_TYPE UNION ALL
SELECT 'GC' PERSONTYPE, 'GENERAL CONTACT ' DS_TYPE
)
SELECT 		-1						NK_CUSTOMER,
			'NO TYPE'				DS_TYPE,
			'NO FIRST NAME'			DS_FIRSTNAME,
			'NO LAST NAME'			DS_LASTNAME,
			'NO STORE NAME'			DS_STORENAME,
			'NO PHONE'				DS_PHONE,
			'NO E-MAIL'				DS_EMAIL,
			GETDATE()				DT_REGUPDATE_BE,			
			GETDATE()				DT_REGUPDATE_C,
			GETDATE()				DT_REGUPDATE_P,
			GETDATE()				DT_CARGA
UNION ALL
SELECT 		C.CUSTOMERID			NK_CUSTOMER,
			CONVERT(NVARCHAR(255),IIF(PT.DS_TYPE IS NULL, 'STORE', DS_TYPE)) DS_TYPE,
			IIF(FIRSTNAME IS NULL, 'NOT APPLIED', FIRSTNAME) DS_FIRSTNAME,
			IIF(LASTNAME IS NULL, 'NOT APPLIED', LASTNAME) DS_LASTNAME,
			IIF(S.NAME IS NULL, 'NOT APPLIED', S.NAME) DS_STORENAME,
			PP.PHONENUMBER			DS_PHONE,
			EA.EMAILADDRESS			DS_EMAIL,
			BE.MODIFIEDDATE			DT_REGUPDATE_BE,			
			C.MODIFIEDDATE			DT_REGUPDATE_C,
			P.MODIFIEDDATE			DT_REGUPDATE_P,
			GETDATE()				DT_CARGA
FROM		CUSTOMER C
JOIN		PERSON.BUSINESSENTITY BE ON C.BUSINESSENTITYID = BE.BUSINESSENTITYID
LEFT JOIN	PERSON.PERSON P ON C.BUSINESSENTITYID = P.BUSINESSENTITYID
LEFT JOIN	SALES.STORE S ON C.BUSINESSENTITYID = S.BUSINESSENTITYID 
LEFT JOIN	PERSON.PERSONPHONE PP ON C.BUSINESSENTITYID = PP.BUSINESSENTITYID
LEFT JOIN	PERSON.EMAILADDRESS EA ON C.BUSINESSENTITYID = EA.BUSINESSENTITYID
LEFT JOIN	PERSONTYPE PT ON P.PERSONTYPE = PT.PERSONTYPE
WHERE		1=1
--			AND	CONVERT(DATE,C.MODIFIEDDATE) >= CONVERT(DATE,GETDATE()-7)


MERGE DW_ADVWORKS.SALES.DM_CUSTOMER DEST
USING STG_ADVWORKS.SALES.DM_CUSTOMER UPD ON UPD.NK_CUSTOMER = DEST.NK_CUSTOMER
WHEN NOT MATCHED THEN INSERT
VALUES (
NK_CUSTOMER,
DS_TYPE,
DS_FIRSTNAME,
DS_LASTNAME,
DS_STORENAME,
DS_PHONE,
DS_EMAIL,
DT_REGUPDATE_BE,	
DT_REGUPDATE_C,
DT_REGUPDATE_P,
NULL, --UPD.DT_UPDATE
NULL, --UPD.DT_DELETE
UPD.DT_CARGA
) WHEN MATCHED AND
CONCAT(
UPD.NK_CUSTOMER,
UPD.DS_TYPE,
UPD.DS_FIRSTNAME,
UPD.DS_LASTNAME,
UPD.DS_STORENAME,
UPD.DS_PHONE,
UPD.DS_EMAIL,
UPD.DT_REGUPDATE_BE,	
UPD.DT_REGUPDATE_C,
UPD.DT_REGUPDATE_P,
UPD.DT_DELETE,
UPD.DT_CARGA
) <>
CONCAT(
DEST.NK_CUSTOMER,
DEST.DS_TYPE,
DEST.DS_FIRSTNAME,
DEST.DS_LASTNAME,
DEST.DS_STORENAME,
DEST.DS_PHONE,
DEST.DS_EMAIL,
DEST.DT_REGUPDATE_BE,	
DEST.DT_REGUPDATE_C,
DEST.DT_REGUPDATE_P,
DEST.DT_DELETE,
DEST.DT_CARGA
)
THEN
UPDATE
SET 
DEST.NK_CUSTOMER			= UPD.NK_CUSTOMER,				
DEST.DS_TYPE				= UPD.DS_TYPE,	
DEST.DS_FIRSTNAME			= UPD.DS_FIRSTNAME,
DEST.DS_LASTNAME			= UPD.DS_LASTNAME,
DEST.DS_STORENAME			= UPD.DS_STORENAME,
DEST.DS_PHONE				= UPD.DS_PHONE,
DEST.DS_EMAIL				= UPD.DS_EMAIL,
DEST.DT_REGUPDATE_BE		= UPD.DT_REGUPDATE_BE,	
DEST.DT_REGUPDATE_C			= UPD.DT_REGUPDATE_C,
DEST.DT_REGUPDATE_P			= UPD.DT_REGUPDATE_P,
DEST.DT_UPDATE				= GETDATE(),
DEST.DT_DELETE				= UPD.DT_DELETE,
DEST.DT_CARGA				= UPD.DT_CARGA;

SELECT 		C.CUSTOMERID 
FROM		SALES.CUSTOMER C
WHERE		1=1
--			AND	CONVERT(DATE,MODIFIEDDATE) >= CONVERT(DATE,GETDATE()-7)

UPDATE		DEST
SET			DEST.DT_DELETE = GETDATE()
FROM		DW_ADVWORKS.SALES.DM_CUSTOMER DEST
LEFT JOIN	STG_ADVWORKS.SALES.DEL_DM_CUSTOMER DEL ON DEL.NK_CUSTOMER = DEST.NK_CUSTOMER
WHERE		DEL.NK_CUSTOMER IS NULL
AND			DEST.DT_DELETE IS NULL;

DROP TABLE STG_ADVWORKS.SALES.DEL_DM_CUSTOMER