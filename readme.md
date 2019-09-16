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
soe-base-install # Does install-go internally
# install-go
```

### Command help

Run `soe-commands` to see a list of SOE specific commands.

Run `soe-help <command>` to read the docs about any SOE specific command.

### Useful commands

#### General

`extract <file>` - Auto-detects the archive format and extracts the contents.

`mktgz <directory>` - Makes a compressed tarball from the given directory.

`rnds` - Generates a 13-character random string.

`da` - Generates a string describing the current date/time in a human-friendly format.

`stamp` - Generates a short string describing the date/time.

`ff <file>` - Recursively searches for the given file (or similar).

`myip` - Returns my WAN IP address.

#### Installing software

`soe-base-install` - Installs a bunch of common utils.

`install-go` - Installs Go.

`install-bossa` - Installs BOSSA, the firmware flasher for a bunch of ARM boards.

#### Development

`gop_pwd` - Sets the GOPATH to the current working directory.

`git-push-ssh <keyfile> ...` - Runs git push but using the given ssh key to authenticate.

`git-ssh <keyfile> ...` - Runs the provided git subcommand + args, but using the given ssh key to authenticate.
