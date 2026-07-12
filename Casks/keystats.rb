cask "keystats" do
  version "0.1.0"
  sha256 "960901d6e33201567e95bb646a43f2c70afa5b86ac4ed20d1366c2339a09f612"

  url "https://github.com/gapul/keystats/releases/download/v#{version}/keystats-#{version}-macos-arm64.zip"
  name "Keystats"
  desc "打鍵アナリティクス — キー×アプリ統計。入力テキスト本文は保存しない"
  homepage "https://github.com/gapul/keystats"

  depends_on macos: ">= :ventura"
  depends_on arch: :arm64

  # 同梱の install.command が ~/Applications への配置と LaunchAgent 登録、
  # 入力監視パネルの案内までを行う(署名は安定DRなので更新後も権限維持)。
  installer script: {
    executable: "keystats-#{version}/install.command",
  }

  uninstall launchctl: [
              "net.gapul.keystats",
              "net.gapul.keystats.gui",
              "net.gapul.keystats.update",
            ],
            delete:    "#{Dir.home}/Applications/Keystats.app"

  zap trash: [
    "~/Library/LaunchAgents/net.gapul.keystats.plist",
    "~/Library/LaunchAgents/net.gapul.keystats.gui.plist",
    "~/Library/LaunchAgents/net.gapul.keystats.update.plist",
    "~/.local/share/keystats",
    "~/.local/state/keystats",
  ]

  caveats <<~EOS
    初回は「システム設定 > プライバシーとセキュリティ > 入力監視」で
    "Keystats" をオンにすると記録が始まります。
  EOS
end
