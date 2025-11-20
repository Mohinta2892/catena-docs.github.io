#!/usr/bin/env bash
set -euo pipefail

DOCS_DIR="${DOCS_DIR:-.}"
REPO_URL="https://github.com/your-org/your-repo"  # <- change me

echo "Debug: DOCS_DIR is set to: $DOCS_DIR"
echo "Debug: Current working directory: $(pwd)"
echo "Debug: Contents of current directory:"
ls -la

# Slugged module folder names (match your structure)
modules=(
  "local-shape-descriptors"
  "synful"
  "em-mask-generation"
  "mitochondria-segmentation"
  "neurotransmitter-classification"
  "proofreading"
  "visualize"
)

# Reusable templates
read -r -d '' DESIGN_CHOICES_TMPL <<'EOF' || true
# Design Choices

> This page explains the decisions we made, alternatives considered, trade-offs, and future work.

## Problem / Goal
What outcome are we optimizing for?

## Alternatives Considered
- Option A – pros/cons
- Option B – pros/cons
- Option C – pros/cons

## Decision
What we chose and why.

## Trade-offs
Compute, memory, DX, accuracy, portability, etc.

## Implementation Notes
Key parameters, scripts, data flow.

## Operational Guidance
Tuning tips, failure modes, troubleshooting.

## Future Work / Open Questions
What we plan to revisit and why.
EOF

read -r -d '' ROOT_INDEX <<'EOF' || true
# CATENA Documentation

Welcome to CATENA: an end-to-end, developer-friendly pipeline for large-scale connectomics.

Use the sidebar to browse each module. If you're new, start with **Getting Started**.

> Note: CATENA brings together neuron segmentation (LSDs), synapse detection (Synful), microtubule tracking, neurotransmitter classification, mitochondria segmentation, EM masking, and visualization tools.
EOF

read -r -d '' GETTING_STARTED <<'EOF' || true
# Getting Started

## Install
- Clone the repo
- Create the relevant conda env for the module you want to run
- See each module's **Overview** page for exact steps

## Modules
- Local Shape Descriptors (Neuron Segmentation)
- Synful (Synapse Detection)
- EM Mask Generation
- Mitochondria Segmentation
- Neurotransmitter Classification
- Proofreading
- Visualization (Napari, Neuroglancer)
EOF

# 1) Create docs skeleton
echo "Debug: Creating directory structure..."
mkdir -p "$DOCS_DIR/modules"
echo "Debug: Created $DOCS_DIR/modules"

# Check if index.md exists and create it
if [[ -f "$DOCS_DIR/index.md" ]]; then
  echo "Debug: $DOCS_DIR/index.md already exists"
else
  echo "Debug: Creating $DOCS_DIR/index.md"
  printf "%s\n" "$ROOT_INDEX" > "$DOCS_DIR/index.md"
  echo "Debug: Created $DOCS_DIR/index.md"
fi

# Check if getting-started.md exists and create it
if [[ -f "$DOCS_DIR/getting-started.md" ]]; then
  echo "Debug: $DOCS_DIR/getting-started.md already exists"
else
  echo "Debug: Creating $DOCS_DIR/getting-started.md"
  printf "%s\n" "$GETTING_STARTED" > "$DOCS_DIR/getting-started.md"
  echo "Debug: Created $DOCS_DIR/getting-started.md"
fi

for m in "${modules[@]}"; do
  mod_dir="$DOCS_DIR/modules/$m"
  echo "Debug: Processing module: $m (directory: $mod_dir)"
  
  mkdir -p "$mod_dir"
  echo "Debug: Created directory $mod_dir"
  
  # index.md
  if [[ ! -f "$mod_dir/index.md" ]]; then
    title="$(echo "$m" | sed -E 's/-/ /g; s/\<./\U&/g')"
    echo "Debug: Creating $mod_dir/index.md with title: $title"
    cat > "$mod_dir/index.md" <<EOF
# ${title}

Short overview of what this module does and links to usage.

- **Install & Usage:** See the module's README and scripts.
- **Design Choices:** See [Design Choices](design-choices.md) for the "why" behind the "what".
EOF
    echo "Debug: Created $mod_dir/index.md"
  else
    echo "Debug: $mod_dir/index.md already exists"
  fi
  
  # design-choices.md
  if [[ -f "$mod_dir/design-choices.md" ]]; then
    echo "Debug: $mod_dir/design-choices.md already exists"
  else
    echo "Debug: Creating $mod_dir/design-choices.md"
    printf "%s\n" "$DESIGN_CHOICES_TMPL" > "$mod_dir/design-choices.md"
    echo "Debug: Created $mod_dir/design-choices.md"
  fi
done

# 2) Create mkdocs.yml (idempotent with backup)
if [[ -f "mkdocs.yml" ]]; then
  echo "Debug: Backing up existing mkdocs.yml"
  cp mkdocs.yml mkdocs.yml.bak
fi

echo "Debug: Creating mkdocs.yml"
cat > mkdocs.yml <<EOF
site_name: CATENA
site_description: End-to-end pipelines for large-scale connectomics
repo_url: ${REPO_URL}
docs_dir: ${DOCS_DIR}

theme:
  name: material
  features:
    - navigation.instant
    - navigation.tracking
    - content.code.copy

markdown_extensions:
  - admonition
  - toc:
      permalink: true
  - pymdownx.details
  - pymdownx.superfences

nav:
  - Home: index.md
  - Getting Started: getting-started.md
  - Modules:
EOF

# Append modules to nav
for m in "${modules[@]}"; do
  title="$(echo "$m" | sed -E 's/-/ /g; s/\<./\U&/g')"
  cat >> mkdocs.yml <<EOF
      - ${title}:
          - Overview: modules/${m}/index.md
          - Design Choices: modules/${m}/design-choices.md
EOF
done

echo "Debug: mkdocs.yml created"

echo "✅ Scaffold complete in ${DOCS_DIR}/ and mkdocs.yml created."
echo "Next:"
echo "  python -m pip install mkdocs mkdocs-material"
echo "  mkdocs serve"

echo ""
echo "Debug: Final directory structure:"
find "$DOCS_DIR" -type f | head -20
