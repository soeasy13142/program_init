load test_helper

PROJECT_INIT="/Users/charliepan/Downloads/imskills/bin/project-init"

setup() {
    cd /Users/charliepan/Downloads/imskills
}

# 构造一个“缺 envsubst”的 PATH：把 /bin /usr/bin 全部链接过去，再删掉 envsubst
make_fakebin() {
    fakebin="$1"
    mkdir -p "$fakebin"
    for d in /bin /usr/bin; do
        for f in "$d"/*; do
            [ -x "$f" ] && ln -s "$f" "$fakebin/$(basename "$f")" 2>/dev/null
        done
    done
    rm -f "$fakebin/envsubst"
}

@test "interactive mode without tty fails with clear guidance, no side effects" {
    tmpdir=$(mktemp -d)
    cd "$tmpdir"
    run "$PROJECT_INIT" -t cli-tool < /dev/null
    [ "$status" -eq 1 ]
    [[ "$output" == *"stdin 不是终端"* ]]
    [ ! -d "$tmpdir/.claude" ]
    rm -rf "$tmpdir"
}

@test "claude-only mode fails cleanly when envsubst missing, no partial files" {
    tmpdir=$(mktemp -d)
    fakebin="$tmpdir/fakebin"
    make_fakebin "$fakebin"
    cd "$tmpdir"
    run env PATH="$fakebin" "$PROJECT_INIT" -c -n demo
    [ "$status" -eq 1 ]
    [[ "$output" == *"Missing dependency: envsubst"* ]]
    [ ! -d "$tmpdir/.claude" ]
    [ ! -f "$tmpdir/CLAUDE.md" ]
    rm -rf "$tmpdir"
}

@test "full mode fails cleanly when envsubst missing" {
    tmpdir=$(mktemp -d)
    fakebin="$tmpdir/fakebin"
    make_fakebin "$fakebin"
    cd "$tmpdir"
    run env PATH="$fakebin" "$PROJECT_INIT" -n demo -t cli-tool -y
    [ "$status" -eq 1 ]
    [[ "$output" == *"Missing dependency: envsubst"* ]]
    [ ! -d "$tmpdir/.claude" ]
    rm -rf "$tmpdir"
}

@test "-y mode generates clean CLAUDE.md (no prompt pollution)" {
    tmpdir=$(mktemp -d)
    cd "$tmpdir"
    run "$PROJECT_INIT" -n demo -t cli-tool -y
    [ "$status" -eq 0 ]
    [ -f "$tmpdir/CLAUDE.md" ]
    grep -q "^# demo$" "$tmpdir/CLAUDE.md"
    grep -q "^- 语言: Shell$" "$tmpdir/CLAUDE.md"
    ! grep -q "项目名称" "$tmpdir/CLAUDE.md"
    rm -rf "$tmpdir"
}
