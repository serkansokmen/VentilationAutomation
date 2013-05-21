import java.util.Date;

class DataGraph
{
    float[] vals;
    ArrayList<ValueOnTime> logVals = new ArrayList<ValueOnTime>();
    Rectangle drawRect;
    int currentDrawPos;

    DataGraph (Rectangle drawRect) {
        this.vals = new float[drawRect.width];
        this.drawRect = drawRect;

        currentDrawPos = this.drawRect.width;
    }

    void update(float val){
        if (this.currentDrawPos == 0) this.currentDrawPos = this.drawRect.width;
        else this.currentDrawPos -= 1;

        for (int i = 1; i < this.drawRect.width; i++){
            this.vals[i - 1] = this.vals[i];
        }
        this.vals[this.drawRect.width - 1] = val;

        logVals.add(new ValueOnTime(val));
    }

    void draw(){
        pushMatrix();
        translate(this.drawRect.x, this.drawRect.y + this.drawRect.height);
        for (int i = 1; i < this.drawRect.width; i++){
            fill(255, 0, 0);
            noStroke();
            rect(i, 0, 1, - this.vals[i]);

            noFill();
            stroke(255);
            point(i, - this.vals[i]);
        }
        popMatrix();
    }

    void log(String name){
        // log to text file
        String[] vals = new String[this.logVals.size()];

        for (int i = 0; i < this.logVals.size(); i++) {
            vals[i] = this.logVals.get(i).getLogString() + "\t";
        }

        saveStrings("data/logs/" + name + ".txt", vals);
    }
};

class ValueOnTime
{
    float val;
    Date date;

    public ValueOnTime (float val) {
        this.val = val;
        this.date = new Date();
    }

    String getLogString(){
        return String.valueOf(this.val) + "\t" + date.toString();
    }
};
