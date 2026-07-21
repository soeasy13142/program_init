load test_helper

setup() {
    cd /Users/charliepan/Downloads/imskills
    . ./lib/helpers.sh
    . ./lib/questions.sh
}

@test "ask_project_name uses default value" {
    result=$(echo "" | ask_project_name "default-name")
    [[ "$result" == *"default-name"* ]]
}

@test "ask_project_type defaults to cli-tool" {
    result=$(echo "" | ask_project_type)
    [[ "$result" == *"cli-tool"* ]]
}

@test "collect_all complete flow outputs correct variables" {
    input="my project
1
A CLI tool description
Python, pytest
rule one
rule two
"
    result=$(echo "$input" | collect_all "default")
    [[ "$result" == *'PROJECT_NAME="my project"'* ]]
    [[ "$result" == *'PROJECT_TYPE="cli-tool"'* ]]
    [[ "$result" == *'PROJECT_DESCRIPTION="A CLI tool description"'* ]]
    [[ "$result" == *'TECH_STACK="Python, pytest"'* ]]
    [[ "$result" == *'- rule one'* ]]
    [[ "$result" == *'- rule two'* ]]
}
