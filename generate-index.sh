#!/bin/bash

# Define input and output paths
OUTPUT_DIR="packaged"
INPUT_FILE="$OUTPUT_DIR/index.yaml"
OUTPUT_FILE="$OUTPUT_DIR/index.html"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

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

# Process the entries section of the YAML
chart_name=""
version=""
url=""

while IFS= read -r line; do
  # Check for chart name
  if [[ "$line" =~ ^[[:space:]]+([a-zA-Z0-9_-]+):$ ]]; then
    # Store chart name and reset variables
    chart_name="${BASH_REMATCH[1]}"
    version=""
    url=""
  fi

  # Check for version
  if [[ "$line" =~ ^[[:space:]]+version:[[:space:]](.+)$ ]]; then
    version="${BASH_REMATCH[1]}"
  fi

  # Check for URL
  if [[ "$line" =~ ^[[:space:]]+-[[:space:]](https://.+\.tgz)$ ]]; then
    url="${BASH_REMATCH[1]}"
  fi

  # If all details are available, add the chart to the HTML
  if [[ -n "$chart_name" && -n "$version" && -n "$url" ]]; then
    echo "      <li><strong>$chart_name</strong> - Version: $version - <a href=\"$url\">Download</a></li>" >> "$OUTPUT_FILE"
    # Reset version and URL to prepare for next entry
    version=""
    url=""
  fi
done < "$INPUT_FILE"

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
