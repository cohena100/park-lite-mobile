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
  final polyCorners = 4;
  final polyX = [32.074185, 32.110115, 32.114012, 32.074453];
  final polyY = [34.862457, 34.863090, 34.904034, 34.901593];
  final inside =
      pointInPolygon(32.094242, 34.887563, polyCorners, polyX, polyY);
  final outside =
      pointInPolygon(32.073605, 34.852157, polyCorners, polyX, polyY);
  print('true: $inside, false: $outside');
}


//model.localDBProxy.inMemoryUser = null;
//model.localDBProxy.inMemoryUser = jsonEncode(user1);
//model.localDBProxy.geoPark = geoPark1;
//debugDumpApp();
