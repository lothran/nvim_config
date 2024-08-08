#/bin/bash
for d in */ ; do
    echo linking $(realpath $d) ~/.config/$(basename $d)
    rm ~/.config/$(basename $d) 2> /dev/null
    ln -sfn $(realpath $d) ~/.config/$(basename $d)

    #ln -s $d 

done

