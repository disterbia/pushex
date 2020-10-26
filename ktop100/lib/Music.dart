
class Music{
  int id;
  String ranking;
  String jacket;
  String title;
  String artist;
  String album;
  String basetime;
  String youtube;
  String createDate;

  Music({this.id,this.ranking,this.jacket,this.title,this.artist,this.album,this.basetime,this.youtube,this.createDate});
  factory Music.fromJson(Map<String,dynamic> json){
    return Music(
        id : json['id'],
        ranking : json['ranking'],
        jacket  : json['jacket'],
        title : json['title'],
        artist   : json['artist'],
        album   : json['album'],
        basetime   : json['basetime'],
        youtube   : json['youtube'],
        createDate : json['createDate']
    );
  }
}