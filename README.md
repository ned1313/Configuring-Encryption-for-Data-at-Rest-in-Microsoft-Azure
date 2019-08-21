# Configuring-Encryption-for-Data-at-Rest-in-Microsoft-Azure

Exercise file for use with the Pluralsight course Configuring Encryption for Data at Rest in Microsoft Azure

## Introduction

Hello! These are the exercise files to go with my Pluralsight course, [Configuring Encryption for Data at Rest in Microsoft Azure.](http://www.pluralsight.com/courses/microsoft-azure-configuring-encryption-data-rest)

## Preparing for the Course

In order to use these files, you are going to need a few things set up ahead of time.  First and foremost, you'll need an Azure subscription.  You can sign up for a free trial or use an existing subscription.  While I have tried to use smaller instances and lower cost storage in most cases, you may still incur some cost for running the exercises.

The exercises in the files use the newer Az PowerShell module and not the older AzureRM module.  If you already have AzureRM installed on your system, I recommend reading the docs on Microsoft's site about transitioning from [AzureRM to Az](https://docs.microsoft.com/en-us/powershell/azure/migrate-from-azurerm-to-az).

Finally, the examples in the course are demonstrated using Visual Studio Code.  You don't **have** to use VS Code, but it is free and mutli-platform.  You could use PowerShell ISE for all the exercises; however, ISE is being deprecated in favor of using VS Code.

## Doing the exercises

The exercises all start with setting a prefix for the resources that are being created.  This serves the purpose of making them easy to find and delete when you are done.  You could also use metadata tagging if that makes more sense for your environment.

When you have completed the exercises involving the Recovery Vaults, you **must** delete all backup items from the vault before it will let you delete the vault and resource group.

## Feedback

I welcome your feedback!  Please reach out to me on Twitter or log an issue on the GitHub repo.  Thanks for taking my course!