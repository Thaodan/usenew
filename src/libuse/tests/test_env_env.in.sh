# -*- sh -*-
libdir=@libsh_libdir@

cleanup()
{
    if [ ! "$INSPECT" ] ; then
        rm -rf "${test_root:?}"
    fi
}
cleanup

for signal in TERM HUP QUIT ERR; do
    trap "IID=1 cleanup; exit 1" $signal
done
unset signal
trap "IID=1 cleanup; exit 130" INT
