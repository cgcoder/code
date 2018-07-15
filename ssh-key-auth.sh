# To create a new ssh key
ssh-keygen -t rsa -b 4096
# this create a public and private key file. add pub to ~/.ssh/authorized_keys file in remote machines or run below command to do the same
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@vlinux1
