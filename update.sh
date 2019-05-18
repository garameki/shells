

#!/user/bin/env bash
path=/home/pi
rm $path/packagesbefore
mv $path/packages $path/packagesbefore
#sudo apt-get update
#sudo apt-get upgrade
dpkg -l > $path/packages
diff $path/packages $path/packagesbefore > $path/packagesdiff
