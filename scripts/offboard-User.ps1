
# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "Directory.ReadWrite.All"

# Import the offboarding script
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$ScriptRoot\offboarding.ps1"

# Run offboarding
$result = Remove-CompanyUserAccess `
    -UserPrincipalName "john.doe6@christtech.co.uk"

# Output result
$result | Format-List