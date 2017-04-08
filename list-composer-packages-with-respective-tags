#!/usr/bin/env zsh

foreach p in $(ls -U -1 -L -d $HOME/code/composer/*/); do 
  cd "$p"
  echo "- project : \"$(basename $p)\""
  echo -ne "  releases:\n$(git tag | sed -r 's/^(.+)/    - "\0"/')\n\n"
done
