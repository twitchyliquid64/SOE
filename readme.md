SOE
========

SOE is my collection of aliases, scripts, and customizations which I use on \*nix environments.


### First install

Copy-paste this into a terminal:

```shell
cd
git clone https://github.com/twitchyliquid64/SOE
. ~/SOE/entrypoint.sh
soe-help --system generate

# Setup persistently
echo '. ~/SOE/entrypoint.sh' >>~/.bashrc

# Optional
install-go
```

### Command help

Run `soe-commands` to see a list of SOE specific commands.

Run `soe-help <command>` to read the docs about any SOE specific command.
