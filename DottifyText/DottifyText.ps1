function Dottify-Text {
	# Input parameters
	param (
		# The text that should be converted into the dotted output
		[Parameter(Mandatory=$true)] [string] $text,
		# The size/scale of the characters
		[int] $size = 1,
		# The format of the output
		# ':small-dots'		-> Small braille dots
		# 'A', 'B', etc.	-> A specific character
		[string] $format = ':small-dots',
		# The color that should be used for the next
		[System.ConsoleColor] $color = [System.ConsoleColor]::White,
		# The font json data
		[string] $font =
@"
{
	"aA": [
		"  O  ",
		" O O ",
		"O   O",
		"O   O",
		"OOOOO",
		"O   O",
		"O   O"
	],
	"bB": [
		"OOOO ",
		"O   O",
		"O   O",
		"OOOO ",
		"O   O",
		"O   O",
		"OOOO "
	],
	"cC": [
		" OOO ",
		"O   O",
		"O    ",
		"O    ",
		"O    ",
		"O   O",
		" OOO "
	],
	"dD": [
		"OOOO ",
		"O   O",
		"O   O",
		"O   O",
		"O   O",
		"O   O",
		"OOOO "
	],
	"eE": [
		"OOOOO",
		"O    ",
		"O    ",
		"OOO  ",
		"O    ",
		"O    ",
		"OOOOO"
	],
	"fF": [
		"OOOOO",
		"O    ",
		"O    ",
		"OOO  ",
		"O    ",
		"O    ",
		"O    "
	],
	"gG": [
		" OOO ",
		"O   O",
		"O    ",
		"O OO ",
		"O   O",
		"O   O",
		" OOO "
	],
	"hH": [
		"O   O",
		"O   O",
		"O   O",
		"OOOOO",
		"O   O",
		"O   O",
		"O   O"
	],
	"iI": [
		"  O  ",
		"  O  ",
		"  O  ",
		"  O  ",
		"  O  ",
		"  O  ",
		"  O  "
	],
	"jJ": [
		"    O",
		"    O",
		"    O",
		"    O",
		"O   O",
		"O   O",
		" OOO"
	],
	"kK": [
		"O   O",
		"O   O",
		"O  O ",
		"OOO  ",
		"O  O ",
		"O   O",
		"O   O"
	],
	"lL": [
		"O    ",
		"O    ",
		"O    ",
		"O    ",
		"O    ",
		"O    ",
		"OOOOO"
	],
	"mM": [
		"O   O",
		"OO OO",
		"O O O",
		"O   O",
		"O   O",
		"O   O",
		"O   O"
	],
	"nN": [
		"O   O",
		"O   O",
		"OO  O",
		"O O O",
		"O  OO",
		"O   O",
		"O   O"
	],
	"oO": [
		" OOO ",
		"O   O",
		"O   O",
		"O   O",
		"O   O",
		"O   O",
		" OOO "
	]
}
"@
	)

	# (Possible) TODO List:
	# - Color support
	# - Parse characters from JSON
	# - Autofill rows if height doesn't match
	# - Support multiline with '\n' character
	# - Support '\t', etc.

	# A map with all the characters in the alphabet, 1 represents a dot
	# and 0 nothing. All the characters should have the same height
	# Only uppercase characters are supported, all lowercase ones will be
	# converted into uppercase ones. Unsupported characters will be replaced
	# by '?'

	# The height of each character
	$charHeight = 7
	# The spacing between each character
	$charSpacing = 2
	# The height between each text line
	$lineSpacing = 2

	# Map all the font data per character
	$charMap = @{}

	# Convert the json string into a object and
	# iterate through the entries to extract the font data

	# Powershell 2
	#$fontData = (New-Object System.Web.Script.Serialization.JavaScriptSerializer).Deserialize($font, [System.Collections.Hashtable])
	#$fontData.GetEnumerator() | ForEach-Object {
	#	foreach ($char in [char[]] $_.Key) {
	#		$charMap[$char] = $_.Value
	#	}
	#}

	($font | ConvertFrom-Json).PSObject.Properties | ForEach {
		foreach ($char in [char[]] $_.Name) {
			$charMap[$char] = $_.Value
		}
	}

	# Convert all the text into dot rows
	# Step 1: Append all the characters into one grid of dots
	#		  -> Each row is a string of dots, where 'O' represents a dot and ' ' (space) nothing
	# Step 2: Generate the braille unicodes based on the generated grid (if needed)

	## Step 1:

	# The list with rows
	$dataLines = New-Object System.Collections.ArrayList

	# The current y offset, depending on
	# the max height of the character format
	# The offset will be increased with each text line, separated by \n
	$yoffset = 0

	# The max line length
	$maxLineLength = 0

	# Use by default 'O' for formatting, is used to check for small dots
	$tempFormat = 'O'
	# If we don't need to use small dots, skip
	if ($format -ne ':small-dots') {
		$tempFormat = $format
		if ($tempFormat -eq ':solid-dot') {
			$tempFormat = [char] 0x2022 # Bullet icon unicode
		}
	}

	# Write every line separately using newline
	foreach ($line in $text.Split([Environment]::NewLine)) {
		$length = 0
		# Expands the dataLines list for the current y offset and char height
		while ($dataLines.Count -lt ($yoffset + $charHeight * $size)) {
			# https://stackoverflow.com/questions/2149159/prevent-arraylist-add-from-returning-the-index
			# Redirect to null to avoid printing the index
			$dataLines.Add("") > $null
		}
		$first = 1
		# Loop through all the characters in the input text
		foreach ($char in [char[]] $line) {
			# Get the data for the given character
			$data = $charMap[$char]
			# Increase the current line length
			$length +=  $data.Count * $size
			# Loop through all the rows
			for ($i = 0; $i -lt $data.Count; $i++) {
				$row = $data[$i]
				# Get the current output line
				$line = $dataLines[$yoffset + $i * $size]
				# Apply spaces after each character, except the last one
				if ($first -eq 0) {
					for ($j = 0; $j -lt ($size * $charSpacing); $j++) {
						$line += ' '
					}
				}
				foreach ($ochar in [char[]] $row) {
					for ($j = 0; $j -lt $size; $j++) {
						if ($ochar -eq 'O') {
							$line += $tempFormat
						} else {
							$line += ' '
						}
					}
				}
				# Set the current output line
				for ($j = 0; $j -lt $size; $j++) {
					$dataLines[$yoffset + $i * $size + $j] = $line
				}
			}
			# Set the flag for the next interation
			$first = 0
		}
		# Update the max line length if needed
		if ($length -gt $maxLineLength) {
			$maxLineLength = $length
		}
		# Increase offset, also apply line spacing to avoid sticking lines together
		$yoffset += $charHeight + $lineSpacing
	}

    ## Step 2 (if needed):
    # https://en.wikipedia.org/wiki/Braille_Patterns

	Write-Output $dataLines
	Write-Output ""

	if ($format -eq ':small-dots') {
		# Horizontal divided by 2, 2 dots in the horizontal direction per char, 4 per char vertically

		$horizontalDotsPerChar = 2
		$verticalDotsPerChar = 4
	
		$brailleDataWidth = [int] [System.Math]::Ceiling([double] $maxLineLength / [double] $horizontalDotsPerChar)
		$brailleDataHeight = [int] [System.Math]::Ceiling([double] $dataLines.Count / [double] $verticalDotsPerChar)

		# Create a 2d array list to store the braille byte patterns
		$braillePatterns = New-Object System.Collections.ArrayList
		for ($j = 0; $j -lt $brailleDataHeight; $j++) {
			$braillePatternList = New-Object System.Collections.ArrayList
			for ($i = 0; $i -lt $brailleDataWidth; $i++) {
				$braillePatternList.Add(0) > $null
			}
			$braillePatterns.Add($braillePatternList) > $null
		}

		for ($j = 0; $j -lt $dataLines.Count; $j++) {
			# Get the y coordinate within the braille pattern array
			$brailleY = [int] [System.Math]::Floor($j / $verticalDotsPerChar)
			# Get the local y coordinate within the braille character
			$brailleYLocal = [int] ($j % $verticalDotsPerChar)
			for ($i = 0; $i -lt $maxLineLength; $i++) {
				# Get the x coordinate within the braille pattern array
				$brailleX = [int] [System.Math]::Floor($i / $horizontalDotsPerChar)
				# Get the local x coordinate within the braille character
				$brailleXLocal = [int] ($i % $horizontalDotsPerChar)
				
				#"y: $j"
				#"x: $i"
				#"brailleY: $brailleY"
				#"brailleYLocal: $brailleYLocal"
				#"brailleX: $brailleX"
				#"brailleXLocal: $brailleXLocal"
				([char[]] $dataLines[$j])[$i]
				# Apply the bit for the specific dot, if needed
				if (([char[]] $dataLines[$j])[$i] -eq $tempFormat) {
					# Get the braille bit for the specific
					# dot at the local indexes
					$bit = 0
					if ($brailleYLocal -eq 0) {
						if ($brailleXLocal -eq 0) {
							$bit = 0x01
						} else {
							$bit = 0x08
						}
					} elseif ($brailleYLocal -eq 1) {
						if ($brailleXLocal -eq 0) {
							$bit = 0x02
						} else {
							$bit = 0x10
						}
					} elseif ($brailleYLocal -eq 2) {
						if ($brailleXLocal -eq 0) {
							$bit = 0x04
						} else {
							$bit = 0x20
						}
					} else {
						if ($brailleXLocal -eq 0) {
							$bit = 0x40
						} else {
							$bit = 0x80
						}
					}
				}
				# Update the braille pattern
				$braillePatterns[$brailleY][$brailleX] = [int] $braillePatterns[$brailleY][$brailleX] -bor $bit
			}
		}

		$dataLines.Clear()

		for ($j = 0; $j -lt $brailleDataHeight; $j++) {
			$line = ""
			for ($i = 0; $i -lt $brailleDataWidth; $i++) {
				$line += [char] ([int] 0x2800 -bor $braillePatterns[$j][$i])
			}
			$dataLines.Add($line) > $null
		}
	}
	
	# Change the output color
	#$originalColor = $host.ui.RawUI.ForegroundColor
	#$host.ui.RawUI.ForegroundColor = $color
	
	# Write output
	Write-Output $dataLines

	# Change the output color back to the original
	#$host.ui.RawUI.ForegroundColor = $originalColor
}