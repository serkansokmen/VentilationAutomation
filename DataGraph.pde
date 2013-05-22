import java.util.Date;

class DataGraph
{
    float[] vals;
    ArrayList<ValueOnTime> logVals = new ArrayList<ValueOnTime>();
    Rectangle drawRect;

    DataGraph (Rectangle drawRect) {
        this.vals = new float[drawRect.width];
        this.drawRect = drawRect;
    }

    float getCurrentVal(){
        return this.vals[this.vals.length - 1];
    }

    void update(float val){
        for (int i = 1; i < this.drawRect.width; i++){
            this.vals[i - 1] = this.vals[i];
        }
        this.vals[this.drawRect.width - 1] = val;
    }

    void update(float val, float upperThreshold){
        this.update(val);

        if (val > upperThreshold){
            logVals.add(new ValueOnTime(val));
        }
    }

    void draw(){
        pushMatrix();
        translate(this.drawRect.x, this.drawRect.y + this.drawRect.height);
        colorMode(RGB, 100);
        for (int i = 1; i < this.drawRect.width; i++){
            fill((int)this.vals[i], 100 - (int)this.vals[i], 0);
            noStroke();
            rect(i, 0, 1, - this.vals[i] * this.drawRect.height * .01);

            noFill();
            stroke(255);
            point(i, - this.vals[i] * this.drawRect.height * .01);
        }
        colorMode(RGB, 255);
        popMatrix();
    }

    void log(String fileName){
        // log to text file
        if (this.logVals.size() > 0){

            String[] vals = new String[this.logVals.size()];

            for (int i = 0; i < this.logVals.size(); i++) {
                vals[i] = this.logVals.get(i).getLogString() + "\t";
            }
            Date date = new Date();
            String folderName = date.getYear() + "/" + date.getMonth() + "/" + date.getDate() + "/";

            saveStrings("data/logs/" + folderName + fileName + ".txt", vals);
        }
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
