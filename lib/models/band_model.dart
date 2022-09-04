
class Band{
  //DATA MEMBERS
  String id;
  String name;
  int votes;

  //CONSTRUCTOR
  Band({
    required this.id,
    required this.name,
    required this.votes
  });

  //METHODS
  factory Band.fromMap(Map<String, dynamic> obj) => Band(
    id: obj['id'],
    name: obj['name'],
    votes: obj['votes']
  ); //A FACOTRY CONSTRUCTOR IS A CONSTRUCTOR THAT RETURNS AN OBJECT OF ITS OWN CLASS, IN THIS CASE GIVEN A MAP OBJECT IT RETURNS A BAND OBJECT






}