using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Management.Automation;

namespace Dottifier
{
    [Cmdlet(VerbsCommon.Get, "Dottified")]
    public class GetDottified : Cmdlet
    {
        /// <summary>
        /// The Small Dots format name. This format uses
        /// braille unicodes to generate text. It is recommend
        /// to apply at least a Size of 2 when using this format.
        /// </summary>
        public static readonly string SmallDots = ":small-dots";

        /// <summary>
        /// The Solid Dots format name.
        /// </summary>
        public static readonly string SolidDots = ":solid-dots";

        /// <summary>
        /// The default font that will be used.
        /// </summary>
        public static readonly String DefaultFont =
@"
{
    'aA': [
        '  O  ',
        ' O O ',
        'O   O',
        'O   O',
        'OOOOO',
        'O   O',
        'O   O'
    ],
    'bB': [
        'OOOO ',
        'O   O',
        'O   O',
        'OOOO ',
        'O   O',
        'O   O',
        'OOOO '
    ],
    'cC': [
        ' OOO ',
        'O   O',
        'O    ',
        'O    ',
        'O    ',
        'O   O',
        ' OOO '
    ],
    'dD': [
        'OOOO ',
        'O   O',
        'O   O',
        'O   O',
        'O   O',
        'O   O',
        'OOOO '
    ],
    'eE': [
        'OOOOO',
        'O    ',
        'O    ',
        'OOO  ',
        'O    ',
        'O    ',
        'OOOOO'
    ],
    'fF': [
        'OOOOO',
        'O    ',
        'O    ',
        'OOO  ',
        'O    ',
        'O    ',
        'O    '
    ],
    'gG': [
        ' OOO ',
        'O   O',
        'O    ',
        'O OO ',
        'O   O',
        'O   O',
        ' OOO '
    ],
    'hH': [
        'O   O',
        'O   O',
        'O   O',
        'OOOOO',
        'O   O',
        'O   O',
        'O   O'
    ],
    'iI': [
        '  O  ',
        '  O  ',
        '  O  ',
        '  O  ',
        '  O  ',
        '  O  ',
        '  O  '
    ],
    'jJ': [
        '    O',
        '    O',
        '    O',
        '    O',
        'O   O',
        'O   O',
        ' OOO '
    ],
    'kK': [
        'O   O',
        'O   O',
        'O  O ',
        'OOO  ',
        'O  O ',
        'O   O',
        'O   O'
    ],
    'lL': [
        'O    ',
        'O    ',
        'O    ',
        'O    ',
        'O    ',
        'O    ',
        'OOOOO'
    ],
    'mM': [
        'O   O',
        'OO OO',
        'O O O',
        'O   O',
        'O   O',
        'O   O',
        'O   O'
    ],
    'nN': [
        'O   O',
        'O   O',
        'OO  O',
        'O O O',
        'O  OO',
        'O   O',
        'O   O'
    ],
    'oO': [
        ' OOO ',
        'O   O',
        'O   O',
        'O   O',
        'O   O',
        'O   O',
        ' OOO '
    ],
    'pP': [
        'OOOO ',
        'O   O',
        'O   O',
        'OOOO ',
        'O    ',
        'O    ',
        'O    '
    ],
    'qQ': [
        ' OOO ',
        'O   O',
        'O   O',
        'O   O',
        'O O O',
        'O  OO',
        ' OOO '
    ],
    'rR': [
        'OOOO ',
        'O   O',
        'O   O',
        'OOOO ',
        'O O  ',
        'O  O ',
        'O   O'
    ],
    'sS': [
        ' OOO ',
        'O   O',
        'O    ',
        ' OOO ',
        '    O',
        'O   O',
        ' OOO '
    ],
    'tT': [
        'OOOOO',
        '  O  ',
        '  O  ',
        '  O  ',
        '  O  ',
        '  O  ',
        '  O  '
    ],
    'uU': [
        'O   O',
        'O   O',
        'O   O',
        'O   O',
        'O   O',
        'O   O',
        ' OOO '
    ],
    'vV': [
        'O   O',
        'O   O',
        'O   O',
        'O   O',
        'O   O',
        ' O O ',
        '  O  '
    ],
    'wW': [
        'O   O',
        'O   O',
        'O   O',
        'O   O',
        'O O O',
        'O O O',
        ' O O '
    ],
    'xX': [
        'O   O',
        'O   O',
        ' O O ',
        '  O  ',
        ' O O ',
        'O   O',
        'O   O'
    ],
    'yY': [
        'O   O',
        'O   O',
        ' O O ',
        '  O  ',
        '  O  ',
        '  O  ',
        '  O  '
    ],
    'zZ': [
        'OOOOO',
        '    O',
        '   O ',
        '  O  ',
        ' O   ',
        'O    ',
        'OOOOO'
    ],
    ' ': [
        '     ',
        '     ',
        '     ',
        '     ',
        '     ',
        '     ',
        '     '
    ],
    '.': [
        '     ',
        '     ',
        '     ',
        '     ',
        '     ',
        '     ',
        '  O  '
    ],
    '?': [
        ' OOO ',
        'O   O',
        '    O',
        '   O ',
        '  O  ',
        '     ',
        '  O  '
    ],
    '!': [
        '  O  ',
        '  O  ',
        '  O  ',
        '  O  ',
        '  O  ',
        '     ',
        '  O  '
    ],
    '\u0000': [
        'OOOOO',
        'O   O',
        'OO OO',
        'O O O',
        'OO OO',
        'O   O',
        'OOOOO'
    ]
}
";

        private static readonly List<string> Formats = new List<string>();

        static GetDottified()
        {
            Formats.Add(SmallDots);
            Formats.Add(SolidDots);
        }

        /// <summary>
        /// The text that should be transformed, "dottified".
        /// </summary>
        [Parameter(
            Position = 0,
            ParameterSetName = "Text",
            Mandatory = true,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true
        )]
        public string Text { get => text; set => text = value; }


        /// <summary>
        /// The size/scale that should be used.
        /// </summary>
        [Parameter(
            ParameterSetName = "Size"
        )]
        [Alias("Scale")]
        public int Size
        {
            get => size;
            set
            {
                if (value <= 0)
                {
                    throw new InvalidOperationException("The size must be greater than zero, " + value + " is not.");
                }
                size = value;
            }
        }

        /// <summary>
        /// The formatting that should be used.
        /// </summary>
        [Parameter(
            ParameterSetName = "Format"
        )]
        public string Format
        {
            get => format;
            set
            {
                // One character formatting is always supported
                // Otherwise check for extra formattings
                if (value.Length != 1 && !Formats.Contains(value.ToLower()))
                {
                    throw new InvalidOperationException("Unsupported format: " + value);
                }
                format = value;
            }
        }

        /// <summary>
        /// Sets the font that should be used to output text. Expects a valid JSON string.
        /// </summary>
        public string Font {
            get => font;
            set
            {
                // Parse the json object
                JObject obj = JsonConvert.DeserializeObject<JObject>(value);
                Dictionary<char, string[]> newFontCharMap = new Dictionary<char, string[]>();
                foreach (var entry in obj)
                {
                    // Parse the char value as a string array
                    string[] format = entry.Value.ToObject<string[]>();
                    // Loop through every character in the key
                    foreach (char c in entry.Key.ToCharArray())
                    {
                        newFontCharMap[c] = format;
                    }
                }
                fontCharMap = newFontCharMap;
                font = value;
            }
        }

        private string text;
        private int size = 1;
        private string format = SmallDots;

        // Font related

        private string font;
        private Dictionary<char, string[]> fontCharMap;

        GetDottified()
        {
            // Apply the default font
            Font = DefaultFont;
        }

        protected override void ProcessRecord()
        {
            // The height of each character
            int charHeight = 7;
            // The spacing between each character
            int charSpacing = 2;
            // The height between each text line
            int lineSpacing = 2;

            // Convert all the text into dot rows
            // Step 1: Append all the characters into one grid of dots
            //         -> Each row is a string of dots, where 'O' represents a dot and ' ' (space) nothing
            // Step 2: Generate the braille unicodes based on the generated grid (if needed)

            // The list with rows
            List<string> dataLines = new List<string>();

            // The current y offset, depending on
            // the max height of the character format
            // The offset will be increased with each text line, separated by \n
            int yOffset = 0;

            // The max line length
            int maxLineLength = 0;

            // Use by default 'O' for formatting, will be replaced if using small dots
            char tempFormat = 'O';
            // If we need to use small dots, skip
            if (format.ToLower() != ":small-dots")
            {
                if (format.ToLower() == ":solid-dots")
                {
                    tempFormat = (char) 0x2022; // Bullet icon unicode
                }
                else
                {
                    tempFormat = format[0];
                }
            }

            // Write every line separately using newline
            foreach (string line in text.Split('\n'))
            {
                int length = 0;
                // Expands the dataLines list for the current y offset and char height
                while (dataLines.Count < (yOffset + charHeight * size)) {
                    dataLines.Add("");
                }
                // Whether it is the first character being written, used for spacing
                bool first = true;
                // Loop through all the characters in the input text
                foreach (char c in line)
                {
                    // Get the data for the given character
                    string[] charData = fontCharMap[c];
                    // Check if the character isn't missing
                    if (charData == null) {
                        charData = fontCharMap['\u0000'];
                    }
                    // Increase the current line length
                    length += charData[0].Length * size;
                }
            }
        }
    }
}
