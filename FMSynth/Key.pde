
class Key {

  private float x;
  private float y; 

  private float w; 
  private float h; 

  private int midiNote; 

  private color colFill;
  private color colStroke; 
  private color colKey; 

  private PVector translatePVector;


  Key(float x_, float y_, 
    float w_, float h_, 
    int midiNote_, 
    color colFill_, 
    color colStroke_, 
    PVector translatePVector_) {

    this.x = x_;
    this.y = y_;

    this.w = w_;
    this.h = h_;


    this.midiNote = midiNote_;

    this.colFill = colFill_;
    this.colKey = colFill_;  // constant to reset to the original color
    this.colStroke = colStroke_; 


    this.translatePVector = translatePVector_;
  }

  public void display() {

    pushMatrix();
    translate(this.translatePVector.x, this.translatePVector.y); 
    fill(this.colFill);
    if (this.colStroke==-1) 
      noStroke(); 
    else
      stroke(this.colStroke);      
    rect(this.x, this.y, this.w, this.h);
    popMatrix();
  }

  public int getMidiNote() {
    return this.midiNote;
  }

  public void setColFill(color col) {
    this.colFill = col;
  }

  public color getColKey() {
    return this.colKey;
  }
}
