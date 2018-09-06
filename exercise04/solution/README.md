## SSH Access Utility

Enables SSH access for a provided list of public keys on a set of remote hosts.

To execute, provide one or more hosts to be updated and a file path containing the public keys to be granted access:

```bash
$ python ssh-access-util.py --hosts 127.0.0.1 localhost --keyfile ~/developer-keys
```

This script accepts the following configuration options:
```bash
$ python ssh-access-util.py --help
usage: ssh-access-util.py [-h] -rh HOSTS [HOSTS ...] -k KEYFILE [-u USER]
                          [-d DEST]

optional arguments:
  -h, --help            show this help message and exit
  -rh HOSTS [HOSTS ...], --hosts HOSTS [HOSTS ...]
                        One or more remote hosts where SSH access is to be
                        modified
  -k KEYFILE, --keyfile KEYFILE
                        File containing public keys whose SSH access should be
                        granted on the specified hosts
  -u USER, --user USER  User that will perform the SSH access modification on
                        the remote host
  -d DEST, --dest DEST  File destination to be replaced with new public key
                        content contained in provided `--keyfile` data
```


This script makes the following assumptions:

- The user running the script already has established SSH access to the hosts to be modified
- The user running the script has valid permissions on the remote host to perform the implemented actions
