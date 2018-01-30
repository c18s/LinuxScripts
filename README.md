# Automatically Create/Remove And Mount Swap File

![Dante](https://raw.githubusercontent.com/c18s/LinuxScripts/master/swapfile/logo.png "Swap Logo")

----

[Swap file][1] As an alternative to creating an entire partition, a swap file offers the ability to vary its size on-the-fly, and is more easily removed altogether. This may be especially desirable if disk space is at a premium (e.g. a modestly-sized SSD). 

----

## Usage

### Create

Default swap size is 4G

```bash
curl https://github.com/c18s/LinuxScripts/blob/master/swapfile/create_swap.sh | sh
```

Customize swap size (example: 2G)

```bash
curl https://github.com/c18s/LinuxScripts/blob/master/swapfile/create_swap.sh > create_swap.sh
sh ./create_swap.sh 2
```

### Remove

```bash
curl https://github.com/c18s/LinuxScripts/blob/master/swapfile/remove_swap.sh | sh
```

## Reference

- :octocat: <https://github.com/c18s/LinuxScripts/tree/master/swapfile>

[1]: https://wiki.archlinux.org/index.php/Swap#Swap_file
