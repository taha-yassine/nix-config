{
  writeShellApplication,
  power-profiles-daemon,
}:

# Toggle between the balanced, power-saver, and performance profiles.
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
