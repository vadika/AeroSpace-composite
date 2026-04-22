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

On each run it:

1. Clones upstream `AeroSpace`
2. Checks out upstream `main`
3. Cherry-picks the selected PR heads in order
4. Reuses upstream `build-release.sh`
5. Publishes a GitHub release in this repository

If upstream `main` and all selected PR heads are unchanged, the workflow exits without creating a new release.

## Configure

Edit the committed `composite.env` file and adjust:

- `UPSTREAM_REPO`
- `UPSTREAM_BRANCH`
- `SELECTED_PRS`
- `RELEASE_PREFIX`
- `CASK_NAME`

Example:

```bash
UPSTREAM_REPO=https://github.com/nikitabobko/AeroSpace.git
UPSTREAM_BRANCH=main
SELECTED_PRS=(123 456 789)
RELEASE_PREFIX=aerospace-testing
CASK_NAME=aerospace-composite
```

## Tester install

Download:

- the zip asset directly from Releases
- or the generated cask file and install it with Homebrew:

First remove official casks if installed:

```bash
brew uninstall --cask aerospace aerospace-dev 2>/dev/null || true
```

Then open Releases and download latest `aerospace-composite.rb`:

```bash
https://github.com/vadika/AeroSpace-composite/releases
```

If you already downloaded latest `aerospace-composite.rb` locally:

```bash
brew install --cask ./aerospace-composite.rb
```

Or download + install in one go:

```bash
curl -LO https://github.com/vadika/AeroSpace-composite/releases/download/<tag>/aerospace-composite.rb
brew install --cask ./aerospace-composite.rb
```

## GitHub setup

1. Create a GitHub repository for this folder.
2. Push `main`.
3. In the repository settings, allow GitHub Actions to create and update releases.

No custom secrets are required for unsigned testing builds. The workflow signs with `-`, matching the upstream CI strategy for local/test usage.

## Notes

- PRs are applied in the order listed in `SELECTED_PRS`.
- Conflicting PRs will fail the workflow during cherry-pick.
- The generated cask conflicts with official `aerospace` and `aerospace-dev` casks so testers do not accidentally install both.
