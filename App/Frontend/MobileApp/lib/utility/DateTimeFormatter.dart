class DateTimeFormatter{
  static String formattedDate(DateTime date){
    return date.day.toString() + "/" + date.month.toString() + "/" + date.year.toString();
  }

  static String formattedTime(DateTime date){
    String hour = date.hour < 9 ? "0" + date.hour.toString() : date.hour.toString();
    String min = date.minute < 9 ? "0" + date.minute.toString() : date.minute.toString();
    return hour + ":" + min;
  }
}