#!/usr/bin/env bash

# Configure
#setup include path
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then
    DIR="$PWD"
fi

source $HOME/.shell/functions.sh

create_variables $1

# start gollum server
### does not report if it fails -see the log...
program="gollum"
proclive=`ps -ax |grep -E -e 'bin/ruby.*/bin/gollum' |grep -v 'grep'`

if [ "$proclive" ]; then
    id=`echo $proclive | awk '{print $1}'`
    echo "NOTICE: it appears that $program is already running with PID $id! Skipping startup for $program"
else
    cd $config_wikidir
    command="nohup gollum --port $config_gollumport --config $config_gollumconfigfile --emoji --mathjax --live-preview --allow-uploads=page --collapse-tree --css --template-dir $config_templatedir"
    $command > /tmp/$program-server.log 2>&1 &
    echo "$!" > /tmp/$program-server.pid
fi


echo "start_gollum.sh: done."
