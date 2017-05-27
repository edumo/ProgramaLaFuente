class ChildSystem {
  ArrayList<Child> children;

  ChildSystem() {
    children = new ArrayList<Child>();
  }

  void addChild() {
    children.add(new Child());
  }

  void run() {
    for (int i = children.size()-1; i >= 0; i--) {
      Child p = children.get(i);
      p.run();
    }
  }
}