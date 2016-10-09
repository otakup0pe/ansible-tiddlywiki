[![Maintenance](https://img.shields.io/maintenance/yes/2016.svg)]()

Ansible / TiddlyWiki 5
----------------------

One of the habits I've fallen into is using TiddlyWiki5 as a notepad. I use this role to install it on my workstations, which are all macs.

This role is entirely variable driven. A bunch of variables are shared between the instances you can define

* `tiddlywiki_install_directory` dictates where to install the Git cloned TW5 repo.
* `tiddlywiki_data_directory` dictates where to create the TW5 instances.
* `tiddlywiki_log_directory` is where launchd will create logs.
* `tiddlywiki_owner` is the user who will own these things.
* `tiddlywiki_group` is the group who will own these things.
* `tiddlywiki_ns_prefix` is the launchd namespace prefix.

You can then define numerous TiddlyWiki 5 instances in the `tiddlywiki_instances` variable. If you define none, then only TW itself will be installed.

```
tiddlwiki_instances:
- path: "/foo/tw"
  port: 8080
  edition: "server"
  name: "test"
...
```

# License

[MIT](https://github.com/otakup0pe/ansible-tiddlywiki/blob/master/LICENSE)

# Author

This Ansible role was created by [Jonathan Freedman](http://jonathanfreedman.bio/).
