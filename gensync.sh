#!/bin/sh
# As has been proven by multiple mishaps, it is imperative to have an rsync,
# as well as a periodic tarball archive, process going in multiple areas on
# my primary servers and development machines; this is going to be used to
# provide a more generic handling of this, after I get issues working at
# this current, simple level

# BUGS & CHANGES will be tracked in github

VERBOSE=2		# this will produce cron output (mail) every day in
			# quantity if set to 1 or higher
if [[ $VERBOSE = 2 ]] ; then
	MARK=1
fi

DEBUGGING=0		# suppresses rsync execution and echoes full command(s)

# installation dependent options
WHICH='/usr/bin/which'	# this one may need to be set manually

# RSYNC options
RSYNC=`$WHICH rsync`
RSYNC_VERBOSE_OPTS='-vHrltD'
RSYNC_QUIET_OPTS='-qHrltD'
RSYNC_CHMOD_OPTS='Du+rwx,go-rwx,Fu+rw'

# user/account/situational options
# you will need to go through these *ahem*
RMTHST='redacted'
RMTACCT='redacted'
RMTHSTDIR="redacted"

if [[ $VERBOSE -ge 1 ]] ; then
        echo -n RSYNC set to:
        echo $RSYNC
fi

# put it together-- whee, new knowledge in scripting for me!
#N=0
#eval "RSYNCV${N}=\"$RSYNC $RSYNC_VERBOSE_OPTS --chmod=Du+rwx,go-rwx,Fu+rw \""
RSYNC_FULL="$RSYNC $RSYNC_VERBOSE_OPTS --chmod=$RSYNC_CHMOD_OPTS "
if [[ $VERBOSE = 2 ]] ; then
	echo Mark $MARK
fi

#N=`expr $N + 1`
if [[ $VERBOSE = 2 ]] ; then
	MARK=`expr $MARK + 1`
	echo Mark $MARK
fi

# a couple of things I don't want to display here, but I don't think that
# this little bit of information leakage will destroy anything or allow
# straight up pwnage, as it's freely available information on the intertubes
# that I have a Synchronet BBS running
#eval "RSYNCV${N}=\"-e \'ssh -y -p 22 -i \\\"/sbbs/home/.ssh/id_rsa\\\" \' \" "
RSYNC_FULL="${RSYNC_FULL}-e 'ssh -y -p 22 -i \"/sbbs/.ssh/id_rsa\"' "
if [[ $VERBOSE = 2 ]] ; then
	MARK=`expr $MARK + 1`
	echo Mark $MARK
fi

#N=`expr $N + 1`
#eval "RSYNCV${N}=\"/sbbs redacted@192.168.2.100:/mishmash/archive/sbbs \""
RSYNC_FULL="${RSYNC_FULL}/sbbs ${RMTACCT}@${RMTHST}:${RMTHSTDIR}"
if [[ $VERBOSE = 2 ]] ; then
	MARK=`expr $MARK + 1`
	echo Mark $MARK
fi

#fucking nasty kludge
#SED_PATH='/usr/bin/sed'

#RSYNC_FULL="$SED_PATH -e 's/=/ /g' $RSYNC_FULL"

#bugs in the following commented out scripting
#for i in 0 1 2
#do
#	if [[ $VERBOSE = 2 ]]; then
#		MARK=`expr $MARK + 1`
#		echo Mark $MARK
#	fi
#	eval RSYNC_FULL="\"$RSYNC_FULL=\$RSYNCV${i}\""
#done

#RSYNCV="/usr/local/bin/rsync -vHrltD --chmod=Du+rwx,go-rwx,Fu+rw,go-rw -e "
#RSYNCV+="\"ssh -y -p 22 -i '/sbbs/home/.ssh/id_rsa'\" /sbbs/home "
#RSYNCV+="redacted@192.168.2.100:/redacted"
#RSYNCQ="/usr/local/bin/rsync -qHrltD --chmod=Du+rwx,go-rwx,Fu+rw,go-rw -e "
#RSYNCQ+="\"ssh -y -p 22 -i '/sbbs/home/.ssh/id_rsa'\" /sbbs/home "
#RSYNCQ+="redacted@192.168.2.100:/redacted"

# not implemented yet (in order to use this script wherever)
#BKUP_ORIGIN=/sbbs/home
#BKUP_TARGET=/redacted

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
	#	redacted@192.168.2.100:/mishmash/archive/sbbs || { \
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

# NOTE: On second thought, redacted's encrypted archival is on the SAME DAMN
# DRIVE as the encrypted partition that this VM resides on, so we're going to
# have to put that somewhere else, too.  ASAP, no more fucking failures!

