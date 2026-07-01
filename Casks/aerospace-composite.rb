cask "aerospace-composite" do
  version "0.0.0-SNAPSHOT.c8b6421bfe0f+PR2057+PR2062"
  sha256 "6c2e9d0ab5ffa7cd0c88abd573cf0b5cbb0894ecf8da97748de733bc398c0584"

  url "https://github.com/vadika/AeroSpace-composite/releases/download/aerospace-testing-c8b6421bfe0f/AeroSpace-v0.0.0-SNAPSHOT.c8b6421bfe0f+PR2057+PR2062.zip"
  name "AeroSpace"
  desc "Composite test build of AeroSpace"
  homepage "https://github.com/nikitabobko/AeroSpace"
  conflicts_with cask: ["aerospace", "aerospace-dev"]

  depends_on macos: ">= :ventura"

  postflight do
    system "xattr", "-d", "com.apple.quarantine", "#{staged_path}/AeroSpace-v0.0.0-SNAPSHOT.c8b6421bfe0f+PR2057+PR2062/bin/aerospace"
    system "xattr", "-d", "com.apple.quarantine", "#{appdir}/AeroSpace.app"
  end

  app "AeroSpace-v0.0.0-SNAPSHOT.c8b6421bfe0f+PR2057+PR2062/AeroSpace.app"
  binary "AeroSpace-v0.0.0-SNAPSHOT.c8b6421bfe0f+PR2057+PR2062/bin/aerospace"

  binary "AeroSpace-v0.0.0-SNAPSHOT.c8b6421bfe0f+PR2057+PR2062/shell-completion/zsh/_aerospace",
      target: "#{HOMEBREW_PREFIX}/share/zsh/site-functions/_aerospace"
  binary "AeroSpace-v0.0.0-SNAPSHOT.c8b6421bfe0f+PR2057+PR2062/shell-completion/bash/aerospace",
      target: "#{HOMEBREW_PREFIX}/etc/bash_completion.d/aerospace"
  binary "AeroSpace-v0.0.0-SNAPSHOT.c8b6421bfe0f+PR2057+PR2062/shell-completion/fish/aerospace.fish",
      target: "#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d/aerospace.fish"

  Dir["#{staged_path}/AeroSpace-v0.0.0-SNAPSHOT.c8b6421bfe0f+PR2057+PR2062/manpage/*"].each { |man| manpage man }
end
