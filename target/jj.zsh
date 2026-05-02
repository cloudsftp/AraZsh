function __jj_prompt_jj() {
    command jj "$@"
}

function jj_current_branch() {}

function jj_prompt_short_id() {
    # --color always 
    ID=$(__jj_prompt_jj log --limit 1 --no-graph 2> /dev/null | head -n 1 | cut -d' ' -f1) \
        && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$ID$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}
