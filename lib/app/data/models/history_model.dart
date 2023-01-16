import 'package:intl/intl.dart';

class History {
  int? no;
  String? date;
  String? desc;
  String? code;

  History(this.no, this.date, this.desc, this.code);

  History.fromJson(var json, int index) {
    var tempDate = DateFormat('dd-MM-yyyy HH:mm').parse(json['date']);
    String _dateStr = DateFormat("dd MMM yyyy HH:mm").format(tempDate);

    no = index;
    date = _dateStr;
    desc = json["desc"];
    code = json["code"];
  }

  History.empty();
}
