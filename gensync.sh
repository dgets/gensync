#!/bin/sh
# So I lost the entirety of my 'sbbs.ini' file thanks to not having a proper
# backup today, while trying to configure everything to work properly for my 
# fidonet/binkd setup in order to take over the position as R14C.  Let's not
# let that happen again.  We're gonna rsync to phoenix's encrypted archival.

VERBOSE=1		# this will produce cron output (mail) every day in
			# quantity if set to 1
if [[ $VERBOSE = 2 ]] ; then
	MARK=1
fi

DEBUGGING=1		# suppresses rsync execution and echoes full command(s)

RSYNC='/usr/local/bin/rsync'
RSYNC_VERBOSE_OPTS='-vHrltD'
RSYNC_QUIET_OPTS='-qHrltD'

if [[ $VERBOSE -ge 1 ]] ; then
        echo -n RSYNC set to:
        echo $RSYNC
fi

# put it together-- whee, new knowledge in scripting for me!
N=0
eval "RSYNCV${N}=\"$RSYNC $RSYNC_VERBOSE_OPTS --chmod=Du+rwx,go-rwx,Fu+rw \""
if [[ $VERBOSE = 2 ]] ; then
	echo Mark $MARK
fi

N=`expr $N + 1`
if [[ $VERBOSE = 2 ]] ; then
	MARK=`expr $MARK + 1`
	echo Mark $MARK
fi

eval "RSYNCV${N}=\"-e 'ssh -y -p 22 -i \"/sbbs/home/.ssh/id_rsa\"' \""
if [[ $VERBOSE = 2 ]] ; then
	MARK=`expr $MARK + 1`
	echo Mark $MARK
fi

N=`expr $N + 1`
eval "RSYNCV${N}=\"/sbbs khelair@192.168.2.100:/mishmash/archive/sbbs \""
if [[ $VERBOSE = 2 ]] ; then
	MARK=`expr $MARK + 1`
	echo Mark $MARK
fi

#fucking nasty kludge
SED_PATH='/usr/bin/sed'

RSYNC_FULL=$SED_PATH -e 's/=/\0/g' \""$RSYNC_FULL\""

#bugs in the following commented out scripting
for i in 0 1 2
do
	if [[ $VERBOSE = 2 ]]; then
		MARK=`expr $MARK + 1`
		echo Mark $MARK
	fi
	eval RSYNC_FULL="\"$RSYNC_FULL=\$RSYNCV${i}\""
done

#RSYNCV="/usr/local/bin/rsync -vHrltD --chmod=Du+rwx,go-rwx,Fu+rw,go-rw -e "
#RSYNCV+="\"ssh -y -p 22 -i '/sbbs/home/.ssh/id_rsa'\" /sbbs/home "
#RSYNCV+="khelair@192.168.2.100:/mishmash/archive/sbbs"
#RSYNCQ="/usr/local/bin/rsync -qHrltD --chmod=Du+rwx,go-rwx,Fu+rw,go-rw -e "
#RSYNCQ+="\"ssh -y -p 22 -i '/sbbs/home/.ssh/id_rsa'\" /sbbs/home "
#RSYNCQ+="khelair@192.168.2.100:/mishmash/archive/sbbs"

# not implemented yet (in order to use this script wherever)
#BKUP_ORIGIN=/sbbs/home
#BKUP_TARGET=/mishmash/archive/sbbs

if [[ $VERBOSE -ge 1 ]] ; then
	echo -n Starting backup of /sbbs directory.  No more data losses, 
	echo ' por dios.'

	if [[ $DEBUGGING = 0 ]] ; then
		echo $RSYNC_FULL
		$RSYNC_FULL || {
			echo WARNING: rsync process exited abnormally!
			echo This almost certainly means backup of sbbs failed!
		}
	else
		echo Full rsync command line:
		echo -=-=-=-
		echo $RSYNC_FULL
		echo -=-=-=-
	fi

	#/usr/local/bin/rsync -vHrltD --chmod=Du+rwx,go-rwx,Fu+rw,go-rw -e \
	#	"ssh -y -p 22 -i '/sbbs/home/.ssh/id_rsa'" /sbbs/home \
	#	khelair@192.168.2.100:/mishmash/archive/sbbs || { \
	#		echo WARNING: rsync process exited abnormally; \
	#		echo This probably means a failure in backup of sbbs; \
	#	}

	echo rsync backup process of sbbs completed
#else
#	$RSYNC_FULL || {
#		echo WARNING: rsync process exited abnormally!
#		echo This almost certainly means backup of sbbs failed!
#	}
fi

# NOTE: On second thought, phoenix's encrypted archival is on the SAME DAMN
# DRIVE as the encrypted partition that this VM resides on, so we're going to
# have to put that somewhere else, too.  ASAP, no more fucking failures!

