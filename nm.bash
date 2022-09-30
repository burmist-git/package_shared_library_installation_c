#!/bin/bash

function nm_bash {

    liblist=$1
    
    for filename in $liblist ; do
	echo " "
	echo "----> $filename"
	nm -CD --defined-only $filename | awk '{if($2=="T"){{print }}}' | grep -v _fini | grep -v _init | nl
	echo " "
    done
    
}

nm_bash "./obj/*.so"
