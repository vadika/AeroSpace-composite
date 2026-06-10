cask "aerospace-composite" do
  version "0.0.0-SNAPSHOT.0a312c5a8ab3+PR2057+PR2062"
  sha256 "8c99ad95e281a585d1352cc337901db3571e0d1f15894d2f95145644dc015cf4"

  url "https://github.com/vadika/AeroSpace-composite/releases/download/aerospace-testing-0a312c5a8ab3/AeroSpace-v0.0.0-SNAPSHOT.0a312c5a8ab3+PR2057+PR2062.zip"
  name "AeroSpace"
  desc "Composite test build of AeroSpace"
  homepage "https://github.com/nikitabobko/AeroSpace"
  conflicts_with cask: ["aerospace", "aerospace-dev"]

  depends_on macos: ">= :ventura"

  postflight do
    system "xattr", "-d", "com.apple.quarantine", "#{staged_path}/AeroSpace-v0.0.0-SNAPSHOT.0a312c5a8ab3+PR2057+PR2062/bin/aerospace"
    system "xattr", "-d", "com.apple.quarantine", "#{appdir}/AeroSpace.app"
  end

  app "AeroSpace-v0.0.0-SNAPSHOT.0a312c5a8ab3+PR2057+PR2062/AeroSpace.app"
  binary "AeroSpace-v0.0.0-SNAPSHOT.0a312c5a8ab3+PR2057+PR2062/bin/aerospace"

  binary "AeroSpace-v0.0.0-SNAPSHOT.0a312c5a8ab3+PR2057+PR2062/shell-completion/zsh/_aerospace",
      target: "#{HOMEBREW_PREFIX}/share/zsh/site-functions/_aerospace"
  binary "AeroSpace-v0.0.0-SNAPSHOT.0a312c5a8ab3+PR2057+PR2062/shell-completion/bash/aerospace",
      target: "#{HOMEBREW_PREFIX}/etc/bash_completion.d/aerospace"
  binary "AeroSpace-v0.0.0-SNAPSHOT.0a312c5a8ab3+PR2057+PR2062/shell-completion/fish/aerospace.fish",
      target: "#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d/aerospace.fish"

  Dir["#{staged_path}/AeroSpace-v0.0.0-SNAPSHOT.0a312c5a8ab3+PR2057+PR2062/manpage/*"].each { |man| manpage man }
end
