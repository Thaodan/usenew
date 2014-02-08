#compdef usenew
_arguments -s -S \
    --debug'[help debugging]' \
    {-h,--help}'[show help message]' \
    {-V,--version}'[show version]' \
    {-g,--gui}'[enable gui output]' \
    {-p,--prefix}'[ask for prefix]' \
    {-d,--desktop}'[start file/command in virtual desktop]' \
    '*:file or directory:_files'
# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
