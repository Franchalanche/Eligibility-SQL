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

--CREATE FILE_NAME_DATE using case when RegEx
update WorkBench.dbo.Eligibility_ALL_RAW_DB_STAGING
SET  File_Name_Date =
    CASE WHEN  [File_Name]  like '05712109%' 
     THEN substring([File_Name],patindex('%[_][0-9][0-9][0-9][0-9][0-9][0-9][_]%',[File_Name])+1,6)
    WHEN File_Name_Date = 0 AND [File_Name] like '%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%' 
      THEN substring([File_Name],PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',[File_Name]),8)
    WHEN File_Name_Date = 0 and [File_Name] like '%[0-9][0-9][0-9][0-9][0-9][0-9]%' 
      THEN substring([File_Name],patindex('%[0-9][0-9][0-9][0-9][0-9][0-9]%',[File_Name]),6)
    WHEN File_Name_Date = 0 and [File_Name] like '%[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]%' 
        AND  [File_Name] NOT like '%AM' and [File_Name] NOT like '%PM'
      THEN substring([File_Name], patindex( '%[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]%',[File_Name]),10)
    WHEN File_Name_Date = '0' and [File_Name] like '%[0-9][0-9][0-9][0-9]_[0-9][0-9]%'
      THEN substring([File_Name], patindex( '%[0-9][0-9][0-9][0-9]_[0-9][0-9]%',[File_Name]),7)
    WHEN File_Name_Date = '0' and [File_Name] like '%[0-9][0-9]_[0-9][0-9]_[0-9][0-9][0-9][0-9]%'
      THEN substring([File_Name], patindex( '%[0-9][0-9]_[0-9][0-9]_[0-9][0-9][0-9][0-9]%',[File_Name]),10)
    WHEN File_Name_Date = '0' and [File_Name] like '%[0-9]_[0-9][0-9]_[0-9][0-9][0-9][0-9]%'
      THEN substring([File_Name], patindex( '%[0-9]_[0-9][0-9]_[0-9][0-9][0-9][0-9]%',[File_Name]),9)
    WHEN File_Name_Date = '0' and [File_Name] like '%[0-9]_[0-9]_[0-9][0-9][0-9][0-9]%'
      THEN substring([File_Name], patindex( '%[0-9]_[0-9]_[0-9][0-9][0-9][0-9]%',[File_Name]),8)
    WHEN File_Name_Date = '0' and [File_Name] like '%[0-9][0-9]_[0-9][0-9]_[0-9][0-9]%' 
       THEN substring([File_Name], patindex( '%[0-9][0-9]_[0-9][0-9]_[0-9][0-9]%',[File_Name]),8) 
    WHEN File_Name_Date = '0' and [File_Name] like '%[0-9][0-9]_[0-9]_[0-9][0-9]%'
       THEN substring([File_Name], patindex( '%[0-9][0-9]_[0-9]_[0-9][0-9]%',[File_Name]),8)
    WHEN File_Name_Date = '0' and [File_Name] like '%[0-9]_[0-9][0-9]_[0-9][0-9]%'
       THEN substring([File_Name], patindex( '%[0-9]_[0-9][0-9]_[0-9][0-9]%',[File_Name]),7)        
    WHEN File_Name_Date = '0' and [File_Name] like '%[0-9]_[0-9]_[0-9][0-9]%'
       THEN substring([File_Name], patindex( '%[0-9]_[0-9]_[0-9][0-9]%',[File_Name]),6)
    WHEN File_Name_Date = '0' and [File_Name] like '%Jan_[0-9][0-9][0-9][0-9]%' 
       THEN substring([File_Name], patindex('%Jan_[0-9][0-9][0-9][0-9]%',[File_Name]),8)
    WHEN File_Name_Date = '0' and [File_Name] like '%Feb_[0-9][0-9][0-9][0-9]%'
        then substring([File_Name], patindex('%Feb_[0-9][0-9][0-9][0-9]%',[File_Name]),8)
		when File_Name_Date = '0' and [File_Name] like '%March_[0-9][0-9][0-9][0-9]%' 
        then substring([File_Name], patindex('%March_[0-9][0-9][0-9][0-9]%',[File_Name]),10)
    when File_Name_Date = '0' and [File_Name] like '%Mar_[0-9][0-9][0-9][0-9]%' 
        then substring([File_Name], patindex('%Mar_[0-9][0-9][0-9][0-9]%',[File_Name]),8)
    when File_Name_Date = '0' and [File_Name] like '%April_[0-9][0-9][0-9][0-9]%' 
        then substring([File_Name], patindex('%April_[0-9][0-9][0-9][0-9]%',[File_Name]),10)
    when File_Name_Date = '0' and [File_Name] like '%Apr_[0-9][0-9][0-9][0-9]%' 
        then substring([File_Name], patindex('%Apr_[0-9][0-9][0-9][0-9]%',[File_Name]),8)
    when File_Name_Date = '0' and [File_Name] like '%May_[0-9][0-9][0-9][0-9]%' 
        then substring([File_Name], patindex('%May_[0-9][0-9][0-9][0-9]%',[File_Name]),8)
    when File_Name_Date = '0' and [File_Name] like '%Jun_[0-9][0-9][0-9][0-9]%' 
        then substring([File_Name], patindex('%Jun_[0-9][0-9][0-9][0-9]%',[File_Name]),8)
    when File_Name_Date = '0' and [File_Name] like '%Jul_[0-9][0-9][0-9][0-9]%' 
        then substring([File_Name], patindex('%Jul_[0-9][0-9][0-9][0-9]%',[File_Name]),8)
    when File_Name_Date = '0' and [File_Name] like '%Aug_[0-9][0-9][0-9][0-9]%' 
        then substring([File_Name], patindex('%Aug_[0-9][0-9][0-9][0-9]%',[File_Name]),8)
    when File_Name_Date = '0' and [File_Name] like '%Sept_[0-9][0-9][0-9][0-9]%' 
        then substring([File_Name], patindex('%Sept_[0-9][0-9][0-9][0-9]%',[File_Name]),9)
    when File_Name_Date = '0' and [File_Name] like '%October_[0-9][0-9][0-9][0-9]%' 
        then substring([File_Name], patindex('%October_[0-9][0-9][0-9][0-9]%',[File_Name]),12)
    when File_Name_Date = '0' and [File_Name] like '%Oct_[0-9][0-9][0-9][0-9]%' 
        then substring([File_Name], patindex('%Oct_[0-9][0-9][0-9][0-9]%',[File_Name]),8)
    when File_Name_Date = '0' and [File_Name] like '%Nov_[0-9][0-9][0-9][0-9]%' 
        then substring([File_Name], patindex('%Nov_[0-9][0-9][0-9][0-9]%',[File_Name]),8)
    when File_Name_Date = '0' and [File_Name] like '%Dec_[0-9][0-9][0-9][0-9]%' 
        then substring([File_Name], patindex('%Dec_[0-9][0-9][0-9][0-9]%',[File_Name]),8)
    else '0' end;



END
