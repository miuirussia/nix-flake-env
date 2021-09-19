# nix-flake-env

Consolidated nix environment

## Install `nix`

### macOS

In order to perform a multi-user install of `nix` on macOS, follow these steps.

The first order of business is to make sure `diskutil` is in your `$PATH`. If
it isn't, add it

```sh
$ export PATH=/usr/sbin:$PATH
```

Now you can go ahead and run the installer:

[Nix unstable installer](https://github.com/miuirussia/nix-unstable-installer)

This should take you throught the process in a nice and straight-forward way.

Once the installation finishes, it should print something like

Try it! Open a new terminal, and type:

```sh
nix-shell -p nix-info --run "nix-info -m"
```

It's possible that this won't work straight away, and you may get something like

```
error: could not set permissions on '/nix/var/nix/profiles/per-user' to 755: Operation not permitted
```

Don't worry. The issue is very likely that the `nix-daemon` isn't up and
running just yet. Give it a few seconds and try again.

**A note on SSL issues:** If you're getting errors like

```
Problem with the SSL CA cert
```

at later stages, there might be that `/etc/ssl/certs/ca-certificates.crt` is a
dead symlink. This can be fixed by removing that file and creating a new
symlink

```
sudo ln -s /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
```

***If you have some permission errors, then enable permissions on /nix volume:

```
sudo diskutil enableOwnership /nix
```

#### Flakes

Now we're ready to bootstrap and install the actual configuration. First, we
need to install `nixFlakes` in our environment.

```
$ nix-env -iA nixpkgs.nixFlakes
```

Then we need to edit `/etc/nix/nix.conf` and add:

```
experimental-features = nix-command flakes
```

Once that's done, we should be able to bootstrap the system with a minimal
configuration.

```sh
nix build .#darwinConfigurations.bootstrap.system
./result/sw/bin/darwin-rebuild switch --flake .#bootstrap
```

Open up a new terminal session and run

```
$ darwin-rebuild switch --flake .#<configuration-name>
```

Optional add overlays from env by creating `~/.config/nixpkgs/overlays.nix` with content:

```nix
let
  nix-flake-env = import (builtins.fetchTarball https://api.github.com/repos/miuirussia/nix-flake-env/tarball/master);
in
  nix-flake-env.pkgs.x86_64-darwin.overlays
```

Tada! Everything should be installed and ready to go.

**NOTE:** It's a good idea to make sure that any existing installation of
`nix-darwin` is uninstalled before you begin. There may be crap remaining in
`/etc/static`. Also, you should remeber to backup existing etc files

```
$ sudo mv /etc/bashrc /etc/bashrc.backup-before-darwin
$ sudo mv /etc/zshrc /etc/zshrc.backup-before-darwin
```

**NOTE 2:** It's also possible that you may have to backup `nix.conf` in order for
`nix-darwin` to be able to link it

```
$ sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.backup-before-darwin
```

**NOTE 3:** `nix-darwin` might also complain about linking `ca-certificates.crt`. That
stuff we may or may not have had to take care of earlier. Just back that up,
rebuild, and watch `nix-darwin` link it.

## Uninstall `nix`

### macOS

Kill the daemon process by running

```bash
  sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
```

Remove the mount from `/etc/fstab` by running 

```bash
  sudo vifs
```

and deleting the  line `LABEL=Nix\040Store /nix apfs rw,nobrowse`.

Delete the APFS volume using `diskutil` 

```bash
  diskutil apfs deleteVolume <volumeDevice>
```

***Note:*** `volumeDevice` can be found by running*

```bash
  diskutil list
```

Remove the synthetic empty directory for mounting at `/nix` by running 

```bash
  sudo vim /etc/synthetic.conf
```

  and deleting the line `nix`. 
  
Reboot the system for changes to take effect.

Run 

```bash
  echo "removing daemon"
  sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist

  echo "removing daemon created users and groups"
  USERS=$(sudo dscl . list /Users | grep nixbld)

  for USER in $USERS; do
      sudo /usr/bin/dscl . -delete "/Users/$USER"
      sudo /usr/bin/dscl . -delete /Groups/staff GroupMembership $USER;
  done

  sudo /usr/bin/dscl . -delete "/Groups/nixbld"

  echo "reverting system shell configurations"
  sudo mv /etc/profile.backup-before-nix /etc/profile
  sudo mv /etc/bashrc.backup-before-nix /etc/bashrc
  sudo mv /etc/zshrc.backup-before-nix /etc/zshrc

  echo "removing nix files"
  sudo rm -rf /nix
  sudo rm -rf /etc/nix
  sudo rm -rf /etc/profile/nix.sh
  sudo rm -rf /var/root/.nix-profile
  sudo rm -rf /var/root/.nix-defexpr
  sudo rm -rf /var/root/.nix-channels
  sudo rm -rf /var/root/.cache/nix
  rm -rf ~/.nix-profile
  rm -rf ~/.nix-defexpr
  rm -rf ~/.nix-channels
  rm -rf ~/.nixpkgs
  rm -rf ~/.config/nixpkgs
  rm -rf ~/.cache/nix
```

to remove all remaining `Nix` artifacts from the system.

[nix-darwin](https://github.com/LnL7/nix-darwin)
[home-manager](https://github.com/nix-community/home-manager)
