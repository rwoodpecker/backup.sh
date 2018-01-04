# backup.sh

This backup script is used to automate the setup & execution of restic.

Currently, it uses [Restic](http://restic.readthedocs.io/) to back the home directory up to [Backblaze B2 Cloud Storage system](https://www.backblaze.com/b2/cloud-storage.html).

I use this script on a variety of linux boxes to keep a backup of my home directory. If you run it nightly via crontab, it will keep 1 week of daily backups, 1 month of weekly backups, & 6 months of yearly backups. Eventually, I'll make this configurable.

Run this the first time:

    > ~/bin/backup.sh setup # follow the prompts to set your B2 ID & key

Next, add this command to your crontab:

    > ~/bin/backup.sh backup

Finally, if you want to work with the repo, do this:

    > source ~/.restic/repo_config
    > export RESTIC_PASSWORD_FILE=~/.restic/passwd
    > export B2_ACCOUNT_ID B2_ACCOUNT_KEY RESTIC_REPOSITORY
    > restic check # example restic command
