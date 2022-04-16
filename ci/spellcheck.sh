#!/usr/bin/env bash

aspell --version

for file in src/*; do
    command=$(sed '/^>/d;/^\$/d' "$file" | aspell list --lang=en_GB --ignore 3 --camel-case);
    if [ -n "$command" ]; then
        unique_errors=$(echo "$command" | tr ' ' '\n' | sort -u | tr '\n' ' ')
        for error in $unique_errors; do
            # FIXME: find more correct way to get line number
            # (ideally from aspell). Now it can make some false positives,
            # because it is just a grep.
            grep --with-filename --line-number --color=always "$error" "$file"
        done
    fi
done
