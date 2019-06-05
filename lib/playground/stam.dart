bool pointInPolygon(double x, double y, int polyCorners, List<double> polyX,
    List<double> polyY) {
  int i;
  int j = polyCorners - 1;
  bool oddNodes = false;
  for (i = 0; i < polyCorners; i++) {
    if (polyY[i] < y && polyY[j] >= y || polyY[j] < y && polyY[i] >= y) {
      if (polyX[i] +
              (y - polyY[i]) / (polyY[j] - polyY[i]) * (polyX[j] - polyX[i]) <
          x) {
        oddNodes = !oddNodes;
      }
    }
    j = i;
  }
  return oddNodes;
}

void main() {
  final tlx = 32.08489;
  final tly = 34.85542;

  final tmx = 32.08487;
  final tmy = 34.85641;

  final bmx = 32.08258;
  final bmy = 34.85631;

  final blx = 32.08258;
  final bly = 34.85486;

  final brx = 32.08258;
  final bry = 34.85775;

  final mmx = 32.08373;
  final mmy = 34.85641;

  final mrx = 32.08381;
  final mry = 34.85805;

  final trx = 32.08504;
  final trY = 34.85801;



  final polyCorners = 5;
  final polyX = [blx, tlx, tmx, mmx, bmx];
  final polyY = [bly, tly, tmy, mmy, bmy];
  final inside =
      pointInPolygon(32.08386711933236, 34.85579478020816, polyCorners, polyX, polyY);
  final outside =
      pointInPolygon(32.08461024, 34.85518323, polyCorners, polyX, polyY);
  print('true: $inside, false: $outside');

  final polyCorners2 = 6;
  final poly2X = [bmx, mmx, tmx, trx, mrx, brx];
  final poly2Y = [bmy, mmy, tmy, trY, mry, bry];
  final inside2 =
  pointInPolygon(32.08450124781803, 34.85733748577502, polyCorners2, poly2X, poly2Y);
  final outside2 =
  pointInPolygon(32.084133095025365, 34.857916842922236, polyCorners, polyX, polyY);
  print('true2: $inside2, false2: $outside2');

}


//model.localDBProxy.inMemoryUser = null;
//model.localDBProxy.inMemoryUser = jsonEncode(user1);
//model.localDBProxy.geoPark = geoPark1;
//debugDumpApp();
