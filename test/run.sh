#!/bin/sh
# Run all test cases, or the ones given as arguments, with vim and nvim if
# they are installed. Vim runs in a pseudo terminal by `script`, as syntax
# in Ex mode (-es) isn't the same as in a terminal.
#   ./test/run.sh
#   ./test/run.sh basic template
cd "$(dirname "$0")/.." || exit 1

# Syntax plugins used by test/cases/example.vue
mkdir -p test/deps
for repo in digitaltoad/vim-pug kchmck/vim-coffee-script \
  leafgarland/typescript-vim iloginow/vim-stylus; do
  dir=test/deps/${repo#*/}
  [ -d "$dir" ] || git clone -q --depth 1 "https://github.com/$repo" "$dir"
done

if [ $# -gt 0 ]; then
  cases=$*
else
  cases=$(ls test/cases/*.vue test/cases/*.wpy 2>/dev/null | sed 's#.*/##; s#\.[a-z]*$##')
fi

out=$(mktemp)
status=0
expected=0
for name in $cases; do
  if command -v vim >/dev/null; then
    expected=$((expected + 1))
    VUE_TEST_CASE=$name VUE_TEST_OUT=$out timeout 60 script -qec \
      'stty rows 40 cols 120; vim -N -u NONE -i NONE -S test/run.vim' \
      /dev/null >/dev/null || status=1
  fi
  if command -v nvim >/dev/null; then
    expected=$((expected + 1))
    VUE_TEST_CASE=$name VUE_TEST_OUT=$out timeout 60 \
      nvim --headless -u NONE -i NONE -S test/run.vim || status=1
  fi
done

cat "$out"
passed=$(grep -c '^ok' "$out")
failed=$(grep -c '^FAIL' "$out")
missing=$((expected - passed - failed))
echo "$passed passed, $failed failed, $missing without result"
[ $failed -eq 0 ] && [ $missing -eq 0 ] || status=1
rm -f "$out"
exit $status
