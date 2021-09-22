#!/bin/bash

read_config() {
    source ~/.restic/repo_config
    export RESTIC_PASSWORD_FILE=~/.restic/passwd
    export B2_ACCOUNT_ID B2_ACCOUNT_KEY RESTIC_REPOSITORY
}

backup() {
    read_config
    restic backup /path/to/dir1 /path/to/dir2 --limit-upload=1000 --exclude=/path/to/.restic/exclude --cache-dir=/path/to/.restic/cache/
    restic forget --hostname $HOSTNAME --keep-daily 7 --keep-weekly 5 --keep-monthly 6
}

config() {
    read_config
    echo Repository: $RESTIC_REPOSITORY
}
setup() {
    which restic
    if [ $? -ne 0 ]; then
        echo restic is not installed. See installation instructions at:
        echo http://restic.readthedocs.io/en/latest/020_installation.html
        exit 1
    fi

    mkdir -p ~/.restic

    echo -n "Enter B2 Account ID: "
    read B2_ACCOUNT_ID

    echo -n "Enter B2 Account Key: "
    read -s B2_ACCOUNT_KEY

    RESTIC_REPOSITORY=b2:$B2_ACCOUNT_ID-restic:restic

    echo Saving repository config to ~/.restic/repo_config
    echo B2_ACCOUNT_ID=$B2_ACCOUNT_ID > ~/.restic/repo_config
    echo B2_ACCOUNT_KEY=$B2_ACCOUNT_KEY >> ~/.restic/repo_config
    echo RESTIC_REPOSITORY=$RESTIC_REPOSITORY >> ~/.restic/repo_config
    
    echo -n "Enter repository password: "
    read -s REPO_PASSWORD
    echo
    echo $REPO_PASSWORD > ~/.restic/passwd

    read_config
    restic check --no-lock

    if [ $? -ne 0 ]; then
        # TODO need to read input for password
        restic init
    fi
}

help() {
    echo Wrapper script for backing up the home directory to B2 with restic
    echo -e '\t' $0 backup: Execute a backup with restic.
    echo -e '\t' $0 config: Print the restic repository.
    echo -e '\t' $0 setup: Setup restic for backup to b2.
}

if [[ $1 =~ ^(backup|config|setup|help)$ ]]; then
  "$@"
else
  help
  exit 1
fi
