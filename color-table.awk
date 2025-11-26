# Box border lines (top, header separator, bottom)
(/^┌/ || /^├/ || /^└/) {
    printf "\033[38;5;240m%s\033[0m\n", $0  # grey
    next
}

# Header row (the line with column names)
(/^│ cubrid_branch /) {
    printf "\033[1;36m%s\033[0m\n", $0      # bright cyan
    next
}

# "TIP:" lines
(/^TIP:/) {
    printf "\033[1;33m%s\033[0m\n", $0      # bright yellow
    next
}

# Separator lines made of '-' and ';'
(/^-+ *;$/ || /^-+$/ || /^;$/) {
    printf "\033[38;5;244m%s\033[0m\n", $0
    next
}

# Default: no color
{
    print
}

