import 'package:qrunner/models/track_type.dart';

class TrackModel {

  String id;
  String name;
  TrackType trackType;
  DateTime dateTime;
  int numOfPoints;
  List<String> codeList;
  List<String> completedBy;

  TrackModel(this.id, this.name, this.trackType, this.dateTime, this.numOfPoints, this.codeList, this.completedBy);

  @override
  String toString() {
    return 'TrackModel{id: $id, name: $name, trackType: $trackType, dateTime: $dateTime, numOfPoints: $numOfPoints, completedBy: $completedBy}';
  }
}