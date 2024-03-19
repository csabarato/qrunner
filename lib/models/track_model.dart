import 'package:qrunner/models/track_type.dart';

class TrackModel {

  String id;
  String name;
  TrackType trackType;
  int numOfPoints;
  List<String> codeList;

  TrackModel(this.id, this.name, this.trackType, this.numOfPoints, this.codeList);

  @override
  String toString() {
    return 'TrackModel{id: $id, name: $name, trackType: $trackType, numOfPoints: $numOfPoints}';
  }
}