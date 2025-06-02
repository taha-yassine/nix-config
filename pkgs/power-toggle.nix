{ writeShellApplication
, power-profiles-daemon
}:

# A simple script to toggle between power profiles (balanced, power-saver, performance)
# using power-profiles-daemon. Intended to be bound to a keyboard shortcut.
# The cycle order is: balanced -> power-saver -> performance -> balanced
writeShellApplication {
  name = "power-toggle";
  runtimeInputs = [ power-profiles-daemon ];
  
  text = ''
    current_profile=$(powerprofilesctl get)
    
    case "$current_profile" in
      "balanced")
        powerprofilesctl set power-saver
        ;;
      "power-saver")
        powerprofilesctl set performance
        ;;
      "performance")
        powerprofilesctl set balanced
        ;;
      *)
        powerprofilesctl set balanced
        ;;
    esac
  '';
}
