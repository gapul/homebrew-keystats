cask "keystats" do
  version "0.1.3"
  sha256 "64b15e896f5edee25b5a8363602b816232749f0e51657e4b9215dab67b272007"

  url "https://github.com/gapul/keystats/releases/download/v#{version}/keystats-#{version}-macos-arm64.zip"
  name "Keystats"
  desc "打鍵アナリティクス — キー×アプリ統計。入力テキスト本文は保存しない"
  homepage "https://github.com/gapul/keystats"

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
