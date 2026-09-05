#!/usr/bin/env bash
# Renders a one-line-per-resource Terraform plan summary (ADD/CHANGE/DESTROY) to GITHUB_OUTPUT.
# Usage: render-plan-summary.sh <terraform_working_directory> <plan_file_name>
set -euo pipefail

terraform_working_directory="$1"
plan_file_name="$2"

plan_text_file="$(mktemp)"

terraform -chdir="$terraform_working_directory" show \
  -no-color "$plan_file_name" > "$plan_text_file"

plan_summary="$(awk '
  BEGIN {
    adds = ""
    changes = ""
    destroys = ""
  }

  /^  # / {
    line = $0
    sub(/^  # /, "", line)

    op = ""
    note = ""
    if (line ~ / will be created$/) {
      op = "add"
    } else if (line ~ / will be updated in-place$/) {
      op = "change"
    } else if (line ~ / will be destroyed$/) {
      op = "destroy"
    } else if (line ~ / must be replaced$/) {
      op = "change"
      note = " (recreate)"
    } else {
      next
    }

    addr = line
    sub(/ (will be created|will be updated in-place|will be destroyed|must be replaced)$/, "", addr)

    n = split(addr, parts, /\./)
    if (n < 2) {
      next
    }

    type = parts[n - 1]
    name = parts[n]

    icon = ""
    if (op == "add") {
      icon = "🟢"
    } else if (op == "change") {
      icon = "🟡"
    } else if (op == "destroy") {
      icon = "🔴"
    }

    output_line = sprintf("%s %s: resource \"%s\" \"%s\"%s", icon, toupper(op), type, name, note)

    if (op == "add") {
      adds = adds output_line "\n"
    } else if (op == "change") {
      changes = changes output_line "\n"
    } else if (op == "destroy") {
      destroys = destroys output_line "\n"
    }
  }

  END {
    if (adds != "") {
      printf "%s", adds
    }
    if (changes != "") {
      printf "%s", changes
    }
    if (destroys != "") {
      printf "%s", destroys
    }
  }
' "$plan_text_file")"

if [ -z "$plan_summary" ]; then
  if grep -q '^No changes\.' "$plan_text_file"; then
    plan_summary="No changes. Infrastructure is up-to-date."
  else
    plan_summary="Plan output could not be summarized into add/change/destroy lines. Check workflow logs for full details."
  fi
fi

rm -f "$plan_text_file"

# Use a random delimiter to safely handle any text in the plan output.
delimiter="$(openssl rand -hex 8)"
{
  echo "plan_summary<<${delimiter}"
  echo "$plan_summary"
  echo "${delimiter}"
} >> "$GITHUB_OUTPUT"
