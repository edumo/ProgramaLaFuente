class FountainModel {

  List<FountainCell> cells = new ArrayList();
  Map<String, FountainCell> cellsByPos = new HashMap();

  public void init() {

    //añadimos las celdas estandas
    for (int i = 0; i<6; i++) {
      for (int j = 0; j<6; j++) {
        FountainCell cell = new FountainCell(new PVector(i, j), 0, 0, 0, 0); 
        cells.add(cell);
        cellsByPos.put(cell.pos.x+"-"+cell.pos.y, cell);
      }
    }
    FountainCell cell = new FountainCell(new PVector(6, 6), 0, 0, 0, 0)); 
    cells.add(cell);
    cellsByPos.put(cell.pos.x+"-"+cell.pos.y, cell);
  }

  public FountainCell getCell(int x, int y) {
    return cellsByPos.get(x+"-"+y);
  }
}


class FountainCell {

  public FountainCell(PVector pos, float chorro, float difusor, int rgb1, int rgb2) {
    this.pos = pos;
    this.chorro = chorro;
    this.difusor = difusor;
    this.rgb1 = rgb1;
    this.rgb2 = rgb2;
  }

  PVector pos;

  float chorro;

  float difusor;

  int rgb1;

  int rgb2;
}