#!/bin/gawk -f
BEGIN {
    FS="/"
    OFS=","
}
{
    split($NF, arr, ".txt")
    basename = arr[1]
    split(basename, arr, "_")
    # split title words
    n = patsplit(arr[1], titlearr, /[A-Z][^A-Z]+/)
    title = titlearr[1]
    for (i=2; i<=n; i++)
        title = title " " titlearr[i]
    # split name words
    n = patsplit(arr[2], namearr, /[A-Z][^A-Z]+/)
    name = namearr[1]
    for (i=2; i<=n; i++)
        name = name " " namearr[i]
    print name, $(NF-1), title, $0
}
