import 'package:intl/intl.dart';

String changeDate(String date) {
  var dateSplit = DateFormat('dd MM yyyy')
      .format(DateTime.parse(date.trim()))
      .toString()
      .split(" ");
  String bulan = "";
  switch (dateSplit[1]) {
    case "01":
      bulan = "Januari";
      break;
    case "02":
      bulan = "Februari";
      break;
    case "03":
      bulan = "Maret";
      break;
    case "04":
      bulan = "April";
      break;
    case "05":
      bulan = "Mei";
      break;
    case "06":
      bulan = "Juni";
      break;
    case "07":
      bulan = "Juli";
      break;
    case "08":
      bulan = "Agustus";
      break;
    case "09":
      bulan = "September";
      break;
    case "10":
      bulan = "Oktober";
      break;
    case "11":
      bulan = "November";
      break;
    case "12":
      bulan = "Desember";
      break;
    default:
  }

  dateSplit[1] = bulan;

  return dateSplit.join(" ");
}
