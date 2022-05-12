class Series{
  int id;
  String name;
  String genre;
  String theDirector;
  int beginYear;
  int endYear;

  Series(Name, Genre, TheDirector, BeginYear, EndYear){
    this.name = Name;
    this.genre = Genre;
    this.theDirector = TheDirector;
    this.beginYear = BeginYear;
    this.endYear = EndYear;
  }

  Series.WithID(MovieID, Name, Genre, TheDirector, BeginYear, EndYear){
    this.id = MovieID;
    this.name = Name;
    this.genre = Genre;
    this.theDirector = TheDirector;
    this.beginYear = BeginYear;
    this.endYear = EndYear;
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['ID'] = id;
    map['Name'] = name;
    map['Genre'] = genre;
    map['TheDirector'] = theDirector;
    map['BeginYear'] = beginYear;
    map['EndYear'] = endYear;
    return map;
  }


}