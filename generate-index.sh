#!/bin/bash

# Create the index.html file
OUTPUT_DIR="packaged"
mkdir -p "$OUTPUT_DIR"
OUTPUT_FILE="$OUTPUT_DIR/index.html"

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

# Parse index.yaml to extract chart names and latest versions
declare -A latest_versions
chart_name=""
version=""
while IFS= read -r line; do
  if [[ "$line" == "- name:"* ]]; then
    chart_name=$(echo "$line" | awk '{print $2}')
  elif [[ "$line" == "  version:"* ]]; then
    version=$(echo "$line" | awk '{print $2}')
    # Update the latest version for this chart
    if [[ -z "${latest_versions[$chart_name]}" || "$version" > "${latest_versions[$chart_name]}" ]]; then
      latest_versions["$chart_name"]="$version"
    fi
  fi
done < "$OUTPUT_DIR/index.yaml"

# Generate HTML list items for the latest versions
for chart in "${!latest_versions[@]}"; do
  echo "      <li><strong>$chart</strong> - Latest Version: ${latest_versions[$chart]}</li>" >> "$OUTPUT_FILE"
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
