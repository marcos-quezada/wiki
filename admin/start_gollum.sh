#!/usr/bin/env bash

# Configure
#setup include path
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then
    DIR="$PWD"
fi

source $HOME/.shell/functions.sh

create_variables $1

########### End of configuration section

## start plantuml server
### does not report if it fails -see the log
image_name="plantuml"
if [ ! "$(podman ps -q -f name=${image_name})" ]; then
    if [ "$(podman ps -aq -f status=exited -f name=${image_name})" ]; then
        # cleanup
        podman rm $image_name 
    fi
    # run your container
    podman run -d -p $config_plantuml_port:8080 --name $image_name  plantuml/plantuml-server:jetty
fi

# start gollum server
### does not report if it fails -see the log...
program="gollum"
proclive=`ps -ax |grep -E -e 'bin/ruby.*/bin/gollum' |grep -v 'grep'`

if [ "$proclive" ]; then
    id=`echo $proclive | awk '{print $1}'`
    echo "NOTICE: it appears that $program is already running with PID $id! Skipping startup for $program"
else
    cd $config_wikidir
    echo $config_gollum_plantuml_url
    command="nohup gollum --port $config_gollumport --config $config_gollumconfigfile --plantuml-url $config_gollum_plantuml_url --emoji --mathjax --live-preview --allow-uploads=page --collapse-tree --css --template-dir $config_templatedir"
    $command > /tmp/$program-serveri.log 2>&1 &
    echo "$!" > /tmp/$program-server.pid
fi


echo "start_gollum.sh: done."
