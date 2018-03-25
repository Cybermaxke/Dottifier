# Get the relative path of the DottifyText.ps1 file
$pathSeparator = [IO.Path]::DirectorySeparatorChar
$path = "Dottifier/Dottifier.psm1".Replace('/', $pathSeparator) | Resolve-Path -Relative
# Print the module path
"Dottifier Module: $path"

# Load the script
Import-Module $path
# Test the Dottify-Text function
"" # Write empty line
Get-Dottified -Text hoho -Size 2 -Format X
"" # Write empty line
Get-Dottified -Text abc
"" # Write empty line
Get-Dottified -Text Dottifier! -Size 4
"" # Write empty line
Get-Dottified -Text Seppe -Size 2