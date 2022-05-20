# aliases added by abouts
alias ll="ls -al"
alias lll="ls -altHr"
export BASH_SILENCE_DEPRECATION_WARNING=1
export PS1='\u@\H:\w$ '

# added by Snowflake SnowSQL installer v1.2
export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH

# added by abouts @20May2022
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/abouts/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/abouts/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/abouts/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/abouts/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

