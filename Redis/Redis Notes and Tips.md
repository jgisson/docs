# Redis Notes and Tips

## Install : 
* MacOS: 
* Windows: NO Redis build, use WSL2 or Memurai

## Redis tools
### Redis CLI
* `redis-cli` | `redis-cli.exe`
* Tests Redis UP : `redis-cli -h [HOST] -p [PORT] PING`
* Redis with password: `redis-cli -a [PASSWORD] PING`
* List databases: `redis-cli INFO | grep ^db`

Redis commands:
* INFO: server information
* AUTH: Authentication. Exemple: `AUTH some_admin_user "PASSWORD"`
* SET: add cache. `SET mykey "Hello\nWorld"`
* GET: get cache. `GET mykey`
* DEL: delete cache. `DEL mykey1 mykey2 ...`

### Redis VS Code plugin
* Redis / Weijan Chen (database-client.com)
* View data
* Custom Terminal with Redis CLI
* Export/Import data

### IntelliJ with Database Tools and SQL plugin
* View data
* What else ?

## Databases : 
* The database provides a logically separated namespace for storing data
* CONFIG GET databases: databases config 
* INFO KEYSPACE: list databases
* SELECT [db-anme] : change default database
