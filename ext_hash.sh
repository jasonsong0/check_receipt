#!/bin/bash

# Base URL
base_url="http://127.0.0.1:26657/block_results?height="

# height  range
start_height=10848200
end_height=10849447

# extract and save all ethereumTxHash to temp file
temp_file=$(mktemp)

# loop each height
for height in $(seq $start_height $end_height)
do
    # parse json and extract hash
    curl -s "${base_url}${height}" | \
    jq -r '.result.txs_results[]?.events[]? | select(.type=="ethereum_tx") | .attributes[] | select(.key=="ethereumTxHash") | .value' >> "$temp_file"
done

# remove duplicated ethereumTxHash
sort "$temp_file" | uniq

# del tmp
rm "$temp_file"

