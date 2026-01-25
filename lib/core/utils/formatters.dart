class Formatters {
  Formatters._(); // Private constructor to prevent instantiation

  // Format percentage
  static String formatPercentage(double value) {
    return "${(value * 100).toInt()}%";
  }

  // Format time
  static String formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return "${hours}h ${minutes}m";
    } else if (minutes > 0) {
      return "${minutes}m ${secs}s";
    } else {
      return "${secs}s";
    }
  }

  // Format date
  static String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Format username greeting
  static String formatGreeting(String username) {
    return "Hello, $username 👋";
  }
}

