# example run

Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All"

# Import the offboarding script
# ✅ Correct — resolves relative to the script's own location
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptRoot\onboarding.ps1"

New-CompanyUser `
    -UserPrincipalName "john.doe6@christtech.co.uk" `
    -DisplayName "AAJohn Adewale" `
    -MailNickname "john.adewale" `
    -Department "Finance" `
    -JobTitle "Finance Analyst" `
    -UsageLocation "GB" `
    -GroupIds @(" ") `
    -LicenseSkuId "3b555118-da6a-4418-894f-7df1e2096870"