# Shell functions that are too complex to live as one-liner aliases.

# diagram — render the first mermaid block in a markdown file and display it
# inline in the terminal. Defaults to ./README.md in the current directory.
#
# Uses mermaid.ink (a web service) to avoid the ~300MB chromium dependency
# that mermaid-cli requires. Needs internet.
#
# Requires: chafa (brew install chafa) or iTerm2's imgcat for inline display.
#
# Usage:
#   diagram                  # render ./README.md
#   diagram docs/setup.md    # render a specific file
diagram() {
  local src="${1:-README.md}"

  if [[ ! -f "$src" ]]; then
    print -u2 "diagram: file not found: $src"
    return 1
  fi

  # Extract the first ```mermaid ... ``` block.
  local mmd
  mmd=$(awk '
    /^```mermaid$/ { inblock=1; next }
    /^```$/ && inblock { exit }
    inblock { print }
  ' "$src")

  if [[ -z "$mmd" ]]; then
    print -u2 "diagram: no mermaid block found in $src"
    return 1
  fi

  # URL-safe base64 for mermaid.ink: https://mermaid.ink/img/<base64>
  local encoded
  encoded=$(printf '%s' "$mmd" | base64 | tr -d '\n' | tr '+/' '-_')

  local png
  png="$(mktemp -t diagram).png"

  if ! curl -fsSL "https://mermaid.ink/img/$encoded" -o "$png"; then
    print -u2 "diagram: failed to render via mermaid.ink (check connection)"
    rm -f "$png"
    return 1
  fi

  # Prefer imgcat (pixel-perfect) where available, fall back to chafa
  # (unicode art, works everywhere including SSH).
  if command -v imgcat >/dev/null 2>&1; then
    imgcat "$png"
  elif command -v chafa >/dev/null 2>&1; then
    chafa "$png"
  else
    print -u2 "diagram: install chafa to view inline — brew install chafa"
    print -u2 "         PNG saved at: $png"
    return 0
  fi

  rm -f "$png"
}
