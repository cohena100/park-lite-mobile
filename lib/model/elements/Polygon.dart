class Polygon {
  final List data;

  Polygon(this.data);

  int get _corners {
    return this.data.length;
  }

  List<double> get _polyX {
    return this.data.map((c) {
      return c[0] as double;
    }).toList();
  }

  List<double> get _polyY {
    return this.data.map((c) {
      return c[1] as double;
    }).toList();
  }

  bool isInside(double lat, double lon) {
    final delta = 0.00005;
    var inside = _pointInPolygon(lat, lon + delta, _corners, _polyX, _polyY);
    inside = inside || _pointInPolygon(lat, lon - delta, _corners, _polyX, _polyY);
    inside = inside || _pointInPolygon(lat + delta, lon, _corners, _polyX, _polyY);
    inside = inside || _pointInPolygon(lat - delta, lon, _corners, _polyX, _polyY);
    inside = inside || _pointInPolygon(lat + delta, lon + delta, _corners, _polyX, _polyY);
    inside = inside || _pointInPolygon(lat + delta, lon - delta, _corners, _polyX, _polyY);
    inside = inside || _pointInPolygon(lat - delta, lon + delta, _corners, _polyX, _polyY);
    inside = inside || _pointInPolygon(lat - delta, lon - delta, _corners, _polyX, _polyY);
    return inside;
  }

  bool _pointInPolygon(double x, double y, int polyCorners, List<double> polyX,
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
}
