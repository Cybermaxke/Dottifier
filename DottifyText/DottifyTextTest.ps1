# Get the relative path of the DottifyText.ps1 file
$pathSeparator = [IO.Path]::DirectorySeparatorChar
$path = $PSScriptRoot + $pathSeparator + "DottifyText.ps1"

# Load the script
. $path
# Test the Dottify-Text function
Dottify-Text -Text hoho -Size 2 -Format X -Color darkgreen
"" # Write empty line
Dottify-Text -Text abc