# Module index

Every toggle in Mercury. *Path* is the option prefix; add `.enable = true;` to switch it on (some modules have more options — open the file to see them). System options go in `hosts/<name>/configuration.nix`; `mercury.home.*` options go in `home/users/mercury/*.nix`.

## NixOS (system)

| Path | What it does | File |
|---|---|---|
| `mercury.desktop.des.gnome` | Gnome feature set | `modules/desktop/des/gnome.nix` |
| `mercury.desktop.des.xfce` | XFCE desktop | `modules/desktop/des/xfce.nix` |
| `mercury.desktop.dms.gdm` | GDM | `modules/desktop/dms/gdm.nix` |
| `mercury.desktop.dms.lightdm` | LightDM | `modules/desktop/dms/lightdm.nix` |
| `mercury.desktop.dms.ly` | Ly | `modules/desktop/dms/ly.nix` |
| `mercury.desktop.dms.sddm` | SDDM display manager | `modules/desktop/dms/sddm.nix` |
| `mercury.desktop.wms.hyprland` | Hyprland (UWSM session) with the services the Wayle shell expects | `modules/desktop/wms/hyprland.nix` |
| `mercury.flatpak.flatseal` | Flatseal | `modules/flatpak/flatseal.nix` |
| `mercury.flatpak.museum` | Museum | `modules/flatpak/museum.nix` |
| `mercury.hardware.bluetooth` | Bluetooth feature set | `modules/hardware/bluetooth.nix` |
| `mercury.hardware.gpu` | Intel graphics (iGPU and Arc) with VA-API / QSV / OpenCL | `modules/hardware/gpu.nix` |
| `mercury.hardware.networking` | Drop most incoming traffic | `modules/hardware/networking.nix` |
| `mercury.hardware.pipewire` | PipeWire audio daemon | `modules/hardware/pipewire.nix` |
| `mercury.hardware.power` | Power management | `modules/hardware/power.nix` |
| `mercury.hardware.printing` | Printing feature set | `modules/hardware/printing.nix` |
| `mercury.leisure.iamb` | Iamb - Ultimate TUI Chat Dashboard Stack | `modules/leisure/iamb.nix` |
| `mercury.leisure.steam` | Steam (Proton, Remote Play, Gamescope session, GameMode) | `modules/leisure/steam.nix` |
| `mercury.oci.immich` | Immich | `modules/oci/immich.nix` |
| `mercury.oci.jellyfin` | Jellyfin | `modules/oci/jellyfin.nix` |
| `mercury.oci.pgadmin` | pgAdmin 4 web interface | `modules/oci/pgadmin.nix` |
| `mercury.personalization.fonts` | Fonts | `modules/personalization/fonts.nix` |
| `mercury.personalization.xdg` | Xdg | `modules/personalization/xdg.nix` |
| `mercury.security.onepassword` | 1Password | `modules/security/1password.nix` |
| `mercury.security.gnome_keyring` | Keyring feature set | `modules/security/gnome_keyring.nix` |
| `mercury.security.pam` | PAM Yubi feature set | `modules/security/pam.nix` |
| `mercury.security.polkit` | Polkit feature set | `modules/security/polkit.nix` |
| `mercury.security.sops_nix` | sops-nix secrets (on by default) | `modules/security/sops_nix.nix` |
| `mercury.security.yubikey` | YubiKey support & pcscd daemon | `modules/security/yubikey.nix` |
| `mercury.services.adguard` | AdGuard Home feature set | `modules/services/adguard.nix` |
| `mercury.services.caddy` | Caddy web server and reverse proxy | `modules/services/caddy.nix` |
| `mercury.services.cloudflared` | Cloudflare Tunnel | `modules/services/cloudflared.nix` |
| `mercury.services.eduvpn` | eduVPN system integration | `modules/services/eduvpn.nix` |
| `mercury.services.google_drive` | Google Drive | `modules/services/google_drive.nix` |
| `mercury.services.iio` | IIO sensors (accelerometer, ambient light) via iio-sensor-proxy | `modules/services/iio.nix` |
| `mercury.services.kde_connect` | kde connect for phone pairing. | `modules/services/kde_connect.nix` |
| `mercury.services.openvpn` | OpenVPN feature set | `modules/services/openvpn.nix` |
| `mercury.services.ssh` | OpenSSH server + fail2ban (on by default) | `modules/services/ssh.nix` |
| `mercury.services.syncthing` | Syncthing feature set | `modules/services/syncthing.nix` |
| `mercury.services.tailscale` | Tailscale feature set | `modules/services/tailscale.nix` |
| `mercury.services.vnc` | Wayvnc feature set | `modules/services/wayvnc.nix` |
| `mercury.services.wireguard` | WireGuard feature set | `modules/services/wireguard.nix` |
| `mercury.storage.impermanence` | Impermanence layer | `modules/storage/btrfs_rollback.nix` |
| `mercury.storage.disko` | use hosts/<name>/disko.nix for filesystems (on by default; off for non-Disko installs) | `modules/storage/disko.nix` |
| `mercury.storage.fhs` | FHS feature set | `modules/storage/fhs.nix` |
| `mercury.storage.gnome_disk_usage` | Gnome disk usage | `modules/storage/gnome_disk_usage.nix` |
| `mercury.storage.gnome_disks` | Gnome disks | `modules/storage/gnome_disks.nix` |
| `mercury.storage.impermanence` | Impermanence layer | `modules/storage/impermanence.nix` |
| `mercury.storage.trash` | Trash | `modules/storage/trash.nix` |
| `mercury.storage.zfs` | ZFS Support | `modules/storage/zfs.nix` |
| `mercury.system` | time zone / auto time zone | `modules/system/datetime.nix` |
| `mercury.system.home_manager` | Home Manager for the primary user | `modules/system/home_manager.nix` |
| `mercury.system.plymouth` | Plymouth boot splash animation | `modules/system/plymouth.nix` |
| `mercury.system.user` | primary user, password, SSH keys | `modules/system/users.nix` |
| `mercury.virtualization.bottles` | Bottles | `modules/virtualization/bottles.nix` |
| `mercury.virtualization.compose2nix` | Compose2nix | `modules/virtualization/compose2nix.nix` |
| `mercury.virtualization.docker` | Docker feature set | `modules/virtualization/docker.nix` |
| `mercury.virtualization.flatpak` | Flatpak feature set | `modules/virtualization/flatpak.nix` |
| `mercury.virtualization.libvirt` | Libvirt feature set | `modules/virtualization/libvirt.nix` |
| `mercury.virtualization.microvm` | Microvm hypervisor host support | `modules/virtualization/microvm.nix` |
| `mercury.virtualization.oci` | oci-containers base engine | `modules/virtualization/oci.nix` |
| `mercury.virtualization.podman` | Podman feature set | `modules/virtualization/podman.nix` |
| `mercury.virtualization.virtualbox` | Virtualbox | `modules/virtualization/virtualbox.nix` |

## macOS (nix-darwin)

| Path | What it does | File |
|---|---|---|
| `mercury.darwin.defaults` | Mercury's macOS preferences (dark mode, fast key repeat, tidy Dock/Finder) | `darwin/modules/defaults.nix` |
| `mercury.system.home_manager` | Home Manager for the primary user | `darwin/modules/home_manager.nix` |
| `mercury.darwin.homebrew` | declarative Homebrew | `darwin/modules/homebrew.nix` |
| `mercury.system.user` | primary user, password, SSH keys | `darwin/modules/users.nix` |

## Home Manager: desktop, environment, services

| Path | What it does | File |
|---|---|---|
| `mercury.home.desktop.wms.hyprland` | the Mercury Hyprland desktop (Wayle shell, hyprlock, hypridle, fuzzel) | `home/desktop/wms/hyprland.nix` |
| `mercury.home.environment` | — | `home/environment/config_path.nix` |
| `mercury.home.environment.fonts` | Fonts | `home/environment/fonts.nix` |
| `mercury.home.environment.gtk` | GTK config | `home/environment/gtk.nix` |
| `mercury.home.environment.ignores` | — | `home/environment/ignores.nix` |
| `mercury.home.environment.xdg` | XDG | `home/environment/xdg.nix` |
| `mercury.home.services.caddy` | Caddy user configuration and dotfile linking | `home/services/caddy.nix` |
| `mercury.home.services.google_drive` | Google Drive FUSE Mount & Direct Sync Tool | `home/services/google_drive.nix` |
| `mercury.home.services.syncthing` | Mercury Syncthing user service | `home/services/syncthing.nix` |

## Home Manager: applications

| Path | What it does | File |
|---|---|---|
| `mercury.home.apps.ai.antigravity` | Google Antigravity (IDE and CLI) | `home/applications/ai/antigravity.nix` |
| `mercury.home.apps.ai.flox` | Flox environments | `home/applications/ai/flox.nix` |
| `mercury.home.apps.ai.n8n` | N8N | `home/applications/ai/n8n.nix` |
| `mercury.home.apps.ai.opencode` | Opencode | `home/applications/ai/opencode.nix` |
| `mercury.home.apps.development.editors.android_studio` | Android Studio editor | `home/applications/development/editors/android_studio.nix` |
| `mercury.home.apps.development.editors.nvim` | Neovim | `home/applications/development/editors/nvim.nix` |
| `mercury.home.apps.development.editors.vscode` | Vscode | `home/applications/development/editors/vscode.nix` |
| `mercury.home.apps.development.editors.zed` | Zed editor | `home/applications/development/editors/zed.nix` |
| `mercury.home.apps.development.langs` | every language module (LSP, formatter, linter) except MATLAB | `home/applications/development/langs/all.nix` |
| `mercury.home.apps.development.langs.bash` | BASH support | `home/applications/development/langs/bash.nix` |
| `mercury.home.apps.development.langs.cpp` | C/C++ development support | `home/applications/development/langs/cpp.nix` |
| `mercury.home.apps.development.langs.docker` | Dockerfile and Compose support (LSPs) | `home/applications/development/langs/docker.nix` |
| `mercury.home.apps.development.langs.go` | Go language support | `home/applications/development/langs/go.nix` |
| `mercury.home.apps.development.langs.java` | Java language support | `home/applications/development/langs/java.nix` |
| `mercury.home.apps.development.langs.js` | JavaScript/TypeScript support | `home/applications/development/langs/js.nix` |
| `mercury.home.apps.development.langs.latex` | Latex support | `home/applications/development/langs/latex.nix` |
| `mercury.home.apps.development.langs.lua` | Lua language tooling and runtime | `home/applications/development/langs/lua.nix` |
| `mercury.home.apps.development.langs.markdown` | Markdown support | `home/applications/development/langs/markdown.nix` |
| `mercury.home.apps.development.langs.matlab` | MATLAB language support | `home/applications/development/langs/matlab.nix` |
| `mercury.home.apps.development.langs.nginx` | Nginx support | `home/applications/development/langs/nginx.nix` |
| `mercury.home.apps.development.langs.nix` | Nix support | `home/applications/development/langs/nix.nix` |
| `mercury.home.apps.development.langs.python` | Python language support | `home/applications/development/langs/python.nix` |
| `mercury.home.apps.development.langs.qml` | QML support (qmlls) | `home/applications/development/langs/qml.nix` |
| `mercury.home.apps.development.langs.rust` | Rust language support | `home/applications/development/langs/rust.nix` |
| `mercury.home.apps.development.langs.toml` | TOML support | `home/applications/development/langs/toml.nix` |
| `mercury.home.apps.development.langs.typst` | Typst support | `home/applications/development/langs/typst.nix` |
| `mercury.home.apps.development.langs.web` | HTML, CSS, JSON, ESLint, Svelte and Vue support (LSPs) | `home/applications/development/langs/web.nix` |
| `mercury.home.apps.development.langs.yaml` | YAML support | `home/applications/development/langs/yaml.nix` |
| `mercury.home.apps.development.tools.dbeaver` | Dbeaver | `home/applications/development/tools/dbeaver.nix` |
| `mercury.home.apps.development.tools.git` | GIT feature set | `home/applications/development/tools/git.nix` |
| `mercury.home.apps.development.tools.heimdall` | Heimdall flash utility | `home/applications/development/tools/heimdall.nix` |
| `mercury.home.apps.development.tools.postman` | Postman | `home/applications/development/tools/postman.nix` |
| `mercury.home.apps.gaming.launchers.gamemode` | Gamemode | `home/applications/gaming/launchers/gamemode.nix` |
| `mercury.home.apps.gaming.launchers.heroic` | Heroic | `home/applications/gaming/launchers/heroic.nix` |
| `mercury.home.apps.gaming.launchers.protonplus` | ProtonPlus (install Proton-GE and other compatibility tools for Steam/Heroic) | `home/applications/gaming/launchers/protonplus.nix` |
| `mercury.home.apps.graphics.cad.blender` | Blender | `home/applications/graphics/cad/blender.nix` |
| `mercury.home.apps.graphics.cad.model_viewer` | 3D model viewer | `home/applications/graphics/cad/model_viewer.nix` |
| `mercury.home.apps.graphics.raster.gimp` | Gimp | `home/applications/graphics/raster/gimp.nix` |
| `mercury.home.apps.graphics.raster.sly` | SLY Image editor | `home/applications/graphics/raster/sly.nix` |
| `mercury.home.apps.graphics.scanning.gnome_ocr` | Gnome OCR | `home/applications/graphics/scanning/gnome_ocr.nix` |
| `mercury.home.apps.graphics.scanning.gnome_scanner` | Gnome scanner | `home/applications/graphics/scanning/gnome_scanner.nix` |
| `mercury.home.apps.graphics.vector.inkscape` | Inkscape | `home/applications/graphics/vector/inkscape.nix` |
| `mercury.home.apps.graphics.viewers.gnome_image_editor` | Gnome image editor | `home/applications/graphics/viewers/gnome_image_editor.nix` |
| `mercury.home.apps.graphics.viewers.gnome_image_viewer` | Gnome image viewer | `home/applications/graphics/viewers/gnome_image_viewer.nix` |
| `mercury.home.apps.media.audio.audiobookshelf` | Audiobookshelft reader | `home/applications/media/audio/audiobookshelf.nix` |
| `mercury.home.apps.media.audio.cozy` | Cozy Audiobook reader | `home/applications/media/audio/cozy.nix` |
| `mercury.home.apps.media.audio.gnome_radio` | Gnome radio | `home/applications/media/audio/gnome_radio.nix` |
| `mercury.home.apps.media.audio.pwvucontrol` | Pwvucontrol | `home/applications/media/audio/pwvucontrol.nix` |
| `mercury.home.apps.media.audio.spotify` | Spotify | `home/applications/media/audio/spotify.nix` |
| `mercury.home.apps.media.video.anime` | Ani CLI | `home/applications/media/video/anime.nix` |
| `mercury.home.apps.media.video.gnome_video_player` | Gnome video player | `home/applications/media/video/gnome_video_player.nix` |
| `mercury.home.apps.media.video.kdenlive` | Kdenlive | `home/applications/media/video/kdenlive.nix` |
| `mercury.home.apps.media.video.netflix` | Netflix | `home/applications/media/video/netflix.nix` |
| `mercury.home.apps.media.video.obs` | OBS | `home/applications/media/video/obs.nix` |
| `mercury.home.apps.network.browsers.chrome` | Google Chrome | `home/applications/network/browsers/chrome.nix` |
| `mercury.home.apps.network.browsers.firefox` | Firefox Browser | `home/applications/network/browsers/firefox.nix` |
| `mercury.home.apps.network.browsers.tor` | Tor Browser | `home/applications/network/browsers/tor.nix` |
| `mercury.home.apps.network.browsers.zen` | Zen browser. | `home/applications/network/browsers/zen.nix` |
| `mercury.home.apps.network.chat.discord` | Discord | `home/applications/network/chat/discord.nix` |
| `mercury.home.apps.network.chat.teams` | Microsoft Teams | `home/applications/network/chat/teams.nix` |
| `mercury.home.apps.network.chat.telegram` | Telegram | `home/applications/network/chat/telegram.nix` |
| `mercury.home.apps.network.chat.tut` | tut (Mastodon TUI) | `home/applications/network/chat/tut.nix` |
| `mercury.home.apps.network.chat.whatsapp` | Whatsapp | `home/applications/network/chat/whatsapp.nix` |
| `mercury.home.apps.network.remote.dnsutils` | Dnsutils | `home/applications/network/remote/dnsutils.nix` |
| `mercury.home.apps.network.remote.eduvpn` | EduVPN | `home/applications/network/remote/eduvpn.nix` |
| `mercury.home.apps.network.remote.gnome_network_displays` | Gnome network displays | `home/applications/network/remote/gnome_network_displays.nix` |
| `mercury.home.apps.network.remote.iperf` | Iperf | `home/applications/network/remote/iperf.nix` |
| `mercury.home.apps.network.remote.kde_connect` | kde connect for phone pairing. | `home/applications/network/remote/kde_connect.nix` |
| `mercury.home.apps.network.remote.mappers` | Nmap, RustScan, Zmap, MassScan | `home/applications/network/remote/mappers.nix` |
| `mercury.home.apps.network.remote.openssl` | Openssl | `home/applications/network/remote/openssl.nix` |
| `mercury.home.apps.network.remote.remmina` | Remmina VNC | `home/applications/network/remote/remmina.nix` |
| `mercury.home.apps.network.transfer.aria2` | Aria2 Download tool | `home/applications/network/transfer/aria2.nix` |
| `mercury.home.apps.network.transfer.gnome_torrents` | Gnome torrents | `home/applications/network/transfer/gnome_torrents.nix` |
| `mercury.home.apps.network.transfer.parabolic` | Youtube downloader | `home/applications/network/transfer/parabolic.nix` |
| `mercury.home.apps.office.docs.gnome_markdown` | Gnome markdown | `home/applications/office/docs/gnome_markdown.nix` |
| `mercury.home.apps.office.docs.libreoffice` | Libreoffice | `home/applications/office/docs/libreoffice.nix` |
| `mercury.home.apps.office.docs.marktext` | Marktext | `home/applications/office/docs/marktext.nix` |
| `mercury.home.apps.office.docs.obsidian` | Obsidian notes tool | `home/applications/office/docs/obsidian.nix` |
| `mercury.home.apps.office.docs.rnote` | Rnote | `home/applications/office/docs/rnote.nix` |
| `mercury.home.apps.office.docs.todoist` | todoist | `home/applications/office/docs/todoist.nix` |
| `mercury.home.apps.office.readers.calibre` | Epub reader | `home/applications/office/readers/calibre.nix` |
| `mercury.home.apps.office.readers.foliate` | Epub reader | `home/applications/office/readers/foliate.nix` |
| `mercury.home.apps.office.readers.gnome_document_viewer` | Gnome PDF viewer | `home/applications/office/readers/gnome_document_viewer.nix` |
| `mercury.home.apps.office.readers.sioyek` | Sioyek | `home/applications/office/readers/sioyek.nix` |
| `mercury.home.apps.office.readers.zathura` | Zathura document viewer | `home/applications/office/readers/zathura.nix` |
| `mercury.home.apps.office.readers.zlibrary` | Epub reader | `home/applications/office/readers/zlibrary.nix` |
| `mercury.home.apps.office.tools.autofirma` | Autofirma feature set | `home/applications/office/tools/autofirma.nix` |
| `mercury.home.apps.office.tools.bento_pdf` | Bentopdf | `home/applications/office/tools/bento_pdf.nix` |
| `mercury.home.apps.office.tools.ghostscript` | Ghostscript | `home/applications/office/tools/ghostscript.nix` |
| `mercury.home.apps.office.tools.gnome_pomodoro` | Gnome pomodoro | `home/applications/office/tools/gnome_pomodoro.nix` |
| `mercury.home.apps.office.tools.mermaid` | Mermaid support | `home/applications/office/tools/mermaid.nix` |
| `mercury.home.apps.office.tools.pandoc` | Pandoc | `home/applications/office/tools/pandoc.nix` |
| `mercury.home.apps.office.tools.stirling` | Stirling | `home/applications/office/tools/stirling.nix` |
| `mercury.home.apps.office.tools.zotero` | zotero | `home/applications/office/tools/zotero.nix` |
| `mercury.home.apps.science.diagrams.drawio` | DrawIO | `home/applications/science/diagrams/drawio.nix` |
| `mercury.home.apps.science.electronics.kicad` | Kicad | `home/applications/science/electronics/kicad.nix` |
| `mercury.home.apps.science.gis.qgis` | QGIS | `home/applications/science/gis/qgis.nix` |
| `mercury.home.apps.science.math.octave` | GNU Octave | `home/applications/science/math/octave.nix` |
| `mercury.home.apps.settings.desktop.nwg_look` | nwg-look | `home/applications/settings/desktop/nwg_look.nix` |
| `mercury.home.apps.settings.packages.gnome_software` | Gnome software | `home/applications/settings/packages/gnome_software.nix` |
| `mercury.home.apps.settings.security.gnome_seahorse` | Gnome seahorse | `home/applications/settings/security/gnome_seahorse.nix` |
| `mercury.home.apps.settings.security.onepassword` | — | `home/applications/settings/security/onepassword.nix` |
| `mercury.home.apps.settings.security.pass` | Pass (passage) password manager wrapper | `home/applications/settings/security/pass.nix` |
| `mercury.home.apps.settings.security.sops` | SOPS user secrets integration | `home/applications/settings/security/sops.nix` |
| `mercury.home.apps.settings.security.vulnix` | Vulnix vulnerability scanner | `home/applications/settings/security/vulnix.nix` |
| `mercury.home.apps.system.core.bluetooth` | — | `home/applications/system/core/bluetooth.nix` |
| `mercury.home.apps.system.core.sqlite` | SQLite support | `home/applications/system/core/sqlite.nix` |
| `mercury.home.apps.system.core.usbutils` | USB utilities | `home/applications/system/core/usbutils.nix` |
| `mercury.home.apps.system.core.zip` | Archive compression utilities (zip, p7zip, ouch) | `home/applications/system/core/zip.nix` |
| `mercury.home.apps.system.desktop.gnome_characters` | Gnome characters | `home/applications/system/desktop/gnome_characters.nix` |
| `mercury.home.apps.system.desktop.gnome_file_roller` | Gnome file roller | `home/applications/system/desktop/gnome_file_roller.nix` |
| `mercury.home.apps.system.desktop.gnome_files` | Gnome files | `home/applications/system/desktop/gnome_files.nix` |
| `mercury.home.apps.system.desktop.gnome_system_monitor` | Gnome System Monitor | `home/applications/system/desktop/gnome_system_monitor.nix` |
| `mercury.home.apps.system.desktop.thunar` | thunar | `home/applications/system/desktop/thunar.nix` |
| `mercury.home.apps.system.shell.bat` | Bat (cat clone with syntax highlighting and Git integration) | `home/applications/system/shell/bat.nix` |
| `mercury.home.apps.system.shell.curl` | Curl | `home/applications/system/shell/curl.nix` |
| `mercury.home.apps.system.shell.eza` | Eza (modern, maintained ls replacement) | `home/applications/system/shell/eza.nix` |
| `mercury.home.apps.system.shell.fastfetch` | Fastfetch system summary | `home/applications/system/shell/fastfetch.nix` |
| `mercury.home.apps.system.shell.file` | File | `home/applications/system/shell/file.nix` |
| `mercury.home.apps.system.shell.fzf` | FZF fuzzy finder with fd integration | `home/applications/system/shell/fzf.nix` |
| `mercury.home.apps.system.shell.glow` | Glow | `home/applications/system/shell/glow.nix` |
| `mercury.home.apps.system.shell.jq` | Jq | `home/applications/system/shell/jq.nix` |
| `mercury.home.apps.system.shell.kitty` | Kitty terminal | `home/applications/system/shell/kitty.nix` |
| `mercury.home.apps.system.shell.magika` | Modern file type inspection utilities | `home/applications/system/shell/magika.nix` |
| `mercury.home.apps.system.shell.pay_respects` | Pay-respects | `home/applications/system/shell/pay_respects.nix` |
| `mercury.home.apps.system.shell.pdfgrep` | PDFgrep utility for searching text in PDF files | `home/applications/system/shell/pdfgrep.nix` |
| `mercury.home.apps.system.shell.ripgrep` | Ripgrep search engine | `home/applications/system/shell/ripgrep.nix` |
| `mercury.home.apps.system.shell.secret_tool` | Secret-tool | `home/applications/system/shell/secret_tool.nix` |
| `mercury.home.apps.system.shell.starship` | Starship | `home/applications/system/shell/starship.nix` |
| `mercury.home.apps.system.shell.tmux` | Tmux terminal multiplexer | `home/applications/system/shell/tmux.nix` |
| `mercury.home.apps.system.shell.tree` | Tree | `home/applications/system/shell/tree.nix` |
| `mercury.home.apps.system.shell.wget` | Wget | `home/applications/system/shell/wget.nix` |
| `mercury.home.apps.system.shell.zoxide` | Zoxide smarter cd command | `home/applications/system/shell/zoxide.nix` |
| `mercury.home.apps.system.shell.zsh` | Zsh config | `home/applications/system/shell/zsh.nix` |
| `mercury.home.apps.system.virtualization.boxbuddy` | Boxbuddy | `home/applications/system/virtualization/boxbuddy.nix` |
| `mercury.home.apps.system.virtualization.devbox` | Devbox development environment | `home/applications/system/virtualization/devbox.nix` |
| `mercury.home.apps.system.virtualization.distrobox` | Distrobox | `home/applications/system/virtualization/distrobox.nix` |
| `mercury.home.apps.system.virtualization.docker` | Docker support | `home/applications/system/virtualization/docker.nix` |
| `mercury.home.apps.system.virtualization.kontainer` | kontainer | `home/applications/system/virtualization/kontainer.nix` |
| `mercury.home.apps.system.virtualization.virt_manager` | Virt-manager | `home/applications/system/virtualization/virt_manager.nix` |
| `mercury.home.apps.utility.accessories.calculator` | Gnome calculator | `home/applications/utility/accessories/calculator.nix` |
| `mercury.home.apps.utility.accessories.gnome_calculator` | Gnome calculator | `home/applications/utility/accessories/gnome_calculator.nix` |
| `mercury.home.apps.utility.accessories.gnome_calendar` | Gnome calendar | `home/applications/utility/accessories/gnome_calendar.nix` |
| `mercury.home.apps.utility.accessories.gnome_clocks` | Gnome clocks | `home/applications/utility/accessories/gnome_clocks.nix` |
| `mercury.home.apps.utility.accessories.gnome_fretboard` | Gnome fretboard | `home/applications/utility/accessories/gnome_fretboard.nix` |
| `mercury.home.apps.utility.accessories.gnome_typing` | Gnome typing | `home/applications/utility/accessories/gnome_typing.nix` |
| `mercury.home.apps.utility.accessories.gnome_weather` | Gnome weather | `home/applications/utility/accessories/gnome_weather.nix` |
| `mercury.home.apps.utility.accessories.memorado` | Memorado | `home/applications/utility/accessories/memorado.nix` |
| `mercury.home.apps.utility.accessories.rss` | RSS Client | `home/applications/utility/accessories/rss.nix` |

## Regenerating this page

List every option prefix after adding modules:

```bash
grep -rhoE "cfg = config\.mercury\.[A-Za-z0-9_.]+" modules darwin home | sort -u
```
