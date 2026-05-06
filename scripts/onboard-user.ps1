# example run

Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All"

# Import the offboarding script
# ✅ Correct — resolves relative to the script's own location
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptRoot\onboarding.ps1"

New-CompanyUser `
    -UserPrincipalName "john.doe@contoso.com" `
    -DisplayName "John Doe" `
    -MailNickname "john.Doe" `
    -Department "Finance" `
    -JobTitle "Finance Analyst" `
    -UsageLocation "GB" `
    -GroupIds @("7628604c-59ef-440b-a2cf-97fdebe559c6") `
    -LicenseSkuId "3b555118-da6a-4418-894f-7df1e2096870"