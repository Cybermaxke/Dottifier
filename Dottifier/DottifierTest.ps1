# Get the relative path of the DottifyText.ps1 file
$pathSeparator = [IO.Path]::DirectorySeparatorChar
$path = $PSScriptRoot + $pathSeparator + "Dottifier.psm1"

# Load the script
. $path
# Test the Dottify-Text function
Get-Dottified -Text hoho -Size 2 -Format X
"" # Write empty line
Get-Dottified -Text abc
"" # Write empty line
Get-Dottified -Text Dottifier! -Size 4
"" # Write empty line
Get-Dottified -Text Seppe -Size 2