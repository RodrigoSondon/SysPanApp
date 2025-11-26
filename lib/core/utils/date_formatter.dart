import 'package:intl/intl.dart';

class DateFormatter {
  // Format: 25/11/2025
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  // Format: 25 Nov 2025
  static String formatDateMedium(DateTime date) {
    return DateFormat('dd MMM yyyy', 'es').format(date);
  }
  
  // Format: 25 de Noviembre de 2025
  static String formatDateLong(DateTime date) {
    return DateFormat('dd \'de\' MMMM \'de\' yyyy', 'es').format(date);
  }
  
  // Format: 10:30 AM
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
  
  // Format: 25/11/2025 10:30 AM
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy hh:mm a').format(date);
  }
  
  // Format for API: 2025-11-25
  static String formatDateForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  
  // Parse from API format
  static DateTime? parseDateFromApi(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
  
  // Get relative date (Hoy, Ayer, etc.)
  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly == today) {
      return 'Hoy';
    } else if (dateOnly == yesterday) {
      return 'Ayer';
    } else if (dateOnly == tomorrow) {
      return 'Mañana';
    } else {
      return formatDate(date);
    }
  }
  
  // Days until date
  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    return targetDate.difference(today).inDays;
  }
  
  // Check if date is expired
  static bool isExpired(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    return targetDate.isBefore(today);
  }
  
  // Check if date is expiring soon (within days)
  static bool isExpiringSoon(DateTime date, {int days = 7}) {
    final daysLeft = daysUntil(date);
    return daysLeft >= 0 && daysLeft <= days;
  }
}
