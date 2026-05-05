function Remove-CompanyUserAccess {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$UserPrincipalName
    )

    try {
        Write-Host "🔴 Starting offboarding for $UserPrincipalName" -ForegroundColor Yellow

        # Validate Graph connection
        if (-not (Get-MgContext)) {
            throw "Not connected to Microsoft Graph. Run Connect-MgGraph first."
        }

        # Get User (IMPORTANT: include AssignedLicenses)
        $User = Get-MgUser `
            -UserId $UserPrincipalName `
            -Property "Id,DisplayName,AssignedLicenses" `
            -ErrorAction Stop

        Write-Host "➡️ User found: $($User.DisplayName)"

        # Remove Licenses
        Write-Host "➡️ Removing licenses..."

        $Licenses = $User.AssignedLicenses | Select-Object -ExpandProperty SkuId -ErrorAction SilentlyContinue

        if ($Licenses -and $Licenses.Count -gt 0) {
            Write-Host "Licenses found: $($Licenses -join ', ')"

            Set-MgUserLicense `
                -UserId $User.Id `
                -AddLicenses @{} `
                -RemoveLicenses $Licenses
        }
        else {
            Write-Warning "ℹ️ No licenses found on user"
        }

       
        # Revoke Sessions
        Write-Host "➡️ Revoking active sessions..."
        Revoke-MgUserSignInSession -UserId $User.Id

        # Disable Account
        Write-Host "➡️ Disabling account..."
        Update-MgUser `
            -UserId $User.Id `
            -AccountEnabled:$false

        Write-Host "✅ Offboarding completed for $UserPrincipalName" -ForegroundColor Green

        return [PSCustomObject]@{
            UserPrincipalName = $UserPrincipalName
            UserId            = $User.Id
            Status            = "Offboarded"
            GroupsProcessed   = $Groups.Count
            LicensesRemoved   = $Licenses.Count
        }
    }
    catch {
        Write-Error ("❌ Offboarding failed for {0}: {1}" -f $UserPrincipalName, $_)

        return [PSCustomObject]@{
            UserPrincipalName = $UserPrincipalName
            Status            = "Failed"
            Error             = $_.Exception.Message
        }
    }
}