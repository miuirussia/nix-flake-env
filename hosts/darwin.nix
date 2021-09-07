{ config, pkgs, lib, ... }:

{
  imports = [
    ./darwin-bootstrap.nix
  ];

  environment = {
    variables = {
      # https://github.com/nix-community/home-manager/issues/423
      TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
    };
  };

  programs.bash = {
    enable = true;
  };

  system = {
    defaults = {
      # System - Enable font smoothing
      # Enables subpixel font rendering on non-Apple LCDs
      NSGlobalDomain.AppleFontSmoothing = 1;

      # Keyboard - Enable full keyboard access for all controls.
      # (e.g., enable Tab in modal dialogs)
      NSGlobalDomain.AppleKeyboardUIMode = 3;

      # Keyboard - Disable press-and-hold for keys in favor of key repeat
      NSGlobalDomain.ApplePressAndHoldEnabled = false;

      # Finder - Show filename extensions.
      NSGlobalDomain.AppleShowAllExtensions = true;

      # System - Automatically show scroll bars
      NSGlobalDomain.AppleShowScrollBars = "Automatic";

      # System - What temperature unit to use
      NSGlobalDomain.AppleTemperatureUnit = "Celsius";

      # Keyboard - Set a short Delay until key repeat.
      NSGlobalDomain.InitialKeyRepeat = 15;

      # Keyboard - Set a fast keyboard repeat rate.
      NSGlobalDomain.KeyRepeat = 1;

      # System - Disable automatic capitalization as it’s annoying when typing code
      NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;

      # System - Disable smart dashes as they’re annoying when typing code
      NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;

      # System - Disable automatic period substitution as it’s annoying when typing code
      NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;

      # System - Disable smart quotes as they’re annoying when typing code
      NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;

      # System - Disable auto-correct
      NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;

      # iCloud - Don't save new documents to iCloud by default
      NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;

      # System - Expand save panel by default.
      NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
      NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;

      # System - Decrease window resize duration
      NSGlobalDomain.NSWindowResizeTime = "0.001";

      # Printer - Expand print panel by default.
      NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
      NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;

      # System - Disable 'Are you sure you want to open this application?' dialog
      LaunchServices.LSQuarantine = false;

      # Trackpad - Disable natural scrolling
      NSGlobalDomain."com.apple.swipescrolldirection" = false;

      # Dock - Don’t show recent applications in Dock
      dock.show-recents = false;

      # Dock - Make icons of hidden applications translucent
      dock.showhidden = true;

      # Dock - Don’t automatically rearrange Spaces based on most recent use
      dock.mru-spaces = false;

      # Dock - Orient to the bottom
      dock.orientation = "bottom";

      # Dock - Minimize apps to their icon
      dock.minimize-to-application = true;

      # Finder - Disable the warning when changing a file extension
      finder.FXEnableExtensionChangeWarning = false;

      # Finder - Add quit option
      finder.QuitMenuItem = true;

      # Screencapture - Save screenshots to the desktop
      screencapture.location = "$HOME/Desktop";


    };

    # Keyboard - Enable keyboard mappings
    keyboard.enableKeyMapping = true;

    activationScripts.postActivation.text = ''
      # Finder - Set $HOME as the default location for new windows
      defaults write com.apple.finder NewWindowTarget -string "PfDe"
      defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME"

      # Bluetooth - Increase sound quality for headphones/headsets
      defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

      # Printer - Automatically quit printer app once the print jobs complete
      defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

      # Safari - Enable the Develop menu and the Web Inspector
      defaults write com.apple.Safari IncludeDevelopMenu -bool true
      defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
      defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

      # Safari - Add a context menu item for showing the Web Inspector in web views
      defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

      # Safari - Press Tab to highlight each item on a web page
      defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
      defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

      # Safari - Prevent Safari from opening ‘safe’ files automatically after downloading
      defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

      # Safari - Make Safari’s search banners default to Contains instead of Starts With
      defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

      # Safari - Enable continuous spellchecking
      defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true

      # Safari - Disable auto-correct
      defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

      # Safari - Warn about fraudulent websites
      defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

      # Safari - Disable Java
      defaults write com.apple.Safari WebKitJavaEnabled -bool false
      defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false

      # Safari - Block pop-up windows
      defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
      defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

      # Safari - Disable auto-playing video
      defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
      defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
      defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
      defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false

      # Safari Enable “Do Not Track”
      defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

      # Safari - Update extensions automatically
      defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

      # Terminal - Only use UTF-8
      defaults write com.apple.terminal StringEncodings -array 4

      # Terminal - Enable Secure Keyboard Entry
      # See: https://security.stackexchange.com/a/47786/8918
      defaults write com.apple.terminal SecureKeyboardEntry -bool true

      # Terminal - Disable the annoying line marks
      defaults write com.apple.Terminal ShowLineMarks -int 0

      # Activity Monitor - Show the main window when launching
      defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

      # Activity Monitor - Visualize CPU usage in the Dock icon
      defaults write com.apple.ActivityMonitor IconType -int 5

      # Activity Monitor - Show all processes
      defaults write com.apple.ActivityMonitor ShowCategory -int 0

      # Activity Monitor - Sort results by CPU usage
      defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
      defaults write com.apple.ActivityMonitor SortDirection -int 0

      # TextEdit - Use plain text mode for new documents
      defaults write com.apple.TextEdit RichText -int 0

      # TextEdit - Open and save files as UTF-8
      defaults write com.apple.TextEdit PlainTextEncoding -int 4
      defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

      # QuickTime Player - Auto-play videos when opened with QuickTime Player
      defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

      # AirDrop - Use AirDrop over every interface
      defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

      # Mac App Store - Enable the automatic update check
      defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

      # Mac App Store - Download newly available updates in background
      defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

      # Mac App Store - Check for software updates daily, not just once per week
      defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

      # Mac App Store - Install System data files & security updates
      defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

      # Mac App Store - Turn on app auto-update
      defaults write com.apple.commerce AutoUpdate -bool true

      # Mac App Store - Allow to reboot machine on macOS updates
      defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

      # Photos - Prevent Photos from opening automatically when devices are plugged in
      defaults write com.apple.ImageCapture disableHotPlug -bool true
    '';
  };

  # Copy applications into ~/Applications/Nix Apps. This workaround allows us
  # to find applications installed by nix through spotlight.
  system.activationScripts.applications.text = pkgs.lib.mkForce (
    ''
      rm -rf ~/Applications/Nix\ Apps
      mkdir -p ~/Applications/Nix\ Apps
      for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
        src="$(/usr/bin/stat -f%Y "$app")"
        echo "copying $app"
        cp -rL "$src" ~/Applications/Nix\ Apps
      done
    ''
  );
}
