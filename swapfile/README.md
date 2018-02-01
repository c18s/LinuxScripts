# Automatically Create/Remove And Mount Swap File

![Swap file](https://raw.githubusercontent.com/c18s/LinuxScripts/master/swapfile/logo.png "Swap Logo")

----

[Swap file][1] As an alternative to creating an entire partition, a swap file offers the ability to vary its size on-the-fly, and is more easily removed altogether. This may be especially desirable if disk space is at a premium (e.g. a modestly-sized SSD). 

----

## Usage

### Create

Default swap size is 4G

```bash
curl https://raw.githubusercontent.com/c18s/LinuxScripts/master/swapfile/create_swap.sh | sh
```

Customize swap size (example: 2G)

```bash
curl https://raw.githubusercontent.com/c18s/LinuxScripts/master/swapfile/create_swap.sh | SIZE=2 create_swap.sh
```

### Remove

```bash
curl https://raw.githubusercontent.com/c18s/LinuxScripts/master/swapfile/remove_swap.sh | sh
```

### Tuning virtual memory

> vm.swappiness=5  
> vm.vfs_cache_pressure=50  
> vm.dirty_ratio=10  
> vm.dirty_background_ratio=5

```bash
curl https://raw.githubusercontent.com/c18s/LinuxScripts/master/swapfile/sysctl_swap.sh | sh
```

## Reference

- :octocat: <https://github.com/c18s/LinuxScripts/tree/master/swapfile>

[1]: https://wiki.archlinux.org/index.php/Swap#Swap_file
