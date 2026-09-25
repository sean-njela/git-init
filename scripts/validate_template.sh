#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

template_root="$tmp_root/template"
project_dir="$tmp_root/generated"
python3 "$repo_root/scripts/validate_contract.py"

mkdir -p "$template_root"
tar -C "$repo_root" --exclude=.git -cf - . | tar -C "$template_root" -xf -
git -C "$template_root" init -q
git -C "$template_root" config user.name "git-init validation"
git -C "$template_root" config user.email "git-init-validation@example.invalid"
git -C "$template_root" add .
git -C "$template_root" commit -q -m "test: record template fixture"

uvx copier copy "$template_root" "$project_dir" \
  --vcs-ref HEAD \
  --data 'project_name=Validation Project' \
  --data project_slug=validation-project \
  --data project_kind=service \
  --data profile=generic \
  --data 'project_description=Generated validation fixture' \
  --data 'license_holder=Validation Owner' \
  --defaults

for required_file in \
  README.md \
  LICENSE \
  CONTRIBUTING.md \
  SECURITY.md \
  CHANGELOG.md \
  Taskfile.yml \
  .project/project.yaml \
  spec/000_project-contract.md; do
  test -f "$project_dir/$required_file"
done

test ! -d "$project_dir/docs"
test ! -d "$project_dir/infra"
test ! -d "$project_dir/platform"

test -s "$project_dir/.copier-answers.yml"
test -s "$project_dir/.project/project.yaml"
test -s "$project_dir/spec/000_project-contract.md"
python3 "$repo_root/scripts/validate_contract.py" "$project_dir"


python3 - "$project_dir" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
markers = re.compile(r"\{\{[^}]+\}\}|<<<<<<<|=======|>>>>>>>")
for path in root.rglob("*"):
    if not path.is_file() or ".git" in path.parts or path.name == ".copier-answers.yml":
        continue
    text = path.read_text(encoding="utf-8")
    if markers.search(text):
        raise SystemExit(f"unresolved template or merge marker: {path}")
PY

git -C "$project_dir" init -q
git -C "$project_dir" config user.name "git-init validation"
git -C "$project_dir" config user.email "git-init-validation@example.invalid"
git -C "$project_dir" add .
git -C "$project_dir" diff --cached --check
git -C "$project_dir" commit -q -m "test: record generated project"

uvx copier update "$project_dir" \
  --vcs-ref HEAD \
  --defaults

python3 - "$project_dir" <<'PY'
from pathlib import Path
import re
import sys

root = Path(sys.argv[1])
markers = re.compile(r"<<<<<<<|=======|>>>>>>>")
for path in root.rglob("*"):
    if not path.is_file() or ".git" in path.parts or path.name == ".copier-answers.yml":
        continue
    text = path.read_text(encoding="utf-8")
    if markers.search(text):
        raise SystemExit(f"unresolved merge marker after update: {path}")
PY
python3 "$repo_root/scripts/validate_contract.py" "$project_dir"
(
  cd "$project_dir"
  task check
)


echo "Copier generation and update validation passed"
