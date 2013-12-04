#!/bin/bash

# options
version=""
devbuild=0
sourceforge=0
force_pht_rebuild=0
force_pht_update=0
project=ION
arch=x86_64

#read default settings
settingsfile=~/.rasplex
[ -f "$settingsfile" ] && source "$settingsfile"

function usage {
    echo "$0 usage:
    [-h | --help]             : print this usage info
     -v | --version <version> : set the rasplex version
    [-d | --devbuild]         : create a developer build
    [-s | --sourceforge]      : upload the image to sourceforge
    [--user <user>]           : the sourceforge user to use
    
optional build options:
    -f       : will force a pht rebuild 

default options can be set via $settingsfile and will be evaluated first.
";
}

[ $# -eq 0 ] && usage && exit 1

while true; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--version)
            shift
            if [ -z $1 ]; then
                echo "version parameter missing!"
                exit 1
            fi
            version="$1"
            ;;
        -d|--devbuild)
            devbuild=1
            ;;
        -s|--sourceforge)
            sourceforge=1
            ;;
        --user)
            shift
            if [ -z $1 ]; then
                echo "user parameter missing!"
                exit 1
            fi
            user="$1"
            ;;
        -f)
            force_pht_rebuild=1
            ;;
        --)
            shift; break;;
        *)
            shift; break;;
    esac
    shift
done

# validate settings
[ -z "$version" ] && echo "Missing version number" && usage && exit 1

# setup variables
distroname="rasplex"
devtools="no"
if [ $devbuild -eq 1 ];then
    distroname="rasplexdev"
    devtools="yes"
    echo "This is a development build!"
fi

scriptdir=$(cd `dirname $0` && pwd)
outfilename="$distroname-$project.$arch-$version"
tmpdir="$scriptdir/tmp"
outimagename="$distroname-$version.img"
outimagefile="$tmpdir/$outimagename"
targetdir="$scriptdir/target"

# set rasplex config
echo "
RASPLEX_VERSION=\"$version\"
DISTRONAME=\"$distroname\"
" > $scriptdir/config/rasplex

sed s/SET_RASPLEXVERSION/"$version"/g $scriptdir/config/version.in > $scriptdir/config/version


# build
function build {
    echo "Building rasplex"

    source $scriptdir/config/version

    mkdir -p $scriptdir/build.rasplex-$project.$arch-$OPENELEC_VERSION/plexht-$project-$version
    if [ $force_pht_rebuild -eq 1 ]; then
        rm -r "$scriptdir/build.rasplex-$project.$arch-$OPENELEC_VERSION/.stamps/plexht"
    fi

    [ ! -e $scriptdir/plex-home-theater/ ] && git clone ~/Documents/src/plex-home-theater-public $scriptdir/plex-home-theater/
    git --git-dir=$scriptdir/plex-home-theater/.git  fetch  || echo "Could not fetch remote refs :("
    git --git-dir=$scriptdir/plex-home-theater/.git checkout $project-$version || echo "Cannot checkout $project-$version"
    git --work-tree=$scriptdir/build.rasplex-$project.$arch-$OPENELEC_VERSION/plexht-$project-$version  --git-dir=$scriptdir/plex-home-theater/.git checkout $project-$version -- . || echo "Cannot checkout to work-tree"

    time DEVTOOLS="$devtools" PROJECT=$project ARCH=$arch make release -j `nproc` || exit 2
}

# create image file
function create_image {
    echo "Creating VM image"
    mkdir -p $tmpdir
    rm -rf $tmpdir/*
    cp "$targetdir/$outfilename".tar $tmpdir
    
    echo "  Extracting release tarball..."
    tar -xpf "$tmpdir/$outfilename".tar -C $tmpdir
    
    echo "  Write data to image..."
    cd $tmpdir/$outfilename
    sudo ./create_virtualimage "$tmpdir" 2048 
    
    echo "Created SD image at $tmpdir"
}


function upload_sourceforge {
    projectdir="/home/frs/project/rasplex"
    projectdlbase="http://sourceforge.net/projects/rasplex/files"
    [ -z "$user" ] && user=`whoami`
    
    echo "Distributing build"
    
    cd "$tmpdir"

    echo "  compressing image..."
    gzip "$outimagefile"
    
    echo "  uploading autoupdate package"
    time scp "$outfilename".tar "$user@frs.sourceforge.net:$projectdir/autoupdate/$distroname/"
     
    echo "  uploading install image"
    if [ $devbuild -eq 1 ];then
        releasedir="development"
    else
        releasedir="release"
    fi
    time scp "$outimagefile.gz" "$user@frs.sourceforge.net:$projectdir/$releasedir/"    
}

# main

build
create_image

if [ $sourceforge -eq 1 ]; then
    upload_sourceforge
fi

echo "done."


