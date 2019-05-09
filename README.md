# Docker logs
Sometimes you just need to save container logs before any crash happens that causes the container (and its logs) to be destroyed.
This script hard links the log file of the container so if the container gets destroyed you still have a copy of the logs.

# Usage
```
bash master.sh [OPTIONS] container1 [,container2...]
```

# Options
```
-h Display help message
-r When a container from the list is not found, retry until it runs
-d Debug: remove log files created by the script
```

# Notes
If -r is set and one of the given container names is not found, this script will retry to hard link its log file until the container is found, blocking the execution for the following names
If -r is not set and any container is not found, it will just be skipped


# Docker inspect
This utility outputs a CSV (comma separated values) of all the containers running with their associated container id:

```
container-name-1,ID_1
...
container-name-N,ID_N
```
