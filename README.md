# Eligibility-SQL

# File Guide
1) [ALL TABLES & COLUMNS IN A DATABASE v16 Eligibility Server PREMIER ONLY (Post GN Updates) w CreateDate].sql
   creates [WorkBench].[dbo].[Eligibility_Table_Identifiers_RAW]

2) [Eligibility Aggregate No Fetch - GN Edits w FP Edits].sql
     creates Workbench.dbo.xxEligibility_All_RAW  - first extracted table

3) [Stored Procedure - Eligibility_ALL_Raw_DB Initial Extract to Staging].sql
     [dbo].[sp_Eligibility_Aggregation_RAW_Load_to_Staging] , initial extraction (initially xxEligibility_All_RAW, consider renaming to         Eligibility_ALL_Raw_DB_Extraction)

4) [Stored Procedure - Eligibility_ALL_Raw_DB Staging to Final].sql
   Create final table, proposed name "WorkBench.dbo.Eligibility_ALL_RAW_DB" using a merge on records not currently in the the final table

5) [File_Name_Date_RegEx].sql
   Regex logic for file name date extraction to be added to the creation of the staging table
