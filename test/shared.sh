#!/bin/sh
# List shared-* test cases missing in either vim-svelte-plugin or
# vim-vue-plugin. Both plugins work in the same way for blocks, so a case for
# a scenario in one plugin should be in the other with the same name. Only
# warn, as the other plugin may be updated later
#   ./test/shared.sh
cd "$(dirname "$0")/.." || exit 1
other=vim-svelte-plugin

dir=test/other/$other
rm -rf "$dir"
git clone -q --depth 1 "https://github.com/leafOfTree/$other" "$dir" || exit 0

list() {
  ls "$1"/test/cases/shared-*.vim 2>/dev/null | sed 's#.*/##; s#\.vim$##' | sort
}
list . > test/other/mine
list "$dir" > test/other/theirs

missing=0
for name in $(comm -23 test/other/mine test/other/theirs); do
  echo "::warning::$name is not in $other"
  missing=1
done
for name in $(comm -13 test/other/mine test/other/theirs); do
  echo "::warning::$name in $other is not here"
  missing=1
done
[ $missing -eq 0 ] && echo "Shared cases are the same as $other"
exit 0
