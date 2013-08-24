# boot with ks=http://hostname/path/to/this_file.ks
# be aware of the firewall when you use any vm on windows
install
text
logging --level=debug
url --url http://ftp.jaist.ac.jp/pub/Linux/CentOS/6.4/os/x86_64/
lang en_US
keyboard jp106
timezone Asia/Tokyo
network --bootproto=dhcp --hostname=centos64.localdomain
authconfig --enableshadow --passalgo=sha512
rootpw hogehoge
user --name=admin --password=hogehoge
skipx
firewall --disabled
selinux --disabled
bootloader --location=mbr
zerombr
clearpart --all --initlabel
autopart
reboot

%packages

%post
sed -i 's/rhgb quiet//' /boot/grub/grub.conf
eject

