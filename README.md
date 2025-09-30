# .dotfiles

## Requirements

### Git or GitHub CLI

```bash
sudo apt install git
```

or

```bash
sudo apt install gh
```

### Stow

```bash
sudo apt install stow
```

## Installation

In the $HOME folder

```bash
git clone https://github.com/RodrigoAroeira/.dotfiles.git --recurse-submodules
```

or

```bash
gh repo clone RodrigoAroeira/.dotfiles -- --recurse-submodules
```

And then

```bash
cd .dotfiles
```

Now, inside the folder, run

```bash
stow .
```
