class FountainModel {

  ArrayList<FountainCell> cells = new ArrayList();
  HashMap<String, FountainCell> cellsByPos = new HashMap();

  public void init() {

    //añadimos las celdas estandas
    for (int i = 0; i<6; i++) {
      for (int j = 0; j<6; j++) {
        FountainCell cell = new FountainCell(new PVector(j, i), 0, false, 0, 0); 
        cells.add(cell);
        cellsByPos.put(cell.pos.x+"-"+cell.pos.y, cell);
      }
    }
    
    FountainCell cell = new FountainCell(new PVector(6, 5), 0, false, 0, 0); 
    cells.add(cell);
    cellsByPos.put(cell.pos.x+"-"+cell.pos.y, cell);
  }

  public FountainCell getCell(int x, int y) {
    return cellsByPos.get(x+"-"+y);
  }
  
  public void setState(String cmd) {
    if (cmd.length() < 27) {
      System.err.println("TENemos un prolema con la cadena no tiene el tamaño mínimo y el tamño importa");
    }

    for (FountainCell cell : cells) {
      char c = cmd.charAt((int)(cell.pos.x+cell.pos.y*6));
      int value = c - '0';
      
      if (value <= 9) {
        cell.chorro = value;
        cell.difusor = false;
      } else {
        cell.chorro = 0;
        cell.difusor = true;
      }
      println("cell "+cell.pos.x+":"+cell.pos.y+" ->"+value+" ->difusor:"+cell.difusor );
    }
  }
}



class FountainCell {

  public FountainCell(PVector pos, float chorro, boolean difusor, int rgb1, int rgb2) {
    this.pos = pos;
    this.chorro = chorro;
    this.difusor = difusor;
    this.rgb1 = rgb1;
    this.rgb2 = rgb2;
  }

 public  PVector pos;

 public  float chorro;

  public boolean difusor;

  int rgb1;

  int rgb2;
}
