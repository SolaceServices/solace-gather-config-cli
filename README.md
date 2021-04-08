# Solace gather configs

Script(s) to collect PubSub+ config and state for troubleshooting.

This is a Solace Professional Services addon tool and _not an offical Solace product_.

(C) Solace. **The code is not free for use.**

## Steps

``` txt

1) Unzip the gather-configs-<version>.zip file

2) FTP/SCP the following files under /usr/sw/jail/cliscripts on Solace PubSub+ Router
   gather-configs.cli
   gather-configs.sh

3) In Solace CLI 
   run gather-configs.cli
   Ignore any errors from the output
   solace-cli>  source script gather-configs.cli no-prompt

4) 
   4.1)
   To transfer files out with support login (SCP)
   In Solace support shell (or appuser shell on AWS) , 
   run gather-configs.sh
   solace-support$ sh  /usr/sw/jail/cliscripts/gather-configs.sh
   This will create output file under /tmp dir

   4.2) 
   To traner files out as ftp user
      run script overriding default output folder to jail/configs 
      eg: sudo sh  /usr/sw/jail/cliscripts/gather-configs.sh /usr/sw/jail/configs
      This will create the file on configs/ dir

 
5) 
   5.1) 
   If using support user SCP, upload /tmp/gather-configs_<hostname>_<timestamp>.tar.gz
   file to Solace filedrop

   5.2)
   If using SFTP user, 
   Upload the /usr/sw/jail/configs/gather-configs_<hostname>_<timestamp>.tar.gz file to solace support filedrop 
```

## Sample run

### Running on the Appliance

``` sh
$ ssh admin@lab-128-40
Password:

System Software. SolOS-TR Version 8.3.0.11

Copyright 2004-2017 Solace Corporation. All rights reserved.

lab-128-40> source script gather-configs.cli
lab-128-40> end

lab-128-40> home

lab-128-40> no paging
...

lab-128-40> en
lab-128-40# shell gather-configs

login: support
Password:
[support@lab-128-40 ~]$ sudo sh /usr/sw/jail/cliscripts/gather-configs.sh
[sudo] password for root:
Configs saved in: /usr/sw/jail/configs/gather-configs_lab-128-40_2019-03-01T01.03.56.tar.gz
```

### Running on AWS

``` sh

$ ssh -i <keyfile>.pem sysadmin@<public-ip-or-dns-name>
Solace PubSub+ Enterprise

The Solace PubSub+ software message broker is proprietary software of
Solace Corporation. By accessing the Solace PubSub+ software message broker
you are agreeing to the license terms and conditions located at
http://www.solace.com/license-software

[sysadmin@ip-172-31-7-6 ~]$
[sysadmin@ip-172-31-7-6 ~]$ solacectl cli

Solace PubSub+ Enterprise Version 8.13.0.30

The Solace PubSub+ Enterprise is proprietary software of
Solace Corporation. By accessing the Solace PubSub+ Enterprise
you are agreeing to the license terms and conditions located at
http://www.solace.com/license-software

Copyright 2004-2018 Solace Corporation. All rights reserved.

Operating Mode: Message Routing Node

ip-172-31-7-6> source script gather-configs.cli no-prompt

ip-172-31-7-6> end

ip-172-31-7-6> home

ip-172-31-7-6> no paging

ip-172-31-7-6> ! configs

ip-172-31-7-6> show hostname > /configs/show-hostname.out

...

ip-172-31-7-6> exit

[sysadmin@ip-172-31-7-6 ~]$ solacectl shell

The Solace PubSub+ Enterprise is proprietary software of
Solace Corporation. By accessing the Solace PubSub+ Enterprise
you are agreeing to the license terms and conditions located at
http://www.solace.com/license-software

[appuser@ip-172-31-7-6 ~]$
[appuser@ip-172-31-7-6 ~]$ sh  /usr/sw/jail/cliscripts/gather-configs.sh
Configs saved in: /usr/sw/jail/configs/gather-configs_ip-172-31-7-6.us-west-1.compute.internal_2019-03-01T00.03.17.tar.gz
[appuser@ip-172-31-7-6 ~]$ ls -l /usr/sw/jail/configs/gather-configs_ip-172-31-7-6.us-west-1.compute.internal_2019-03-01T00.03.17.tar.gz
-rw-r--r-- 1 appuser root 29394 Mar  1 00:45 /usr/sw/jail/configs/gather-configs_ip-172-31-7-6.us-west-1.compute.internal_2019-03-01T00.03.17.tar.gz
```

### Running on Docker

``` sh

$ docker exec -it <container-name> /usr/sw/loads/currentload/bin/cli -A

Solace PubSub+ Enterprise Version 9.0.0.17

The Solace PubSub+ Enterprise is proprietary software of
Solace Corporation. By accessing the Solace PubSub+ Enterprise
you are agreeing to the license terms and conditions located at
http://www.solace.com/license-software

Copyright 2004-2018 Solace Corporation. All rights reserved.

Operating Mode: Message Routing Node

6df6a1d62e77> source script gather-configs.cli no-prompt

6df6a1d62e77> end

6df6a1d62e77> home

6df6a1d62e77> no paging
...

$ docker exec -it <container-id> /bin/bash --login

The Solace PubSub+ Enterprise is proprietary software of
Solace Corporation. By accessing the Solace PubSub+ Enterprise
you are agreeing to the license terms and conditions located at
http://www.solace.com/license-software

[root@6df6a1d62e77 ~]# sh /usr/sw/jail/cliscripts/gather-configs.sh
Configs saved in: /usr/sw/jail/configs/gather-configs_6df6a1d62e77_2019-03-01T01.03.26.tar.gz
[root@6df6a1d62e77 ~]# ls -l /usr/sw/jail/configs/gather-configs_6df6a1d62e77_2019-03-01T01.03.26.tar.gz
-rw-r--r-- 1 root root 38120 Mar  1 01:43 /usr/sw/jail/configs/gather-configs_6df6a1d62e77_2019-03-01T01.03.26.tar.gz
```

### Using SFTP to get config files

``` sh
$ mkdir -p /tmp/lab-130-29-2019_04_15/{logs,configs}
$ cd /tmp/lab-130-29-2019_04_15
$ sftp ftpuser@lab-130-29:/logs/show-*.out logs/
    Solace PubSub+ 3260
    Password:
    Connected to lab-130-29.
    Fetching /logs/show-alarm.out to logs/show-alarm.out
    /logs/show-alarm.out                                                                                                          100%   62     0.6KB/s   00:00
    Fetching /logs/show-bridges.out to logs/show-bridges.out
    Fetching /logs/show-cfgsync-replication-bridge-detail.out to logs/show-cfgsync-replication-bridge-detail.out
    Fetching /logs/show-clients.out to logs/show-clients.out
    /logs/show-clients.out                                                                                                        100% 1530    15.3KB/s   00:00
    Fetching /logs/show-config-sync-database-detail.out to logs/show-config-sync-database-detail.out
    /logs/show-config-sync-database-detail.out                                                                                    100%  347     3.5KB/s   00:00
    Fetching /logs/show-config-sync-database-remote.out to logs/show-config-sync-database-remote.out
    /logs/show-config-sync-database-remote.out
...

$ sftp ftpuser@lab-130-29:/configs/show-*.out configs/
    Solace PubSub+ 3260
    Password:
    Connected to lab-130-29.
    Fetching /configs/show-access-level-detail.out to configs/show-access-level-detail.out
    /configs/show-access-level-detail.out                                                                                         100%  271     2.6KB/s   00:00
    Fetching /configs/show-aclprofiles.out to configs/show-aclprofiles.out
    /configs/show-aclprofiles.out                                                                                                 100%  454     4.4KB/s   00:00
    Fetching /configs/show-authentication.out to configs/show-authentication.out
/configs/show-authentication.out
...

$ cd ..
$ zip -q -r lab-130-29-2019_04_15.zip lab-130-29-2019_04_15/
$ ls -l lab-130-29-2019_04_15.zip
-rw-r--r--  1 nram  wheel  42631 Apr 15 20:27 lab-130-29-2019_04_15.zip
```

## About

### Authors

* [Ramesh Natarajan](mailto:ramesh.natarajan@solace.com), Solace PSG

### Resources

* [Solace CLI](https://docs.solace.com/Solace-CLI/Using-Solace-CLI.htm)
* [Solace Dev Portal](http://dev.solace.com)
* [Solace Documentation](http://docs.solace.com)
* [Solace Community](http://solace.community)
