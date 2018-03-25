# Get the relative path of the DottifyText.ps1 file
$pathSeparator = [IO.Path]::DirectorySeparatorChar
$path = "Dottifier/bin/netstandard2.0/DottifierModule.dll".Replace('/', $pathSeparator) | Resolve-Path -Relative

# Load the module
powershell -Command "Import-Module $path; Get-Dottified -Text 'hoho'"
# Test the Dottify-Text function
#Get-Dottified -Text "hoho"
#Get-Dottified -Text hoho -Size 2 -Format X
"" # Write empty line
#Get-Dottified -Text abc
"" # Write empty line
#Get-Dottified -Text Dottifier! -Size 4
"" # Write empty line
#Get-Dottified -Text Seppe -Size 2