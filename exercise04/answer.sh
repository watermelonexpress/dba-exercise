#i'm assuming the question meant to say "granting / revoking of SSH access to a group of users" not servers.

# i havent done this very often, as i wasnt admin of our internal server, and our EC2s didnt have much adminstration needed.
# This python script looks like it has everything needed:
# https://github.com/zalando-stups/even/blob/master/grant-ssh-access-forced-command.py

#if I had to do it in bash, i would script something along these lines, 
#and then call this script from another using the list of username/key_files

#sshd_confirm modification
if [ -f "/home/$username/.ssh/authorized_keys/$key_file" ]; then 
  #add user to /etc/ssh/sshd_config AllowUsers (if needed)
else:
  #remove user to /etc/ssh/sshd_config AllowUsers (if needed)
fi

#make sure permissions are correct
sudo chown -R $username:$username /home/$username/.ssh
sudo chmod 0700 /home/$username/.ssh
sudo chmod 0600 /home/$username/.ssh/authorized_keys

#restart the service (after all grant/revokes)
sudo /etc/init.d/sshd restart
