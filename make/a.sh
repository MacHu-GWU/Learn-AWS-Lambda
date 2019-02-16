set_all()
{
    a="a.$1"
    b="b.$1"
    echo $@
}

set_all surfix nice
echo $a $b