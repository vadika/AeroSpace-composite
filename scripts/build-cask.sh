#!/usr/bin/env bash
set -euo pipefail

zip_path=''
asset_url=''
cask_name=''
build_version=''
homepage='https://github.com/nikitabobko/AeroSpace'

while test $# -gt 0; do
    case "$1" in
        --zip-path) zip_path="$2"; shift 2 ;;
        --asset-url) asset_url="$2"; shift 2 ;;
        --cask-name) cask_name="$2"; shift 2 ;;
        --build-version) build_version="$2"; shift 2 ;;
        --homepage) homepage="$2"; shift 2 ;;
        *) echo "Unknown arg $1" >&2; exit 1 ;;
    esac
done

if test -z "$zip_path"; then echo "--zip-path is mandatory" >&2; exit 1; fi
if test -z "$asset_url"; then echo "--asset-url is mandatory" >&2; exit 1; fi
if test -z "$cask_name"; then echo "--cask-name is mandatory" >&2; exit 1; fi
if test -z "$build_version"; then echo "--build-version is mandatory" >&2; exit 1; fi
if ! test -f "$zip_path"; then echo "$zip_path doesn't exist" >&2; exit 1; fi

sha=$(shasum -a 256 "$zip_path" | awk '{print $1}')
zip_root_dir="AeroSpace-v$build_version"

cat <<EOF
cask "$cask_name" do
  version :latest
  sha256 "$sha"

  url "$asset_url"
  name "AeroSpace"
  desc "Composite test build of AeroSpace"
  homepage "$homepage"
  conflicts_with cask: ["aerospace", "aerospace-dev"]

  depends_on macos: ">= :ventura"

  postflight do
    system "xattr", "-d", "com.apple.quarantine", "#{staged_path}/$zip_root_dir/bin/aerospace"
    system "xattr", "-d", "com.apple.quarantine", "#{appdir}/AeroSpace.app"
  end

  app "$zip_root_dir/AeroSpace.app"
  binary "$zip_root_dir/bin/aerospace"

  binary "$zip_root_dir/shell-completion/zsh/_aerospace",
      target: "#{HOMEBREW_PREFIX}/share/zsh/site-functions/_aerospace"
  binary "$zip_root_dir/shell-completion/bash/aerospace",
      target: "#{HOMEBREW_PREFIX}/etc/bash_completion.d/aerospace"
  binary "$zip_root_dir/shell-completion/fish/aerospace.fish",
      target: "#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d/aerospace.fish"

  Dir["#{staged_path}/$zip_root_dir/manpage/*"].each { |man| manpage man }
end
EOF
