# Get the relative path of the Dottifier module
$pathSeparator = [IO.Path]::DirectorySeparatorChar
$path = "Dottifier" | Resolve-Path -Relative
# Print the module path
"Dottifier Module: $path"

# Load the script
Import-Module $path
# Test the Dottify-Text function
"" # Write empty line
Get-Dottified -Text hoho -Size 2 -Format X
"" # Write empty line
Get-Dottified -Text abcdefghijklmnopxyz
"" # Write empty line
Get-Dottified -Text abcdefghijklmnopxyz -size 2
"" # Write empty line
Get-Dottified -Text Dottifier! -Size 4
"" # Write empty line
Get-Dottified -Text Seppe -Size 2
"" # Write empty line
"Cybermaxke" | Get-Dottified -Size 3
"" # Write empty line
Get-Dottified -Text 'Test' -Format ':solid-dots'
