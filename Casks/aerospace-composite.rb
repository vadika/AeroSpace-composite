cask "aerospace-composite" do
  version "0.0.0-SNAPSHOT.f0733f2f3f58+PR2057+PR2062"
  sha256 "5cd7a85dbd65d2d24cdc5bd2326f075b4ea42f4537a63445e0a65ea62c5c5455"

  url "https://github.com/vadika/AeroSpace-composite/releases/download/aerospace-testing-f0733f2f3f58/AeroSpace-v0.0.0-SNAPSHOT.f0733f2f3f58+PR2057+PR2062.zip"
  name "AeroSpace"
  desc "Composite test build of AeroSpace"
  homepage "https://github.com/nikitabobko/AeroSpace"
  conflicts_with cask: ["aerospace", "aerospace-dev"]

  depends_on macos: ">= :ventura"

  postflight do
    system "xattr", "-d", "com.apple.quarantine", "#{staged_path}/AeroSpace-v0.0.0-SNAPSHOT.f0733f2f3f58+PR2057+PR2062/bin/aerospace"
    system "xattr", "-d", "com.apple.quarantine", "#{appdir}/AeroSpace.app"
  end

  app "AeroSpace-v0.0.0-SNAPSHOT.f0733f2f3f58+PR2057+PR2062/AeroSpace.app"
  binary "AeroSpace-v0.0.0-SNAPSHOT.f0733f2f3f58+PR2057+PR2062/bin/aerospace"

  binary "AeroSpace-v0.0.0-SNAPSHOT.f0733f2f3f58+PR2057+PR2062/shell-completion/zsh/_aerospace",
      target: "#{HOMEBREW_PREFIX}/share/zsh/site-functions/_aerospace"
  binary "AeroSpace-v0.0.0-SNAPSHOT.f0733f2f3f58+PR2057+PR2062/shell-completion/bash/aerospace",
      target: "#{HOMEBREW_PREFIX}/etc/bash_completion.d/aerospace"
  binary "AeroSpace-v0.0.0-SNAPSHOT.f0733f2f3f58+PR2057+PR2062/shell-completion/fish/aerospace.fish",
      target: "#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d/aerospace.fish"

  Dir["#{staged_path}/AeroSpace-v0.0.0-SNAPSHOT.f0733f2f3f58+PR2057+PR2062/manpage/*"].each { |man| manpage man }
end
