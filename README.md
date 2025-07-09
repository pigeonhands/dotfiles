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
