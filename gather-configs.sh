#/bin/bash
# archive config files into a zip
# Usage gather-config.sh [output-dir]

jaildir=""
[ -d /usr/sw/jail ] && jaildir=/usr/sw/jail
[ -d /var/lib/docker/volumes/jail/_data ] && jaildir=/var/lib/docker/volumes/jail/_data
[ -z $jaildir ] && {
   echo "Unable to find jail dir on this system"; exit 1; }
echo "Found jail dir: $jaildir"

outdir=${1:-/tmp}
[ -w $outdir ] || { echo $outdir is not writable by $(whoami); exit 1; }
echo "Using $outdir as output dir"

#outfile=$outdir/gather-configs_$(hostname)_$(date "+%Y-%m-%dT%H.%m.%S").zip
iname=$(hostname)_$(date "+%Y-%m-%dT%H.%m.%S")
outfile=$outdir/gather-configs_$iname.tar.gz
rm -f $outfile
tmpdir=$outdir/$iname
mkdir $tmpdir || { echo "Unable to create temp dir $tmpdir"; exit 1; }

cd $jaildir
#zip -q $outfile configs/show*.out logs/show*.out
cp -p configs/show*.out $tmpdir
cd $outdir
tar -czf $outfile $iname
if [ -f $outfile ]; then
	echo "Configs saved in: $outfile"
	# cleanup and exit
	rm -f configs/show*.out
	rm -rf $tmpdir
else
	echo "### ERROR saving output file $outfile ###"
	rm -rf $tmpdir
fi