# Synology notes and tips

## Mount disk
1. Connect with SSH
2. `sudo -i`
3. Display available disks: `fdisk -l`
4. Mount disk: `mount /dev/md10 /volume1/public/`

Notes: you can have a message *"mount: /volume1/public: unknown filesystem type 'linux_raid_member'."* with Basic disk. Use the following commands, assuming */dev/md10* does not exist:
1. `sudo -i`
2. Assemble the raid array: `mdadm --assemble --run /dev/md10 /dev/sda3`
3. if LVM -> Active volume group: `lvm vgscan` and `lvm vgchange -a y`
4. Display volume: `ll /dev/mapper`
5. Mount disk: `mount /dev/[disk or volume] /volume1/public/`

Stop it:
1. Unmount disk: `umount /volume1/public/`
2. if LVM -> Deactivate volume group: `vgchange -an /dev/mapper/vg1`
3. Stop RAID: `mdadm --stop /dev/md10`
