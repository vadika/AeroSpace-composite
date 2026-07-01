cask "aerospace-composite" do
  version "0.0.0-SNAPSHOT.8025df06f9f2+PR2057+PR2062"
  sha256 "1918af558828de12a86dcbfa81dffd89cc4a9d7b8c0a7ad2b32cba841ead146d"

  url "https://github.com/vadika/AeroSpace-composite/releases/download/aerospace-testing-8025df06f9f2/AeroSpace-v0.0.0-SNAPSHOT.8025df06f9f2+PR2057+PR2062.zip"
  name "AeroSpace"
  desc "Composite test build of AeroSpace"
  homepage "https://github.com/nikitabobko/AeroSpace"
  conflicts_with cask: ["aerospace", "aerospace-dev"]

  depends_on macos: ">= :ventura"

  postflight do
    system "xattr", "-d", "com.apple.quarantine", "#{staged_path}/AeroSpace-v0.0.0-SNAPSHOT.8025df06f9f2+PR2057+PR2062/bin/aerospace"
    system "xattr", "-d", "com.apple.quarantine", "#{appdir}/AeroSpace.app"
  end

  app "AeroSpace-v0.0.0-SNAPSHOT.8025df06f9f2+PR2057+PR2062/AeroSpace.app"
  binary "AeroSpace-v0.0.0-SNAPSHOT.8025df06f9f2+PR2057+PR2062/bin/aerospace"

  binary "AeroSpace-v0.0.0-SNAPSHOT.8025df06f9f2+PR2057+PR2062/shell-completion/zsh/_aerospace",
      target: "#{HOMEBREW_PREFIX}/share/zsh/site-functions/_aerospace"
  binary "AeroSpace-v0.0.0-SNAPSHOT.8025df06f9f2+PR2057+PR2062/shell-completion/bash/aerospace",
      target: "#{HOMEBREW_PREFIX}/etc/bash_completion.d/aerospace"
  binary "AeroSpace-v0.0.0-SNAPSHOT.8025df06f9f2+PR2057+PR2062/shell-completion/fish/aerospace.fish",
      target: "#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d/aerospace.fish"

  Dir["#{staged_path}/AeroSpace-v0.0.0-SNAPSHOT.8025df06f9f2+PR2057+PR2062/manpage/*"].each { |man| manpage man }
end
