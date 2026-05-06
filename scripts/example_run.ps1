# example run

Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All"

New-CompanyUser `
    -UserPrincipalName "NewUser@Domain.com" `
    -DisplayName "John Adewale" `
    -MailNickname "john.adewale" `
    -Department "Finance" `
    -JobTitle "Finance Analyst" `
    -UsageLocation "GB" `
    -GroupIds @(" ") `
    -LicenseSkuId "3b555118-da6a-4418-894f-7df1e2096870"