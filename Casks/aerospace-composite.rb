cask "aerospace-composite" do
  version "0.0.0-SNAPSHOT.3cb3b9f09dbf+PR2057+PR2062"
  sha256 "02b20696a8ddbf089f3bae84198e238dca4b9650d3f134f2584cd47af81ec214"

  url "https://github.com/vadika/AeroSpace-composite/releases/download/aerospace-testing-3cb3b9f09dbf/AeroSpace-v0.0.0-SNAPSHOT.3cb3b9f09dbf+PR2057+PR2062.zip"
  name "AeroSpace"
  desc "Composite test build of AeroSpace"
  homepage "https://github.com/nikitabobko/AeroSpace"
  conflicts_with cask: ["aerospace", "aerospace-dev"]

  depends_on macos: :ventura

  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-d", "com.apple.quarantine", "{{staged_path}}/AeroSpace-v0.0.0-SNAPSHOT.3cb3b9f09dbf+PR2057+PR2062/bin/aerospace"],
        must_succeed: false
    run "/usr/bin/xattr",
        args: ["-d", "com.apple.quarantine", "{{appdir}}/AeroSpace.app"],
        must_succeed: false
  end

  app "AeroSpace-v0.0.0-SNAPSHOT.3cb3b9f09dbf+PR2057+PR2062/AeroSpace.app"
  binary "AeroSpace-v0.0.0-SNAPSHOT.3cb3b9f09dbf+PR2057+PR2062/bin/aerospace"

  binary "AeroSpace-v0.0.0-SNAPSHOT.3cb3b9f09dbf+PR2057+PR2062/shell-completion/zsh/_aerospace",
      target: "#{HOMEBREW_PREFIX}/share/zsh/site-functions/_aerospace"
  binary "AeroSpace-v0.0.0-SNAPSHOT.3cb3b9f09dbf+PR2057+PR2062/shell-completion/bash/aerospace",
      target: "#{HOMEBREW_PREFIX}/etc/bash_completion.d/aerospace"
  binary "AeroSpace-v0.0.0-SNAPSHOT.3cb3b9f09dbf+PR2057+PR2062/shell-completion/fish/aerospace.fish",
      target: "#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d/aerospace.fish"

  Dir["#{staged_path}/AeroSpace-v0.0.0-SNAPSHOT.3cb3b9f09dbf+PR2057+PR2062/manpage/*"].each { |man| manpage man }
end
