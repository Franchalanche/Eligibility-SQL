USE [WorkBench]
GO

CREATE PROCEDURE [dbo].[sp_Eligibility_Aggregation_RAW_Load_to_Staging]

--ALTER PROCEDURE [dbo].[sp_Eligibility_Aggregation_RAW_Load_to_Staging]

--STAGING TABLE: [xxEligibility_All_RAW]: RENAME TO Eligibility_ALL_Raw_DB_Extraction
--Transformation: Eligibility_ALL_RAW_DB_STAGING
--Load/Finaltable: Eligibility_ALL_RAW_DB_FINAL

AS BEGIN

DROP TABLE IF EXISTS WorkBench.dbo.Eligibility_ALL_RAW_DB_STAGING;
SELECT i.*
, cast(0 as NVARCHAR(MAX)) AS Raw_File_Name
, cast(0 as int) as File_Size
, cast(0 as DATETIME) as IS_Date
, cast(0 as NVARCHAR(MAX)) AS File_Name_Date
, cast(0 as DATETIME) AS Raw_File_TimeStamp
, cast(0 as DATETIME) AS Chosen_Date
INTO WorkBench.dbo.Eligibility_ALL_RAW_DB_STAGING
FROM WorkBench.dbo.Eligibility_ALL_Raw_DB_Extraction i
;

--ASSUMING SSIS CREATED TABLE IS NAMED Eligibility_Raw_File_Names

UPDATE stage 
SET File_Size = RFN.File_Size

from WorkBench.dbo.Eligibility_ALL_RAW_DB_STAGING stage
JOIN WorkBench.dbo.Eligibility_Raw_File_Names rfn
ON stage.[Contract] = rfn.[Contract]


END