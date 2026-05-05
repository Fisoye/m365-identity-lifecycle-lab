<#
.SYNOPSIS
Creates a new Microsoft 365 user, assigns groups and license.

.DESCRIPTION
Automates onboarding using Microsoft Graph PowerShell.
Includes validation, logging, and error handling.

.AUTHOR
Your Name
#>

function New-CompanyUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$UserPrincipalName,

        [Parameter(Mandatory)]
        [string]$DisplayName,

        [Parameter(Mandatory)]
        [string]$MailNickname,

        [string]$Department,
        [string]$JobTitle,

        [Parameter(Mandatory)]
        [string]$UsageLocation,

        [Parameter(Mandatory)]
        [array]$GroupIds,

        [Parameter(Mandatory)]
        [string]$LicenseSkuId,

        [string]$TempPassword = "TempP@ss123!"
    )

    try {
        Write-Host "🔵 Starting onboarding for $UserPrincipalName" -ForegroundColor Cyan

        # Validate Graph connection
        if (-not (Get-MgContext)) {
            throw "Not connected to Microsoft Graph. Run Connect-MgGraph first."
        }

        # Create User
        Write-Host "➡️ Creating user..."
        $User = New-MgUser `
            -DisplayName $DisplayName `
            -UserPrincipalName $UserPrincipalName `
            -MailNickname $MailNickname `
            -Department $Department `
            -JobTitle $JobTitle `
            -AccountEnabled `
            -PasswordProfile @{
                Password = $TempPassword
                ForceChangePasswordNextSignIn = $true
            }

        # Set Usage Location (Required for licensing)
        Write-Host "➡️ Setting usage location..."
        Update-MgUser `
            -UserId $User.Id `
            -UsageLocation $UsageLocation

        # Assign Groups
        Write-Host "➡️ Assigning groups..."
        foreach ($GroupId in $GroupIds) {
            try {
                New-MgGroupMember `
                    -GroupId $GroupId `
                    -DirectoryObjectId $User.Id
            }
            catch {
                Write-Warning "Failed to add user to group $GroupId"
            }
        }

        # Assign License
        Write-Host "➡️ Assigning license..."
        Set-MgUserLicense `
            -UserId $User.Id `
            -AddLicenses @{ SkuId = $LicenseSkuId } `
            -RemoveLicenses @()

        Write-Host "✅ Onboarding completed for $UserPrincipalName" -ForegroundColor Green

        # Return useful object (important for automation pipelines)
        return [PSCustomObject]@{
            UserPrincipalName = $UserPrincipalName
            UserId            = $User.Id
            Status            = "Success"
        }
    }
    catch {
        Write-Error "❌ Onboarding failed for {0}: {1}" -f $UserPrincipalName, $_

        return [PSCustomObject]@{
            UserPrincipalName = $UserPrincipalName
            Status            = "Failed"
            Error             = $_.Exception.Message
        }
    }
}