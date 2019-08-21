CREATE ASYMMETRIC KEY CONTOSO_KEY
FROM PROVIDER [AzureKeyVault_EKM_Prov]
WITH PROVIDER_KEY_NAME = 'ced-sql-key',  --The key name here requires the key we created in the key vault
CREATION_DISPOSITION = OPEN_EXISTING;

USE master;
-- Create a SQL Server login associated with the asymmetric key
-- for the Database engine to use when it loads a database
-- encrypted by TDE.
CREATE LOGIN EKM_Login
FROM ASYMMETRIC KEY CONTOSO_KEY;
GO

-- Alter the TDE Login to add the credential for use by the
-- Database Engine to access the key vault
ALTER LOGIN EKM_Login
ADD CREDENTIAL cedsqlcred;
GO

-- Create a Contoso Database for TDE  
CREATE DATABASE [Contoso]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Contoso', FILENAME = N'F:\Data\Contoso.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Contoso_log', FILENAME = N'F:\Log\Contoso_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO

--Switch to Contoso Database context
USE Contoso;
GO

CREATE DATABASE ENCRYPTION KEY 
WITH ALGORITHM = AES_128 
ENCRYPTION BY SERVER ASYMMETRIC KEY CONTOSO_KEY;
GO

-- Alter the database to enable transparent data encryption.
ALTER DATABASE Contoso
SET ENCRYPTION ON;
GO