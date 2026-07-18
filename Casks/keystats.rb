cask "keystats" do
  version "0.9.2"
  sha256 "70cb275fe24920194cec51ac669c00d14f2d0a46cbbb938492e7a5c368c8ed85"

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

  # launchctl は使わない: brew が system ドメインへ sudo bootout を試み、アップグレードで
  # パスワード待ちになる(headless では詰まる)。常駐エージェントはアプリが自己登録/自己更新し、
  # 完全削除は `brew uninstall --zap` の zap 側で plist を掃除する。
  uninstall quit: "net.gapul.keystats.gui"

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
