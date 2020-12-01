# untar the gather-diags output
[ $# -lt 1 ] && { echo "missing argument. usage: $0 dir-with-gather-configs"; exit 1; }
tardir=$1
echo "Extracting gather-configs files from $tardir"
for file in $(ls $tardir/gather-configs*); do
    echo $file
    fname=${file##*/}
    fn=$(echo $fname|sed "s/T.*tar.gz$//g")
    dirname=$(echo $fn|sed "s/gather-configs_//g")
    mkdir $dirname
    cd $dirname
    tar xzf $file
    mv diags/* .
    rmdir diags
    cd ..
done
