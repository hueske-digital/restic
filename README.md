# Backups

This repository contains Backrest – a fast, secure, efficient backup program with GUI.

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

Add the following label to all containers which should be stopped before the backup run:<br>
```
    labels:
      backups: "true"
```

## Configuration

### Port for proxy
```
9898
```

### Backup repository
`sftp:backup:/your/path/to/repo`

### Notifications

Configure the hooks in the Backrest GUI (_Plan -> Settings_) to send notifications like in the screenshot:<br>

| HOOK                                                       | Command                                  |
|------------------------------------------------------------|------------------------------------------|
| `CONDITION_SNAPSHOT_START`                                 | `bash -x /scripts/stop-container.sh`     |
| `CONDITION_SNAPSHOT_END`                                   | `bash -x /scripts/start-container.sh`    |
| `CONDITION_SNAPSHOT_WARNING`<br>`CONDITION_SNAPSHOT_ERROR` | `bash -x /scripts/report-status.sh down` |
| `CONDITION_SNAPSHOT_SUCCESS`                               | `bash -x /scripts/report-status.sh up`   |

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
