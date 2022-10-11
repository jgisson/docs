
# Unix tips

Liste des services:
- `systemctl list-units --type=service`
- `service --status-all`

Taille des répertoires: 
`du -hs * | sort -rh | head -5`

Nombre de Thread pour un user:
`ps -u [USER] -o nlwp= | awk '{ num_threads += $1 } END { print num_threads }'`

Java Thread Dump
jstack [PID] > /tmp/threaddump.txt