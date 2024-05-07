#!/bin/bash

# Create an empty file to store all watch history
> all_history.txt

# Loop over all json files in the current directory
for file in *.json
do
  # Use jq to parse the json and get the title, type, and episode number of each entry
  # Append the results to the all_history.txt file
  jq -r '.[] | .type + " " + (if .type == "movie" then .movie.title else .show.title + (if .episode.season != null and .episode.number != null then " S" + (.episode.season|tostring) + "E" + (.episode.number|tostring) else "" end) end)' "$file" >> all_history.txt
done

# Use sort and uniq -c to find duplicates and their counts
# Then use awk to filter out entries with count 1
sort all_history.txt | uniq -c | awk '$1 > 1' > duplicates.txt

rm all_history.txt

echo "The list of duplicates along with their counts has been saved to duplicates.txt"

cat duplicates.txt
