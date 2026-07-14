cask "keystats" do
  version "0.2.2"
  sha256 "7158aa0645a03f216a39f9743f9f59382d45d9e94dd90cc81ae048471796f2d5"

  url "https://github.com/gapul/keystats/releases/download/v#{version}/keystats-#{version}-macos-arm64.zip"
  name "Keystats"
  desc "打鍵アナリティクス — キー×アプリ統計。入力テキスト本文は保存しない"
  homepage "https://github.com/gapul/keystats"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura
  depends_on arch: :arm64

  app "keystats-#{version}/.payload/Keystats.app"
  # CLI(top/apps/combos)。デーモン本体と同じバイナリ。
  binary "#{appdir}/Keystats.app/Contents/MacOS/keystatsd", target: "keystats"

  uninstall quit:      "net.gapul.keystats.gui",
            launchctl: [
              "net.gapul.keystats",
              "net.gapul.keystats.gui",
              "net.gapul.keystats.update",
            ]

  zap trash: [
    "~/Library/LaunchAgents/net.gapul.keystats.plist",
    "~/Library/LaunchAgents/net.gapul.keystats.gui.plist",
    "~/Library/LaunchAgents/net.gapul.keystats.update.plist",
    "~/.local/share/keystats",
    "~/.local/state/keystats",
  ]

  caveats <<~EOS
    初回は Launchpad などから Keystats を起動してください。
    「システム設定 > プライバシーとセキュリティ > 入力監視」で "Keystats" を
    オンにすると記録が始まります(メニューバーに常駐します)。
  EOS
end
