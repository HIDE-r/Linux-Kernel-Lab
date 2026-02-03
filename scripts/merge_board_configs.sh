#!/bin/bash

# Create the output directory if it doesn't exist
mkdir -p output

# Start the choice block in the output file
echo 'choice' > output/config-board.in
echo '	prompt "Board"' >> output/config-board.in

# Find all Config.in files under the board/ directory and append their content
find board -name "Config.in" -exec cat {} + >> output/config-board.in

# End the choice block
echo 'endchoice' >> output/config-board.in

