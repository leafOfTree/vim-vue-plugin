#!/bin/sh
# Run all test cases, or the ones given as arguments, with vim and nvim if
# they are installed, or only the ones in $VUE_TEST_EDITORS. Vim runs in a
# pseudo terminal by `script`, as syntax in Ex mode (-es) isn't the same as
# in a terminal.
#   ./test/run.sh
#   ./test/run.sh basic template
#   VUE_TEST_EDITORS=nvim ./test/run.sh
cd "$(dirname "$0")/.." || exit 1
editors=${VUE_TEST_EDITORS:-vim nvim}

# Syntax plugins used by test/cases/example.vue, at fixed commits
mkdir -p test/deps
for dep in digitaltoad/vim-pug@ea39cd942cf3194230cf72bfb838901a5344d3b3 \
    kchmck/vim-coffee-script@28421258a8dde5a50deafbfc19cd9873cacfaa79 \
    leafgarland/typescript-vim@4740441db1e070ef8366c888c658000dd032e4cb \
    iloginow/vim-stylus@0e457b09db55d3518703bb22e1555872c5c44b7a; do
  repo=${dep%@*}
  commit=${dep#*@}
  dir=test/deps/${repo#*/}
  [ -d "$dir" ] && continue
  git init -q "$dir" &&
    git -C "$dir" fetch -q --depth 1 "https://github.com/$repo" "$commit" &&
    git -C "$dir" checkout -q FETCH_HEAD || exit 1
done

if [ $# -gt 0 ]; then
  cases=$*
else
  cases=$(ls test/cases/*.vue test/cases/*.wpy 2>/dev/null | sed 's#.*/##; s#\.[a-z]*$##')
fi

has_editor() {
  case " $editors " in
    *" $1 "*) command -v "$1" >/dev/null ;;
    *) return 1 ;;
  esac
}

out=$(mktemp)
status=0
expected=0
for name in $cases; do
  if has_editor vim; then
    expected=$((expected + 1))
    VUE_TEST_CASE=$name VUE_TEST_OUT=$out timeout 60 script -qec \
      'stty rows 40 cols 120; vim -N -u NONE -i NONE -S test/run.vim' \
      /dev/null >/dev/null || status=1
  fi
  if has_editor nvim; then
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
[ $expected -gt 0 ] || echo "No editor found in: $editors"
[ $expected -gt 0 ] && [ $failed -eq 0 ] && [ $missing -eq 0 ] || status=1
rm -f "$out"
exit $status
