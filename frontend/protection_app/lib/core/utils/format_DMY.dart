
import 'package:intl/intl.dart';

String formatDatebyDMY(DateTime datetime){
  return DateFormat("d  mm , yyyy").format(datetime);
}