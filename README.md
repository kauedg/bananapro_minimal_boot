# bananapro_minimal_boot
Generates the minimal u-boot file to boot a Banana Pro board when the rootfs is in a SATA attached device. This allows the use of very small SD cards.

### Why
After transfering the rootfs to a SATA device the SD card is only used to "redirect" the boot process. 
Some may want to save the 16GB SD cards for other stuff and put smaller cards to this task. 
In my case, I had a 1GB SD card lying around and decided to use it for the boot process.
  
    
## When
Just after transfering your system from the SD card to a SATA device. [This is one resource](https://www.htpcguides.com/move-linux-banana-pi-sata-setup/) on how to do this. 
Make sure the system can boot without issues.
  
  
## How 
Clear the destination SD Card partition table, create one Linux partition and format it as an ext3 or ext4 filesystem. 
This partition may use the whole available space. 

```
$ cat <<EOT | sfdisk /dev/[small_device]
1,,L
EOT

$ mkfs.ext4 /dev/[small_device]
```

In my case it has only 200MB and the boot directory is only 40MB in size. You don't really need more than that.  
    
Copy the "/boot" directory from the original system into the newly created filesystem in the destination SD card.
```
$ sudo mkdir /mnt/bpro_source
$ sudo mount /dev/[big_device] /mnt/bpro_source

$ sudo mkdir /mnt/bpro_destination
$ sudo mount /dev/[small_device] /mnt/bpro_destination

$ cp -r /mnt/bpro_source/boot /mnt/bpro_destination/

$ sudo umount /mnt/bpro_source /mnt/bpro_destination 
```

Now is time to write the u-boot to the destination SD card. Clone this repository and then run:
```
$ cd bananapro_minimal_boot
$ sudo dd if=./data/u-boot-sunxi-with-spl.bin of=/dev/[small_device] bs=1024 seek=8
```
  
That's it. Now put the freshly created SD card in the BananaPro and boot.


## Advanced
I've made the build environment available for those who want to change the used branch of the u-boot repository or mess with other configurations. 
If you want/need to change anything you can...:

```
$ cd bananapro_minimal_boot
$ sudo docker build -t bananapro_minimal_boot .
$ sudo docker run -it -v "${PWD}/data":/data bananapro_minimal_boot /bin/bash
```

Being inside the container:
```
# cd /tmp/u-boot
# make CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
```
Make the changes you want and compile:
```
# make CROSS_COMPILE=arm-linux-gnueabihf-
# cp /tmp/u-boot/*.bin /data
# exit
```

And proceed to writing the boot image to the SD card.
  
  
### Resources:
https://sunxi.org/U-Boot#Compile_U-Boot  
https://sunxi.org/Bootable_SD_card#Cleaning
