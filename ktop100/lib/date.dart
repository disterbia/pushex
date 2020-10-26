
class Date{
  List<String> date;

  Date({this.date});
  factory Date.fromJson(List<String> json){
    return Date(
      date : json,
    );
  }
}