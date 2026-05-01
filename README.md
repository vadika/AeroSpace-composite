# AeroSpace Composite Builds

This repository builds tester-friendly AeroSpace packages from:

- upstream `main`
- plus any selected GitHub pull requests

Each distinct source state gets its own GitHub release with:

- a downloadable `AeroSpace-v...zip`
- a Homebrew cask file pointing at that release asset
- a small metadata file describing which upstream commit and PR heads were included

## How it works

The GitHub Actions workflow polls upstream once per day and also runs on changes to this repository.

## Tester install

Download:

- the zip asset directly from Releases
- or install from this repository as Homebrew tap:

First remove official casks if installed:

```bash
brew uninstall --cask aerospace aerospace-dev 2>/dev/null || true
```

Tap install:

```bash
brew tap vadika/aerospace-composite https://github.com/vadika/AeroSpace-composite
brew install --cask vadika/aerospace-composite/aerospace-composite
```

Releases page:

```bash
https://github.com/vadika/AeroSpace-composite/releases
```

If you want manual install from release assets:

```bash
curl -LO https://github.com/vadika/AeroSpace-composite/releases/download/<tag>/aerospace-composite.rb
brew tap vadika/aerospace-composite https://github.com/vadika/AeroSpace-composite
cp ./aerospace-composite.rb "$(brew --repository)/Library/Taps/vadika/homebrew-aerospace-composite/Casks/aerospace-composite.rb"
brew reinstall --cask vadika/aerospace-composite/aerospace-composite
```
