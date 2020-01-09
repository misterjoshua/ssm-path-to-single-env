# Convert SSM parameters to a single dot-env style parameter

This script converts all SSM parameters from a given path prefix into a `.env` format and optionally puts the result into another named SSM parameter.

## Example Usage

**Output a `.env` file**
```
$ ./update.sh /dev/system-name/env
PARAMETER_NAME1=VALUE1
PARAMETER_NAME2=VALUE2
```

**Put the `.env` format to another SSM parameter**
```
$ ./update.sh /dev/system-name/env /dev/system-name/dot-env
```
