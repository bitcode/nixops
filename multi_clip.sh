#!/usr/bin/env bash

# Check dependencies
if ! command -v xclip >/dev/null; then
   echo "xclip not found. Please install it and try again."
   exit 1
fi

# Initialize ignore list
ignore_list=""

# Parse options
while getopts ":i:" opt; do
  case $opt in
    i)
      ignore_list="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "Usage: $0 [-i ignore_list] file1 [file2 ...]"
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      echo "Usage: $0 [-i ignore_list] file1 [file2 ...]"
      exit 1
      ;;
  esac
done

shift $((OPTIND -1))

# Check if at least one file/directory is provided
if [ $# -eq 0 ]; then
   echo "Usage: $0 [-i ignore_list] file1 [file2 ...]"
   exit 1
fi

# Check if ignore list file exists (if specified)
if [ -n "$ignore_list" ] && [ ! -f "$ignore_list" ]; then
  echo "Error: Ignore list file '$ignore_list' not found."
  exit 1
fi

# Recursive function to process files
process_files() {
  local current_dir=$1

  for file in "$current_dir"/*; do
    # Handle case where glob doesn't match any files
    [ -e "$file" ] || continue

    should_ignore=false

    # Check against ignore list
    if [ -n "$ignore_list" ]; then
      while IFS= read -r pattern; do
        if [[ "$file" =~ $pattern ]]; then
          should_ignore=true
          break 
        fi
      done < "$ignore_list"
    fi

    if ! $should_ignore; then
      if [ -f "$file" ]; then
        combined_contents+=$(cat "$file")
        combined_contents+=$'\n'
      elif [ -d "$file" ]; then
        process_files "$file"  # Recurse into subdirectories
      fi
    fi
  done
}

# Start processing
combined_contents=""
for file in "$@"; do
  if [ -f "$file" ]; then
    combined_contents+=$(cat "$file")
    combined_contents+=$'\n'
  elif [ -d "$file" ]; then
    process_files "$file" 
  else
    echo "Warning: $file is not a file or directory. Skipping."
  fi
done

# Copy to clipboard
echo -n "$combined_contents" | xclip -selection clipboard

echo "Copied the contents of the provided files to clipboard."
