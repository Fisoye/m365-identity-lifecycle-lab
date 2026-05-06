
# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "Directory.ReadWrite.All"

# Import the offboarding script
. .\scripts\offboarding.ps1

# Run offboarding
$result = Remove-CompanyUserAccess `
    -UserPrincipalName "john.doe2@christtech.co.uk"

# Output result
$result | Format-List