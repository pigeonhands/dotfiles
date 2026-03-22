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

## encrypted files

Files ending in `.age` are decrypted on apply and symlinked from `.dotfiles-cache/`.

**Setup:**

1. Install [age](https://github.com/FiloSottile/age)
2. Generate a key: `age-keygen -o ~/.age/key.txt`
3. Add your public key to `.age-recipients` (one per line)

For per-machine secrets, place a `.age-recipients` file inside the machine directory — it will be used instead of the root one:
```
machines/wagon/.age-recipients   ← used for secrets under machines/wagon/
.age-recipients                   ← fallback for everything else
```

**Adding an encrypted file:**

Name the file with an `.age` suffix — the `.age` extension is stripped at the destination:
```
common/secrets/dot-config/myapp/config.age  →  ~/.config/myapp/config
```

Encrypt it:
```
make add-secret in=~/plaintext-config out=common/secrets/dot-config/myapp/config
```

**Applying:**
```
make apply
```

**After editing a symlinked file, re-encrypt:**
```
make encrypt
```

**Auto-encrypt on save (requires `inotifywait`):**
```
make watch
```

**Custom key location:**
```
AGE_KEY_FILE=~/.keys/age.txt make apply
```


