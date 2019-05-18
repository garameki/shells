LABEL=TOSHIBA		#USBメモリのラベル名です
BACKNAME=backup20181129	#任意の名前

getPATH() {
	echo ${3}
}

aa=$(mount -l | grep "\[$LABEL\]")
bb=$(getPATH $aa)

if [ $bb ]; then
	USB=$bb
	USBBACK=$USB/$BACKNAME
	echo $USBBACK

	sudo mkdir -p $USBBACK/pi
	sudo rsync -av /home/pi/.ssh $USBBACK/pi
	sudo rsync -av /home/pi/.vimrc $USBBACK/pi
	sudo rsync -av /home/pi/.bashrc $USBBACK/pi
	sudo rsync -av /home/pi/.bash_aliases $USBBACK/pi
	sudo rsync -av /home/pi/.gitconfig $USBBACK/pi
	sudo rsync -av /home/pi/backup.sh $USBBACK/pi
	sudo rsync -av /home/pi/packages  $USBBACK/pi
	sudo rsync -av /home/pi/public $USBBACK/pi
	sudo rsync -av --delete /home/pi/bin $USBBACK/pi
	sudo rsync -av --delete /home/pi/git $USBBACK/pi
	sudo rsync -av --delete /home/pi/www $USBBACK/pi
	sudo rsync -av --delete /home/pi/src $USBBACK/pi
	sudo rsync -av --delete /home/pi/stream  $USBBACK/pi
	sudo mkdir -p $USBBACK/etc
	sudo rsync -av /etc/ntp.conf $USBBACK/etc
	sudo rsync -av --delete /etc/apache2 $USBBACK/etc
	sudo rsync -av /etc/fstab $USBBACK/etc
	sudo rsync -av /etc/crontab $USBBACK/etc
	sudo rsync -av /etc/hosts $USBBACK/etc
	sudo rsync -av --delete /etc/ssl $USBBACK/etc
	sudo rsync -av --delete /etc/letsencrypt $USBBACK/etc
	sudo mkdir -p $USBBACK/var
	sudo mkdir -p $USBBACK/var/www
	sudo mkdir -p $USBBACK/var/www/html
	sudo rsync -av --delete /var/www/html/ $USBBACK/var/www/html
	sudo mkdir -p $USBBACK/var
	sudo mkdir -p $USBBACK/var/log
	sudo mkdir -p $USBBACK/var/log/apache2
	sudo rsync -av --delete /var/log/apache2/ $USBBACK/var/log/apache2
	sudo mkdir -p $USBBACK/var/spool
	sudo mkdir -p $USBBACK/var/spool/cron
	sudo rsync -av --delete /var/spool/cron/ $USBBACK/var/spool/cron
	sudo mkdir -p $USBBACK/boot
	sudo rsync -av /boot/config.txt $USBBACK/boot
else
	echo "NOT MOUNT USB MEMORY!!!"
fi
