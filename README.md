[![Maintenance](https://img.shields.io/maintenance/yes/2018.svg)]()

Ansible / TiddlyWiki 5
----------------------

One of the habits I've fallen into is using TiddlyWiki5 as a notepad. I use this role to install it on a variety of systems. At this point in time, I am actively using this role on macOS, Windows (WSL), and assorted Linux servers.

NodeJS is required. The [ANXS.nodejs](https://github.com/anxs/nodejs) has treated me well.

# On a Workstation

It is recommended to install this as your own user. To do this, you will need to set the `tiddlywiki_install_directory`, `tiddlywiki_data_directory`, `tiddlywiki_log_directory` and `tiddlywiki_bin_directory`.

On macs, you may also wish to tweak the `tiddlywiki_ns_prefix` variable. This is uesd when generating launchctl configurations.

On Linux, you will want to set the `tiddlywiki_init_user` to be something that is not `root`.

On WSL, you will want to set the `tiddlywiki_pid_directory` as well.

# On a Server

Should work out of the box. YOLO.

# Configuration

This role is entirely variable driven. A bunch of variables are shared between the instances you can define

* `tiddlywiki_install_directory` dictates where to install the Git cloned TW5 repo.
* `tiddlywiki_data_directory` dictates where to create the TW5 instances.
* `tiddlywiki_log_directory` is where launchd will create logs.
* `tiddlywiki_owner` is the user who will own these things.
* `tiddlywiki_group` is the group who will own these things.
* `tiddlywiki_ns_prefix` is the launchd namespace prefix.
* `tiddlywiki_bin_directory` is where various helpers will be installed.
* `tiddlywiki_profile_path` is where bits to be included in your profile will be installed.
* `tiddlywiki_rc` allows you to control whether a profile snippet will be included
* `tiddlywiki_init_user` on a linux system you can use this to install a user-specific systemd bit, as opposed to system-wide
* `tiddlywiki_init_group` is used to set the ownership for init scripts. Can usually leave this default but may be helpful on non-root multi-user installs.
* `tiddlywiki_init_home` is the home directory base to use when installing systemd outside of the root context
* `tiddlywiki_pid_directory` is used by the WSL bits

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

This Ansible role was created by [Jonathan Freedman](http://jonathanfreedman.bio/) because he is a really big fan of TiddlyWiki and needs to write stuff down otherwise it is lost to the echos of time.
