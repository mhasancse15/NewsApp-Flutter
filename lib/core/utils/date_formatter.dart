abstract class DateFormatter {
  const DateFormatter._();

  /// Formats a [DateTime] as a relative "time ago" string, e.g. "2h ago",
  /// "5m ago", "3d ago", falling back to a short date for older items.
  static String timeAgo(DateTime? dateTime) {
    if (dateTime == null) return '';
    final Duration diff = DateTime.now().toUtc().difference(dateTime.toUtc());

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year}';
  }
}
