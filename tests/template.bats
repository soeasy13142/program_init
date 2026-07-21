load test_helper

setup() {
    cd /Users/charliepan/Downloads/imskills
    . ./lib/helpers.sh
    . ./lib/template.sh
}

@test "render_template correctly replaces {{VAR}} placeholders" {
    tmpfile=$(mktemp /tmp/bats-template-XXXXXX)
    echo "Hello {{NAME}}!" > "$tmpfile"
    outfile=$(mktemp /tmp/bats-output-XXXXXX)

    run render_template "$tmpfile" "$outfile" "NAME=World"
    [ "$status" -eq 0 ]
    [ -f "$outfile" ]
    [ "$(cat "$outfile")" = "Hello World!" ]

    rm -f "$tmpfile" "$outfile"
}

@test "render_template handles nested placeholders (two rounds)" {
    tmpfile=$(mktemp /tmp/bats-template-XXXXXX)
    echo "{{OUTER}}" > "$tmpfile"
    outfile=$(mktemp /tmp/bats-output-XXXXXX)

    run render_template "$tmpfile" "$outfile" "OUTER=Hello {{INNER}}" "INNER=World"
    [ "$status" -eq 0 ]
    [ -f "$outfile" ]
    [ "$(cat "$outfile")" = "Hello World" ]

    rm -f "$tmpfile" "$outfile"
}

@test "render_template exits 1 when template not found" {
    run render_template "/tmp/nonexistent-template-xyz" "/tmp/output.txt" "NAME=test"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Template not found"* ]]
}

@test "render_template creates output directory automatically" {
    tmpfile=$(mktemp /tmp/bats-template-XXXXXX)
    echo "test {{VAR}}" > "$tmpfile"
    outdir=$(mktemp -d /tmp/bats-auto-dir-XXXXXX)
    outfile="$outdir/sub/output.txt"

    run render_template "$tmpfile" "$outfile" "VAR=value"
    [ "$status" -eq 0 ]
    [ -f "$outfile" ]
    [ "$(cat "$outfile")" = "test value" ]

    rm -f "$tmpfile"
    rm -rf "$outdir"
}
