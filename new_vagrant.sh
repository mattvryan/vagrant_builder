#!/usr/bin/env bash

vgdir=`dirname $0`

if [ "$#" -ne 1 ]; then
	echo "Usage: new_vagrant.sh <name>"
	exit 1
fi

[ -z $VAGRANT_HOME ] && VAGRANT_HOME=`pwd`

vagrant_name=$1
vagrant_dir=$VAGRANT_HOME/$vagrant_name

if [ -e $vagrant_dir ]; then
	echo "$vagrant_name already exists; aborting"
	exit 1
fi

mkdir $vagrant_dir

cp $vgdir/Vagrantfile.template $vagrant_dir/Vagrantfile

settings=.custom_settings.rb
psettings=$vagrant_name/$settings
before=.custom_before.rb
pbefore=$vagrant_name/$before
after=.custom_after.rb
pafter=$vagrant_name/$after
build=build.sh
pbuild=$vagrant_name/$build
first_login=first_login.sh
pfirst_login=$vagrant_name/$first_login
readme=README.txt
preadme=$vagrant_name/$readme

echo "# Provide a value for HOST_SRC_DIR below to map a host dir into the VM" > $psettings
echo "# HOST_SRC_DIR = '/path/to/host/src/dir'" >> $psettings
echo "To override any configuration variables, add them to $settings (e.g. HOST_SRC_DIR)." > $preadme

echo "# Add any code that should execute before the VM is built here" > $pbefore
echo "If you wish to execute any code prior to building the VM, add that to $before." >> $preadme

echo "# Add any code that should execute after the VM is built here" > $pafter
echo "If you wish to execute any code after the VM build is complete, add that to $after." >> $preadme

echo "mv ~/first_login.sh ~/.first_login.sh.deleteme" > $pfirst_login
echo "# Add any other code to run at first login here" >> $pfirst_login
echo "If you wish to execute any code the first time you log in to the VM, add that to $first_login." >> $preadme

echo "apt-get update" > $pbuild
#echo "if [ -f /vagrant/first_login.sh ]; then cp /vagrant/first_login.sh /home/vagrant/first_login.sh; fi" >> $pbuild
#echo 'echo "if [ -f ~/first_login.sh ]; then bash ~/first_login.sh; fi" >> /home/vagrant/.bashrc' >> $pbuild
#echo 'echo "rm -f ~/./first_login.sh.deleteme" >> /home/vagrant/.bash_logout' >> $pbuild
echo "# Add any other bootstrap commands here" >> $pbuild
echo "If you wish to add any custom VM build steps, you may add those to $build." >> $preadme

echo 
echo "Your new VM, '$vagrant_name', is ready to build.  To build it, cd to $vagrant_name and run 'vagrant up'."
echo "The $preadme file contains information on how to customize the execution of the VM build steps."
echo
echo "Happy Vagranting!"
echo


