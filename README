# stack: a bash scrip to manage your docker stacks
This script intends to simplify my docker apps management (stop, start, update...)

This script supposes that your docker apps are structured like the following:
```
DOCKER_APPS_ROOT_FOLDER
|-- app1
|   |-- data
|   |   |-- config
|   |   `-- redis
|   |-- docker-compose.yml
|   |-- .enabled
|   `-- .env -> ../.env
|-- app2
|   |-- data
|   |   `-- config
|   |-- docker-compose.yaml
|   |-- .enabled
|   `-- .env -> ../.env
....
|-- docker-compose.yaml.template
`-- .env

```
I choose this structure as I a not fan of a huge docker-compose file, so if you don't like it... this script is not for you :)

## Installation
### Automatic
```bash
curl https://raw.githubusercontent.com/gauth-fr/docker-stack/main/install.sh | sudo bash -s -- DOCKER_APPS_ROOT_FOLDER OWNING_USER
```
where:
- DOCKER_APPS_ROOT_FOLDER is the root folder where your apps will be stored
- OWNING_USER is the owner of those file (for some chown/chmod).

Feel free to check the script before running it, nothing complex is there, but still better to have a look before executing.

### Manual
Copy the `stack` script somewhere in your path (for instance, /usr/local/bin). 
Edit it and replace the placeholder ##DOCKER_FILES## with the path to your docker apps root folder.

If wanted, copy the `stack.completion` script to /etc/bash_completion.d/ and source it (or restart your session)

You can also run `stack init`, which will create a default .env file and a docker-compose.yaml template in your docker apps root folder.

## Usage
```bash
$ stack help
stack ACTION [STACKS LIST]
where:
    ACTION=     start|up  : Start the specified stacks
                stop|down : Stop the specified stacks
                restart   : Restart the specified stacks
                update    : Pull new images & restart if it was running
                enable    : Mark an as being always considered by 'all' (for start)
                disable   : Remove the 'enabled' flag
                pause     : Stops the specified stacks and marks for restart - Usefull for backup
                unpause   : Restart stacks marked by pause

    STACKS LIST= all       : Process all stacks
                List of containers   : stack1 stack2 stack3 ....
                default   : all

stack ACTION [STACK]
where:
    ACTION=     create|new    : Get status of stack apps
                delete|remove : List available stack
                edit : edit the docker-compose file of the specified app
    STACK=      Name of the stack to create/delete/edit
                In the case of 'edit', it can also be template or .env.

stack ACTION
where:
    ACTION=     status    : Get status of stack apps (can take some time as it queries containers)
                list      : List available stack
                init      : Initialize template and .env file
                help      : Display this help
```

## Examples

### Starting (all) apps
To start one or more containers, just provide a list of stack names (can be autocompleted when installed).

To start all containers, just specify `all`, or nothing. Note that only stacks that have been `enabled` will be started with `all`.  
For example, I have some tools like [firefox](https://github.com/jlesage/docker-firefox) or [netshoot](https://github.com/nicolaka/netshoot) and they should not start with all the server apps.

```bash
$ stack start all
$ stack start              # default is all
$ stack start app1 app2
```

### Stop app1 and app2
Just provide a list of apps, or `all` (or nothing, all being the default)
```bash
$ stack stop app1 app2
```

### Restart app1
Just provide a list of apps, or `all` (or nothing, all being the default)  
It will restart (docker-compose down & up) an app, only if it's currently running.
```bash
$ stack restart app1 app2
```

### Update app2 and app3
Just provide a list of apps, or `all` (or nothing, all being the default)  
It will pull the app last image and restart it, only if it's currently running.
```bash
$ stack update app2 app3
```

### Create a new stack app4
Just provide the name of the new app.
It will create the file structure for the new app, using the docker-compose.yaml.template file, and create a symlink to the .env file in the app folder.
```bash
$ stack create app4
```
In the above example, the following would be created:
```
|-- app4
|   |-- data
|   |   `-- config
|   |-- docker-compose.yml
|   |-- .enabled
|   `-- .env -> ../.env
```

### Edit app4
It allows you to directly edit the docker-compose.yaml file of an app.
The default editor is `vim` but it can be changed in the `stack` script  (on line 3)
```bash
$ stack edit app4
```
### Delete app4
It delete
```bash
$ stack delete app4
```

### List all apps
```bash
$ stack list
```

### Get the status of all apps
```bash
$ stack status
```

### Backup with autorestic
After trying many backup tools (kopia, borg, restic..), I stopped my choice on restic (with autorestic).
Autorestic allows pre and post hook, so for consistency purpose, before backing up, I stop everything then restart.
The backup is quite quick, so having a 2min outage at 2am is bearable.
Here is a `.autorestic.yml` sample.

Note that i run the backup as root, as i don't really know which user in the containers will create the runtime files and it may fail with a "basic " user.

```yaml
locations:
  docker-vm-docker-files:
    from: /opt/docker-files
    to:
      - mylocation
    forget: prune
    options:
      backup:
        exclude-file: /opt/docker-files/.exclude.backup
    hooks:
      before:
        -  /usr/local/bin/stack pause
        - 'curl -m 10 --retry 5 -X POST -H "Content-Type: text/plain" --data "Starting backup for location: ${AUTORESTIC_LOCATION}" https://hc-ping.com/abc/start'
      after:
        - /usr/local/bin/stack unpause
      failure:
        - 'curl -m 10 --retry 5 -X POST -H "Content-Type: text/plain" --data "Backup failed for location: ${AUTORESTIC_LOCATION}" https://hc-ping.com/abc/fail'
      success:
        - 'curl -m 10 --retry 5 -X POST -H "Content-Type: text/plain" --data "Backup successful for location: ${AUTORESTIC_LOCATION}" https://hc-ping.com/abc'
```


