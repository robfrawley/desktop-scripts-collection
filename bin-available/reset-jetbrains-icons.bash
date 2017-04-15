#!/bin/bash

echo "rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/CLion/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/CLion/ch-0)/.icon.svg""
echo "rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0)/bin/webide.png""
echo "rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0)/.icon.svg""
echo "rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0)/.icon.svg""
echo "rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/PyCharm-P/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/PyCharm-P/ch-0)/.icon.svg""
echo "rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/RubyMine/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/RubyMine/ch-0)/.icon.svg""
echo "rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0)/.icon.svg""
echo "rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0)/bin/webstorm.svg""
echo "rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/datagrip/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/datagrip/ch-0)/.icon.svg""
echo "cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/clion.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/CLion/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/CLion/ch-0/)/.icon.svg""
echo "sed -i 's/Icon=.*/Icon=\/home\/rmf\/code\/icons\/numix-icon-theme-circle\/Numix-Circle\/scalable\/apps\/clion.svg/g' /home/rmf/.local/share/applications/CLion.desktop"
echo "cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/phpstorm.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0/)/.icon.svg""
echo "cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/phpstorm.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0/)/bin/webide.png""
echo "sed -i 's/Icon=.*/Icon=\/home\/rmf\/code\/icons\/numix-icon-theme-circle\/Numix-Circle\/scalable\/apps\/phpstorm.svg/g' /home/rmf/.local/share/applications/PhpStorm.desktop"
echo "cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/intellij-idea-ultimate-edition.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/)/.icon.svg""
echo "sed -i 's/Icon=.*/Icon=\/home\/rmf\/code\/icons\/numix-icon-theme-circle\/Numix-Circle\/scalable\/apps\/intellij-idea-ultimate-edition.svg/g' /home/rmf/.local/share/applications/IntelliJ\ IDEA\ Ultimate.desktop"
echo "cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/pycharm.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/PyCharm-P/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/PyCharm-P/ch-0/)/.icon.svg""
echo "sed -i 's/Icon=.*/Icon=\/home\/rmf\/code\/icons\/numix-icon-theme-circle\/Numix-Circle\/scalable\/apps\/pycharm.svg/g' /home/rmf/.local/share/applications/PyCharm\ Professional.desktop"
echo "cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/rubymine.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/RubyMine/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/RubyMine/ch-0/)/.icon.svg""
echo "sed -i 's/Icon=.*/Icon=\/home\/rmf\/code\/icons\/numix-icon-theme-circle\/Numix-Circle\/scalable\/apps\/rubymine.svg/g' /home/rmf/.local/share/applications/RubyMine.desktop"
echo "cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/webstorm.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0/)/.icon.svg""
echo "cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/webstorm.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0/)/bin/webstorm.svg""
echo "sed -i 's/Icon=.*/Icon=\/home\/rmf\/code\/icons\/numix-icon-theme-circle\/Numix-Circle\/scalable\/apps\/webstorm.svg/g' /home/rmf/.local/share/applications/WebStorm.desktop"
echo "cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/datagrip.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/datagrip/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/datagrip/ch-0/)/.icon.svg""
echo "sed -i 's/Icon=.*/Icon=\/home\/rmf\/code\/icons\/numix-icon-theme-circle\/Numix-Circle\/scalable\/apps\/datagrip.svg/g' /home/rmf/.local/share/applications/DataGrip.desktop"

rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/CLion/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/CLion/ch-0)/.icon.svg"
rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0)/bin/webide.png"
rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0)/.icon.svg"
rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0)/.icon.svg"
rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/PyCharm-P/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/PyCharm-P/ch-0)/.icon.svg"
rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/RubyMine/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/RubyMine/ch-0)/.icon.svg"
rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0)/.icon.svg"
rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0)/bin/webstorm.svg"
rm "/home/rmf/.local/share/JetBrains/Toolbox/apps/datagrip/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/datagrip/ch-0)/.icon.svg"

cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/clion.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/CLion/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/CLion/ch-0/)/.icon.svg"
sed -i 's/Icon=.*/Icon=\/home\/rmf\/code\/icons\/numix-icon-theme-circle\/Numix-Circle\/scalable\/apps\/clion.svg/g' /home/rmf/.local/share/applications/CLion.desktop

cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/phpstorm.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0/)/.icon.svg"
cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/phpstorm.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/PhpStorm/ch-0/)/bin/webide.png"
sed -i 's/Icon=.*/Icon=\/home\/rmf\/code\/icons\/numix-icon-theme-circle\/Numix-Circle\/scalable\/apps\/phpstorm.svg/g' /home/rmf/.local/share/applications/PhpStorm.desktop

cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/intellij-idea-ultimate-edition.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/IDEA-U/ch-0/)/.icon.svg"
sed -i 's/Icon=.*/Icon=\/home\/rmf\/code\/icons\/numix-icon-theme-circle\/Numix-Circle\/scalable\/apps\/intellij-idea-ultimate-edition.svg/g' /home/rmf/.local/share/applications/IntelliJ\ IDEA\ Ultimate.desktop

cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/pycharm.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/PyCharm-P/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/PyCharm-P/ch-0/)/.icon.svg"
sed -i 's/Icon=.*/Icon=\/home\/rmf\/code\/icons\/numix-icon-theme-circle\/Numix-Circle\/scalable\/apps\/pycharm.svg/g' /home/rmf/.local/share/applications/PyCharm\ Professional.desktop

cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/rubymine.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/RubyMine/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/RubyMine/ch-0/)/.icon.svg"
sed -i 's/Icon=.*/Icon=\/home\/rmf\/code\/icons\/numix-icon-theme-circle\/Numix-Circle\/scalable\/apps\/rubymine.svg/g' /home/rmf/.local/share/applications/RubyMine.desktop

cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/webstorm.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0/)/.icon.svg"
cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/webstorm.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/WebStorm/ch-0/)/bin/webstorm.svg"
sed -i 's/Icon=.*/Icon=\/home\/rmf\/code\/icons\/numix-icon-theme-circle\/Numix-Circle\/scalable\/apps\/webstorm.svg/g' /home/rmf/.local/share/applications/WebStorm.desktop

cp "/home/rmf/code/icons/numix-icon-theme-circle/Numix-Circle/scalable/apps/datagrip.svg" "/home/rmf/.local/share/JetBrains/Toolbox/apps/datagrip/ch-0/$(ls /home/rmf/.local/share/JetBrains/Toolbox/apps/datagrip/ch-0/)/.icon.svg"
sed -i 's/Icon=.*/Icon=\/home\/rmf\/code\/icons\/numix-icon-theme-circle\/Numix-Circle\/scalable\/apps\/datagrip.svg/g' /home/rmf/.local/share/applications/DataGrip.desktop
