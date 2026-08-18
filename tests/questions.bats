load test_helper

setup() {
    cd /Users/charliepan/Downloads/imskills
    . ./lib/helpers.sh
    . ./lib/questions.sh
}

# 交互函数的 stdout 必须只含数据值（提示符/菜单已改走 stderr）

@test "ask_project_name returns only the value (prompt goes to stderr)" {
    result=$(echo "my-app" | ask_project_name "default-name")
    [ "$result" = "my-app" ]
}

@test "ask_project_name uses default when input empty" {
    result=$(echo "" | ask_project_name "default-name")
    [ "$result" = "default-name" ]
}

@test "ask_project_type defaults to cli-tool" {
    result=$(echo "" | ask_project_type)
    [ "$result" = "cli-tool" ]
}

@test "ask_project_type maps choice 3 to web-app" {
    result=$(echo "3" | ask_project_type)
    [ "$result" = "web-app" ]
}

@test "ask_description returns the value only" {
    result=$(echo "A CLI tool" | ask_description)
    [ "$result" = "A CLI tool" ]
}

@test "ask_tech_stack returns the value only" {
    result=$(echo "Python, pytest" | ask_tech_stack)
    [ "$result" = "Python, pytest" ]
}

@test "ask_custom_rules collects lines until empty line" {
    result=$(printf "rule one\nrule two\n\n" | ask_custom_rules)
    [ "$result" = "- rule one
- rule two" ]
}

@test "collect_all outputs clean VAR lines without prompt text" {
    # 注意：结尾必须有一个显式空行来终止 ask_custom_rules 的规则循环
    input="my project
1
A CLI tool description
Python, pytest
rule one
rule two

"
    result=$(printf "%s" "$input" | collect_all "default")
    expected='PROJECT_NAME="my project"
PROJECT_TYPE="cli-tool"
PROJECT_DESCRIPTION="A CLI tool description"
TECH_STACK="Python, pytest"
CUSTOM_RULES="- rule one
- rule two"'
    [ "$result" = "$expected" ]
    [[ "$result" != *"项目名称"* ]]
    [[ "$result" != *"项目类型"* ]]
}
