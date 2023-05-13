import 'package:qrunner/constants/strings.dart';

enum TrackType {
  pointCollecting(kPointCollecting),
  fixedOrderCollecting(kFixedOrderedCollecting);

  final String name;

  const TrackType(this.name);
}