import argparse
import subprocess

import paramiko


def get_args():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        '-rh',
        '--hosts',
        help='One or more remote hosts where SSH access is to be modified',
        nargs='+',
        required=True
    )

    parser.add_argument(
        '-k',
        '--keyfile',
        help='File containing public keys whose SSH access should be granted on the specified hosts',
        type=argparse.FileType('r'),
        required=True,
    )

    parser.add_argument(
        '-u',
        '--user',
        help='User that will perform the SSH access modification on the remote host',
        default='root'
    )

    parser.add_argument(
        '-d',
        '--dest',
        help='File destination to be replaced with new public key content contained in provided `--keyfile` data',
        default='~/.ssh/authorized_keys'
    )

    return parser.parse_args()


def get_remote_command(file_content, destination):
    return subprocess.list2cmdline(['printf', file_content, '>', destination])


def modify_remote_host_ssh_access(host, user, cmd):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(host, username=user)
    client.exec_command(cmd)
    client.close()


if __name__ == '__main__':
    args = get_args()
    remote_cmd = get_remote_command(args.keyfile.read(), args.dest)
    for host in args.hosts:
        modify_remote_host_ssh_access(host, args.user, remote_cmd)
