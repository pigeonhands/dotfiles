## app dotfiles

for dotfiles outside of nixos-dotfiles


script:
```
curl -sSf https://raw.githubusercontent.com/pigeonhands/dotfiles/refs/heads/master/setup/setup.sh | sh
```

Clone:
```
git clone git@github.com:pigeonhands/dotfiles.git ~/.app-dotfiles
```

Apply:
```
cd ~/.app-dotfiles && stow */
```


## special files
| name | action|
|-----|------|
| .fold |  Symlink each item in directory (do not reccursively symlink files in sub-dirs) |
| .root |  Treat dir as if it was a root dotfiles dir |
