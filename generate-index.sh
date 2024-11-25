#!/bin/bash

# Define input and output paths
OUTPUT_DIR="packaged"
INPUT_FILE="$OUTPUT_DIR/index.yaml"
OUTPUT_FILE="$OUTPUT_DIR/index.html"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Create a temporary sorted file
SORTED_FILE="$OUTPUT_DIR/sorted_index.yaml"

# Sort the index.yaml entries by chart name and version
yq -o=json '.' "$INPUT_FILE" | jq '.entries | to_entries | map({name: .key, versions: .value | sort_by(.version) | reverse})' > "$SORTED_FILE"

# Start writing the HTML file
cat <<EOF > "$OUTPUT_FILE"
<!DOCTYPE html>
<html>
<head>
  <title>Helm Repository</title>
  <style>
    body { font-family: 'Roboto', Arial, sans-serif; margin: 0; padding: 0; background: #ffffff; color: #333; }
    header { background-color: #0056b3; color: #fff; padding: 20px; text-align: center; }
    header h1 { margin: 0; font-size: 2.5em; }
    header p { font-size: 1em; margin: 10px 0 0; }
    main { padding: 20px; max-width: 800px; margin: auto; }
    ul { list-style: none; padding: 0; }
    li { background: #f9f9f9; margin: 10px 0; padding: 15px; border-radius: 10px; border: 1px solid #ddd; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); }
    li strong { color: #0056b3; }
    select { margin-top: 10px; padding: 5px; font-size: 14px; }
    a { color: #0056b3; text-decoration: none; font-weight: bold; }
    a:hover { text-decoration: underline; }
    footer { text-align: center; margin: 20px 0; color: #555; }
    footer a { color: #0056b3; text-decoration: none; font-weight: bold; }
    footer a:hover { text-decoration: underline; }
  </style>
</head>
<body>
  <header>
    <h1>Helm Repository</h1>
    <p>Discover the latest Helm charts and their versions</p>
  </header>
  <main>
    <ul>
EOF

# Generate HTML for each chart and its versions
jq -c '.[] | {name: .name, versions: .versions}' "$SORTED_FILE" | while read -r chart; do
  # Extract chart name
  chart_name=$(echo "$chart" | jq -r '.name')
  
  # Get the latest version
  latest_version=$(echo "$chart" | jq -r '.versions[0].version')
  latest_url=$(echo "$chart" | jq -r '.versions[0].urls[0]')

  # Add chart with the latest version
  echo "      <li><strong>$chart_name</strong> - Latest Version: $latest_version - <a href=\"$latest_url\">Download</a>" >> "$OUTPUT_FILE"

  # Start dropdown menu for other versions
  echo "        <select>" >> "$OUTPUT_FILE"
  echo "          <option>Select another version</option>" >> "$OUTPUT_FILE"
  
  # Add all other versions to the dropdown menu
  echo "$chart" | jq -c '.versions[]' | while read -r version_info; do
    version=$(echo "$version_info" | jq -r '.version')
    url=$(echo "$version_info" | jq -r '.urls[0]')
    echo "          <option value=\"$url\">Version $version</option>" >> "$OUTPUT_FILE"
  done
  
  # Close dropdown menu
  echo "        </select>" >> "$OUTPUT_FILE"
  echo "      </li>" >> "$OUTPUT_FILE"
done

# Finish the HTML file
cat <<EOF >> "$OUTPUT_FILE"
    </ul>
  </main>
  <footer>
    <p>Index File: <a href='index.yaml'>index.yaml</a></p>
  </footer>
</body>
</html>
EOF

echo "HTML file generated at $OUTPUT_FILE"
