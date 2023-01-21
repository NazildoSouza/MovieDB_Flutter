import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formattedDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String formattedDatePerson() {
    return DateFormat('yyyy').format(this);
  }
}

extension NumberExtension on num {
  String formattedPrice() {
    return NumberFormat('\$###,##0.00', 'pt-BR').format(this);
  }
}
