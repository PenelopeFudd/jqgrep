# jqgrep
JQGrep is a version of "grep" for JSON files!

## Usage:

```
Usage: jqgrep [-c|-k|-v|-o|-d] [-i|-m|-n|-p|-s|-x] pattern [json-files...]
  This program will search json files for the given pattern as a key or
  value and optionally print the jq command for retrieving it.

Options:
    -c: Show matches as jq commands
    -k: Only match keys
    -v: Only match values
    -o: Only show keys of matches
    -d: Only show values of matches
    -i: Case insensitive search
    -n: Ignore empty matches
    -s: Single line mode (´^´ -> ´\A´, ´$´ -> ´\Z´)
    -m: Multi line mode (´.´ will match newlines)
    -p: Both s and m modes are enabled
    -x: Extended regex format (ignore whitespace and comments)
```

## Examples:

```
$ ansible-inventory --list > a.json
$ jqgrep ansible_host a.json

a.json: ._meta.hostvars.["cs1"].ansible_host # cs1.example.com
a.json: ._meta.hostvars.["cads"].ansible_host # cads.example.com
a.json: ._meta.hostvars.["nfs-server"].ansible_host # nfs-server.example.com

$ jqgrep -c ansible_host a.json

jq '._meta.hostvars["cs1"].ansible_host' a.json # cs1.example.com
jq '._meta.hostvars["cads"].ansible_host' a.json # cads.example.com
jq '._meta.hostvars["nfs"].ansible_host' a.json # nfs-server.example.com
```
