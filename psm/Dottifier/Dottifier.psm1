<#
	Gets a dottified version of the input text.
#>
function Get-Dottified {
    # Input parameters
    param (
        # The text that should be converted into the dotted output
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)] [string] $text,
        # The size/scale of the characters
        [int] $size = 1,
        # The format of the output
        # ':small-dots'     -> Small braille dots
        # 'A', 'B', etc.    -> A specific character
        [string] $format = ':small-dots',
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
        " OOO "
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
    ],
    "pP": [
        "OOOO ",
        "O   O",
        "O   O",
        "OOOO ",
        "O    ",
        "O    ",
        "O    "
    ],
    "qQ": [
        " OOO ",
        "O   O",
        "O   O",
        "O   O",
        "O O O",
        "O  OO",
        " OOO "
    ],
    "rR": [
        "OOOO ",
        "O   O",
        "O   O",
        "OOOO ",
        "O O  ",
        "O  O ",
        "O   O"
    ],
    "sS": [
        " OOO ",
        "O   O",
        "O    ",
        " OOO ",
        "    O",
        "O   O",
        " OOO "
    ],
    "tT": [
        "OOOOO",
        "  O  ",
        "  O  ",
        "  O  ",
        "  O  ",
        "  O  ",
        "  O  "
    ],
    "uU": [
        "O   O",
        "O   O",
        "O   O",
        "O   O",
        "O   O",
        "O   O",
        " OOO "
    ],
    "vV": [
        "O   O",
        "O   O",
        "O   O",
        "O   O",
        "O   O",
        " O O ",
        "  O  "
    ],
    "wW": [
        "O   O",
        "O   O",
        "O   O",
        "O   O",
        "O O O",
        "O O O",
        " O O "
    ],
    "xX": [
        "O   O",
        "O   O",
        " O O ",
        "  O  ",
        " O O ",
        "O   O",
        "O   O"
    ],
    "yY": [
        "O   O",
        "O   O",
        " O O ",
        "  O  ",
        "  O  ",
        "  O  ",
        "  O  "
    ],
    "zZ": [
        "OOOOO",
        "    O",
        "   O ",
        "  O  ",
        " O   ",
        "O    ",
        "OOOOO"
    ],
    " ": [
        "     ",
        "     ",
        "     ",
        "     ",
        "     ",
        "     ",
        "     "
    ],
    ".": [
        "     ",
        "     ",
        "     ",
        "     ",
        "     ",
        "     ",
        "  O  "
    ],
    "?": [
        " OOO ",
        "O   O",
        "    O",
        "   O ",
        "  O  ",
        "     ",
        "  O  "
    ],
    "!": [
        "  O  ",
        "  O  ",
        "  O  ",
        "  O  ",
        "  O  ",
        "     ",
        "  O  "
    ],
    "\u0000": [
        "OOOOO",
        "O   O",
        "OO OO",
        "O O O",
        "OO OO",
        "O   O",
        "OOOOO"
    ]
}
"@
    )

    # (Possible) TODO List:
    # - Autofill rows if height doesn't match
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
    #   foreach ($char in [char[]] $_.Key) {
    #       $charMap[$char] = $_.Value
    #   }
    #}

    ($font | ConvertFrom-Json).PSObject.Properties | ForEach {
        foreach ($char in [char[]] $_.Name) {
            $charMap[$char] = $_.Value
        }
    }

    # Convert all the text into dot rows
    # Step 1: Append all the characters into one grid of dots
    #         -> Each row is a string of dots, where 'O' represents a dot and ' ' (space) nothing
    # Step 2: Generate the braille unicodes based on the generated grid (if needed)

    ## Step 1:

    # The list with rows
    $dataLines = New-Object System.Collections.ArrayList

    # The current y offset, depending on
    # the max height of the character format
    # The offset will be increased with each text line, separated by \n
    $yOffset = 0

    # The max line length
    $maxLineLength = 0

    # Use by default 'O' for formatting, is used to check for small dots
    $tempFormat = 'O'
    # If we need to use small dots, skip
    if ($format -ne ':small-dots') {
        $tempFormat = $format
        if ($tempFormat -eq ':solid-dots') {
            $tempFormat = [char] 0x2022 # Bullet icon unicode
        }
    }

    # Write every line separately using newline
    foreach ($line in $text.Split([Environment]::NewLine)) {
        $length = 0
        # Expands the dataLines list for the current y offset and char height
        while ($dataLines.Count -lt ($yOffset + $charHeight * $size)) {
            # https://stackoverflow.com/questions/2149159/prevent-arraylist-add-from-returning-the-index
            # Redirect to null to avoid printing the index
            $dataLines.Add("") > $null
        }
        $first = 1
        # Loop through all the characters in the input text
        foreach ($char in [char[]] $line) {
            # Get the data for the given character
            $data = $charMap[$char]
            # Check if the character isn't missing
            if ($data -eq $null) {
                $data = $charMap[[char] 0x0000]
            }
            # Increase the current line length
            $length += $data.Count * $size
            # Loop through all the rows
            for ($i = 0; $i -lt $data.Count; $i++) {
                $row = $data[$i]
                # Get the current output line
                $line = $dataLines[$yOffset + $i * $size]
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
                    $dataLines[$yOffset + $i * $size + $j] = $line
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
        $yOffset += $charHeight + $lineSpacing
    }

    ## Step 2 (if needed):
    # https://en.wikipedia.org/wiki/Braille_Patterns

    if ($format -eq ':small-dots') {
        # [y][x]
        # 2 dots per char in x direction
        # 4 dots per char in y direction
        $brailleBits = @((0x1, 0x8), (0x2, 0x10), (0x4, 0x20), (0x40, 0x80))
        
        $horizontalDotsPerChar = $brailleBits[0].Count
        $verticalDotsPerChar = $brailleBits.Count

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
                # Apply the bit for the specific dot, if needed
                if (([char[]] $dataLines[$j])[$i] -eq $tempFormat) {
                    # Update the braille pattern
                    $braillePatterns[$brailleY][$brailleX] = [int] $braillePatterns[$brailleY][$brailleX] -bor $brailleBits[$brailleYLocal][$brailleXLocal]
                }
            }
        }

        # Clear the old data lines, we will generate new ones
        $dataLines.Clear()

        for ($j = 0; $j -lt $brailleDataHeight; $j++) {
            $line = ""
            for ($i = 0; $i -lt $brailleDataWidth; $i++) {
                $bits = $braillePatterns[$j][$i]
                # The space braille unicode doesn't have the same length :(
                if ($bits -eq 0) {
                    $bits = 0x80
                }
                # Calculate the unicode
                $line += [char] ([int] 0x2800 -bor $bits)
            }
            $dataLines.Add($line) > $null
        }
    }
    
    # Write output
    Write-Output $dataLines
}