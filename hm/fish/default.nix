{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    eza
    kitty
    libnotify
  ];

  programs.fish = {
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair;
      }
      {
        name = "pure";
        src = pkgs.fishPlugins.pure;
      }
    ];

    shellAbbrs = {
      bata = "bat -A";
      gaa = "git add --all";
      gcm = "git commit -m";
      gib = "git checkout -b";
      gid = "git diff";
      gif = "git fetch";
      gip = "git pull";
      gis = "git status";
    };

    functions = {
      git.body = ''
        if test (count $argv) -ge 1; and test "$argv[1]" = push
            __git_push_guard $argv[2..]; or return 1
            command git $argv
        else
            command git $argv
        end
      '';

      gps.body = "__git_push_guard $argv; or return 1; command git push $argv";

      __git_push_guard.body = ''
        set -l red     (set_color -o brred)
        set -l yellow  (set_color -o bryellow)
        set -l cyan    (set_color -o brcyan)
        set -l magenta (set_color -o brmagenta)
        set -l green   (set_color -o brgreen)
        set -l dim     (set_color 245)
        set -l reset   (set_color normal)
        set -l bold    (set_color -o white)

        set -l user_name  (git config user.name  2>/dev/null; or echo "unknown")
        set -l user_email (git config user.email 2>/dev/null; or echo "unknown")
        set -l repo_root  (git rev-parse --show-toplevel 2>/dev/null; or echo "unknown")
        set -l repo_name  (basename "$repo_root")
        set -l remote_url (git remote get-url origin 2>/dev/null; or echo "no remote")
        set -l branch     (git symbolic-ref --short HEAD 2>/dev/null; or echo "detached")

        set -l is_force false
        for arg in $argv
            switch $arg
                case -f --force --force-with-lease --force-if-includes
                    set is_force true
            end
        end

        echo ""
        echo "$dim─────────────────────────────────────────$reset"
        echo "$bold  GIT PUSH SAFETY GATE$reset"
        echo "$dim─────────────────────────────────────────$reset"
        echo ""
        echo "  $dim Identity:$reset  $cyan$user_name$reset <$cyan$user_email$reset>"
        echo "  $dim   Branch:$reset  $green$branch$reset"
        echo "  $dim     Repo:$reset  $magenta$repo_name$reset"
        echo "  $dim   Remote:$reset  $remote_url"

        if test "$is_force" = true
            echo ""
            echo "  $red *** FORCE PUSH DETECTED ***$reset"
            echo "  $yellow This will rewrite remote history!$reset"
        end

        echo ""
        echo "$dim─────────────────────────────────────────$reset"
        echo ""

        read -l -P "$yellow  Proceed with push? [y/N]:$reset " confirm

        switch (string lower -- "$confirm")
            case y yes
                return 0
            case '*'
                echo ""
                echo "  $red Push aborted.$reset"
                echo ""
                return 1
        end
      '';

      # print a line range from a file
      gln = {
        description = "Get lines from a file: gln <file> <start> <end>";
        body = ''
          if test (count $argv) -ne 3
              echo "Usage: gln <file> <start_line> <end_line>"
              return 1
          end
          if not test -f $argv[1]
              echo "Error: File '$argv[1]' not found"
              return 1
          end
          set -l next (math $argv[3] + 1)
          sed -n "$argv[2],$argv[3] p; $next q" $argv[1]
        '';
      };

      icat.body = "kitten icat $argv";

      ls.body = "eza --time-style=long-iso --group-directories-first --icons --color=always $argv";
      ll.body = "eza --time-style=long-iso --group-directories-first --icons -l --color=always $argv";

      timer.body = ''
        set -l input   $argv[1]
        set -l message (test (count $argv) -gt 1; and echo $argv[2..-1]; or echo "Time's up!")

        set -l total_seconds
        if string match -qr '^\d+m$' "$input"
            set total_seconds (math (string replace 'm' "" -- "$input") "*" 60)
        else if string match -qr '^\d+$' "$input"
            set total_seconds $input
        else
            echo "Usage: timer <seconds|minutes e.g. 90 or 5m>"
            return 1
        end

        set -l remaining $total_seconds
        while test $remaining -gt 0
            set -l mins  (math -s0 "$remaining / 60")
            set -l secs  (math "$remaining % 60")
            set -l blink (test (math "$remaining % 2") -eq 0; and echo "*"; or echo " ")
            printf "\r%s %02d:%02d" $blink $mins $secs
            sleep 1
            set remaining (math $remaining - 1)
        end

        printf "\r\033[K"
        notify-send "Timer Expired" "$message"
      '';

      stopwatch.body = ''
        set start (date +%s.%N)
        while true
            printf "\r%.1f " (math (date +%s.%N) - $start)
            sleep 0.1
        end
      '';

      reload-config = {
        onVariable = "_reload_config";
        body = "source ~/.config/fish/config.fish";
      };
    };
  };
}
