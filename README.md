## app dotfiles

for application dotfiles


Clone:
```
git clone git@github.com:pigeonhands/dotfiles.git ~/.dotfiles
```

Apply:
```
cd ~/.dotfiles && make apply
```

Only apply some configurations (grep):
```
make grep=zsh
```


## special files
| name | action|
|-----|------|
| .fold |  Symlink each item in directory (do not reccursively symlink files in sub-dirs) |
| .root |  Treat dir as if it was a root dotfiles dir |
