import 'package:flutter/services.dart';

String rupiah(int value) {
  return 'Rp ${formatDots(value)}';
}

String formatDots(int value) {
  final neg = value < 0;
  final s = value.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return '${neg ? '-' : ''}${b.toString()}';
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue();
    }
    final intVal = int.tryParse(digitsOnly) ?? 0;
    final formatted = formatDots(intVal);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

String twoDigits(int n) => n.toString().padLeft(2, '0');

String formatMinute(int minute) =>
    '${twoDigits(minute ~/ 60)}:${twoDigits(minute % 60)}';

String dayName(int weekday) => const [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ][weekday - 1];

String timeAgo(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'Baru saja';
  if (d.inMinutes < 60) return '${d.inMinutes} mnt lalu';
  if (d.inHours < 24) return '${d.inHours} jam lalu';
  return '${d.inDays} hari lalu';
}

String formatCountdown(Duration d) =>
    '${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}';

