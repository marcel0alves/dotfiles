#!/bin/bash
# Backup script for Gentoo Linux
# Copyright Reto Glauser aka Blinkeye
# Distributed under the terms of the GNU General Public License v2
# Mailto: stage4 at blinkeye dot ch
# Forum post: http://forums.gentoo.org/viewtopic-t-312817.html
# Date: 2005-06-30

version=v3.5
basename=`basename $0`

find=/usr/bin/find
tar=/bin/tar

# these are the commands we actually need for the backup
command_list=(cut date echo $find grep hostname mount sh split $tar umount uname which)

# verify that each command we use exists. if one can't be found use $PATH and make a suggestion if possible.
for command in ${command_list[@]}; do
   if [ ! -x "`which $command 2>&1`" ]; then
      echo -e "\nERROR: $command not found! "
      base=`basename $command`
       if [ "`which $base 2>&1 | grep "no \`basename $command\` in"`" != "" ]; then
          echo -e "ERROR: $base is not in your \$PATH."
       fi
       exit -1
   fi
done

help="\nUsage:\n\nsh `basename $0` [[-v]|[--verbose]] [[-s]|[--split]] \n\nTo run the script NOT in verbose mode comes in handy if you want to see only the errors that occur during the backup.\n"

# Defaults to creating one tarball

tar_output="--file"

# split command
split_options="--suffix-length=1 --bytes=685m"

# options for the tar command
tarOptions=" --preserve-permissions --create --absolute-names --totals --ignore-failed-read"

# where to put the stage4
stage4Location=/mnt/backups/stage4

# name prefix
stage4prefix=`hostname`-stage4-`date +\%Y.\%m.\%d`

# patterns which should not be backed up (like iso files).
# example: default_exclude_pattern="*.iso *.divx"
# These pattern count only for files NOT listed in the $custom_include_list.
default_exclude_pattern=""

# these files/directories are always excluded. don't add trailing slashes.
# don't touch it unless you know what you are doing!
# /var/db and /var/cache/edb are intentionally added here. they are listed
# in $default_include_folders
default_exclude_list="
/dev
/lost+found
/mnt
/proc
/sys
/tmp
/usr/portage
/usr/src
/var/log
/var/tmp
/var/db
/var/cache/edb
$stage4Location
`echo $CCACHE_DIR`"

# files/devices/folders, which need to be backed up (preserve folder structure).
# don't touch it unless you know what you are doing! no recursive backup of folders.
# use $default_include_folders instead.
default_include_files="
/dev/null
/dev/console
/home
/mnt
/proc
/sys
/tmp
/usr/portage
/usr/src
/var/log/emerge.log"

# folders, which need to be backed up recursively on every backup.
# don't touch it unless you know what you are doing! the reason for this
# variable is that some users add /var to the $default_exclude_list. here
# we ensure that portage's memory is backed up in any case.
default_include_folders="
/var/db"

# IMPORTANT: A minimal backup will EXCLUDE files/folders listed here. A custom backup will
# include/exclude these files/folders depening on your answer.
custom_include_list="
/home/*
/usr/src/*"

# add files/folders here which are subfolders of a folder listed in $custom_include_list which should NOT
# be backed up. eg.
#custom_exclude_list="/home/foo/mp3 /home/foo/downloads /home/foo/.*"
custom_exclude_list=""

# Only files/folders within the $custom_include_list are checked against these patterns
# custom_exclude_pattern="*.mp3 *.iso"
custom_exclude_pattern=""

# the find_command
find_command="$find /*"

# don't backup anything which matches pattern listed in $default_exclude_pattern
for pattern in $default_exclude_pattern; do
   find_command="$find_command -not -name $pattern"
done

# assemble the find_command
function find_files()
{
   for folder in $default_exclude_list; do
      find_command="$find_command -path $folder -prune -o"
   done

   find_command="$find_command -print"

   for i in $default_include_files; do
      find_command="echo $i; $find_command"
   done   

   for i in $default_include_folders; do
      if [ -d $i ]; then
         find_command="$find $i; $find_command"
      else
         find_command="echo $i; $find_command"
      fi      
   done
}

# check the exclude/include variables for non-existing entries
function verify()
{
   for i in $1; do
      if [ ! -e "`echo "$i" | cut -d'=' -f2 | cut -d'*' -f1`" -a "$i" != "/lost+found" -a "$i" != "$stage4Location" ]; then
         echo "ERROR: `echo "$i" | cut -d'=' -f2` not found! Check your "$2
         exit 0
      fi
   done   
}

# check input parameters
while [ $1 ]; do
   case  $1 in
   "-h" | "--help")
      echo -e $help
      exit 0;;
   "-v" | "--verbose")
      verbose=$1;;
   "-s" | "--split")
      tar_output="--split";;
   "");;
   *)
      echo -e $help
      exit 0;;
   esac
   shift
done

echo ""

# check folder/files listed in $default_exclude_list exist
verify "$default_exclude_list" "\$default_exclude_list"

# check files listed in $default_include_files exist
verify "$default_include_files" "\$default_include_files"

# check folder listed in $default_include_folders exist
verify "$default_include_folders" "\$default_include_folders"

#check folder listed in $custom_include_list exist
verify "$custom_include_list" "\$custom_include_list"

#check folder listed in $custom_exclude_list exist
verify "$custom_exclude_list" "\$custom_exclude_list"
 
# print out the version
 echo -e "\nBackup script $version"
 echo -e "=================="

# how do you want to backup?
echo -e "\nWhat do you want to do? (Use CONTROL-C to abort)\n
Fast (tar.gz):
 (1) Minimal backup
 (2) Interactive backup


Best (tar.bz2):
 (3) Minimal backup
 (4) Interactive backup\n"

while [ "$option" != '1' -a "$option" != '2' -a "$option" != '3' -a "$option" != '4' ]; do
   echo -en "Please enter your option: "
   read option
done

case $option in
[1,3])
   stage4Name=$stage4Location/$stage4prefix-minimal.tar;;

[2,4])
   stage4Name=$stage4Location/$stage4prefix-custom.tar

   for folder in $custom_include_list; do
      echo -en "\nDo you want to backup" `echo "$folder" | cut -d'=' -f2`"? (y/n) "
      read answer
      while [ "$answer" != 'y' -a "$answer" != 'n' ]; do
         echo -en "Do you want to backup" `echo "$folder" | cut -d'=' -f2`"? (y/n) "
         read answer
      done
      if [ "$answer" == 'n' ]; then
         find_command="$find_command -path $folder -prune -o"
      else
         custom_find="$find $folder"
         for i in $custom_exclude_pattern; do
            custom_find="$custom_find -name $i -o"
         done
         for i in $custom_exclude_list; do
            custom_find="$custom_find -path $i -prune -o"
         done
         find_command="$custom_find -print; $find_command"
      fi
   done ;;
esac

# add $custom_include_list to the $default_exclude_list as we assembled
# $custom_find with $custom_include_list already.
default_exclude_list="$default_exclude_list $custom_include_list"

case $option in
[1,2])
   stage4postfix="gz"
   zip="--gzip";;
   
[3,4])
   stage4postfix="bz2"
   zip="--bzip2";;
esac

# mount boot
echo -e "\n* mounting boot"
mount /boot >/dev/null 2>&1

# find the files/folder to backup
find_files
find_command="($find_command)"

# create the final command
if [ "$tar_output" == "--file" ]; then
   tar_command="$find_command | $tar $zip $tarOptions $verbose --file $stage4Name.$stage4postfix --no-recursion -T -"
else
   tar_command="$find_command | $tar $zip $tarOptions $verbose --no-recursion -T - | split $split_options - "$stage4Name.$stage4postfix"_"
fi

if [ "$verbose" ]; then
   echo -ne "\n* creating the stage4 in $stage4Location with the following command:\n\n"$tar_command
fi

# everything is set, are you sure to continue?
echo -ne "\nDo you want to continue? (y/n) "
read answer
while [ "$answer" != 'y' ] && [ "$answer" != 'n' ]; do
   echo -ne "Do you want to continue? (y/n) "
   read answer
done

if [ "$answer" == 'y' ]; then
   # check whether the file already exists.
   if [ "$tar_output" == "--split" ]; then
      overwrite="`ls "$stage4Name.$stage4postfix"_* 2>&1 | grep -v 'No such file'`"
   else
      overwrite="$stage4Name.$stage4postfix"
   fi
   
   if [ -a "`echo "$overwrite" | grep "$overwrite" -m1`" ]; then 
      echo -en "\nDo you want to overwrite $overwrite? (y/n) "
      read answer
      while [ "$answer" != 'y' ] && [ "$answer" != 'n' ]; do
         echo -en "Do you want to overwrite $overwrite? (y/n) "
         read answer
      done
      if [ "$answer" == 'n' ]; then
         echo -e "\n* There's nothing to do ... Exiting"
         exit 0;
      fi
   fi
   
   # if necessary, create the stage4Location
   if [ ! -d "$stage4Location" ] ; then
      echo "* creating directory $stage4Location"
      mkdir -p $stage4Location
   fi

   echo -e "\n* Please wait while the stage4 is being created.\n"

   # do the backup.   
   sh -c "$tar_command"
   
   # finished, clean up
   echo -e "\n* stage4 is done"
   echo "* umounting boot"
   umount /boot >/dev/null 2>&1

   # Integrity check
   echo -e "* Checking integrity"
   if [ "$zip" == "--gzip" ]; then
      zip="gzip"
   else
      zip="bzip2"
   fi   
   
   if [ "$tar_output" == "--split" ]; then
      if [ "`cat "$stage4Name.$stage4postfix"_*"" | $zip --test 2>&1`" != "" ]; then
         echo -e "* Integrity check failed. Re-run the script and check your hardware."
         exit -1
      fi
   else
      if [ "`$zip --test  $stage4Name.$stage4postfix 2>&1`" != "" ]; then
         echo -e "* Integrity check failed. Re-run the script and check your hardware."
         exit -1
      fi
   fi
   
   # everything went smoothly"
   echo -e "* Everything went smoothly. You successfully created a stage4."
   
else
   echo -e "\n* There's nothing to do ... Exiting"
fi

# Split the archive into chunks - uncomment the 3 lines if you want to split the stage4
# echo -e "* split $stage4Name.$stage4postfix"
# split $split_options $stage4Name.$stage4postfix "$stage4Name.$stage4postfix"_
# echo "* splitting is done"
