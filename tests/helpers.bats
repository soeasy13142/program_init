load test_helper

@test "log_info outputs correct prefix" {
    run log_info "test message"
    [ "$status" -eq 0 ]
    [[ "$output" == *"➜"* ]]
    [[ "$output" == *"test message"* ]]
}

@test "log_success outputs correct prefix" {
    run log_success "test message"
    [ "$status" -eq 0 ]
    [[ "$output" == *"✅"* ]]
    [[ "$output" == *"test message"* ]]
}

@test "log_warn outputs correct prefix" {
    run log_warn "test message"
    [ "$status" -eq 0 ]
    [[ "$output" == *"⚠️"* ]]
    [[ "$output" == *"test message"* ]]
}

@test "log_error outputs correct prefix" {
    run log_error "test message"
    [ "$status" -eq 0 ]
    [[ "$output" == *"✗"* ]]
    [[ "$output" == *"test message"* ]]
}

@test "colors are disabled when not a terminal" {
    [ -z "$GREEN" ]
    [ -z "$YELLOW" ]
    [ -z "$RED" ]
    [ -z "$CYAN" ]
}

@test "check_dependencies returns 0 for existing commands" {
    run check_dependencies echo
    [ "$status" -eq 0 ]
}

@test "check_dependencies returns 1 for missing commands" {
    run check_dependencies nonexistent_cmd_xyz
    [ "$status" -eq 1 ]
    [[ "$output" == *"Missing dependency"* ]]
}
