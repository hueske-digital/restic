# Backups

This repository contains Restic – a fast, secure, efficient backup program.

## Requirements

Make sure that the [Base](https://gitlab.com/hueske-digital/services/base) is already set up and started.

## Setup instructions

Clone the code to your server:<br>
```
git clone git@gitlab.com:hueske-digital/services/backups.git ~/services/backups
```

Create environment file and fill up with your values:<br>
```
cd ~/services/backups && cp .env.example .env && vim .env
```

Pull images and start the compose file:<br>
```
docker compose up -d
```

Add the following label to all containers which should be backuped:<br>
```
    labels:
      backups: "true"
```

## Working with backups

To work with your backups check out this project and make sure that your `.env` file is configured according to your existing backups.

### Manual backup

```
docker compose exec backup backup
```

### See your existing backups

Execute this in this projects directory to see all existing snapshots:

```
docker compose exec backup restic snapshots
```

### Restore home dir

Execute this in this projects directory to restore the home dir:

```
docker compose exec backup restic restore --include /mnt/home --target / <SNAPSHOT ID>
```

If your user changed, you might have to adjust the user rights afterwards.


### Restore a volume

Execute this in this projects directory to restore a docker volume:

```
docker compose exec backup restic restore --include /mnt/volumes/name_of_volume --target / <SNAPSHOT ID>
```

The `--include` parameter can be repeated several times to restore multiple volumes at once.


## Other information

Update all container images and recreate them if new images are available:<br>
```
docker compose pull && docker compose up -d
```

Restart a single container:<br>
```
docker compose restart app
```

Shutdown all container of this compose file:<br>
```
docker compose down
```

Show and follow logs:<br>
```
docker compose logs -ft
```

Additional configuration:<br>
You can include any other docker config by using an additional [compose file](https://docs.docker.com/compose/extends/).
