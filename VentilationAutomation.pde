import ddf.minim.*;
import processing.serial.*;

DisposeHandler dh;

// Main data arraylists
DataGraph graphCO = new DataGraph(new Rectangle(27, 115, 390, 150));
DataGraph graphCH = new DataGraph(new Rectangle(474, 115, 390, 150));
DataGraph graphAIR = new DataGraph(new Rectangle(27, 386, 390, 150));

// Noise feeders
float xoff = 0.0;
float yoff = 0.0;
float zoff = 0.0;

// Arduino
Serial port;


// Graphic objects
PImage bg;
Minim minim;
AudioPlayer player;


void setup(){
    dh = new DisposeHandler(this);
    bg = loadImage("Grafik.jpg");
    minim = new Minim(this);
    player = minim.loadFile("Alarm.mp3");

    size(1125, 617);
    frameRate(30);
    smooth();

    port = new Serial(this, Serial.list()[6], 9600);
    port.bufferUntil('\n');
}

void serialEvent(Serial port){
    String inString = port.readStringUntil('\n');

    if (inString != null){
        // trim off whitespace
        inString = trim(inString);
        int[] sensors = int(split(inString, ','));

        float valCH = 0, valTemp = 0, valCO = 0, valAIR = 0;

        if (sensors.length == 4){
            valCO = map(sensors[0], 0, 1023, 0, 100);
            valCH = map(sensors[1], 0, 1023, 0, 100);
            valAIR = map(sensors[2], 0, 1023, 0, 100);
            valTemp = map(sensors[3], 0, 1023, 0, 100);
            // println(valCO + " " + valCH + " " + valAIR + " " + valTemp);
        }


        graphCO.update(valCO, 10.0);
        graphCH.update(valCH, 10.0);
        graphAIR.update(valAIR);
    }
}

void draw(){
    background(bg);

    // incerement noise
    xoff += .09;
    yoff += .08;
    zoff += .054;

    // calculate some noise
    // float noiseCO = map(noise(xoff) * width, 0, width, 0, 100);
    // float noiseCH = map(noise(yoff) * width, 0, width, 0, 100);
    // float noiseAIR = map(noise(zoff) * width, 0, width, 0, 100);

    graphCO.draw();
    graphCH.draw();
    graphAIR.draw();

    // Draw current values
    float val = 0.0;
    // Current CO Level
    pushMatrix();
    colorMode(RGB, 100);
    translate(460, 537);
    val = graphCO.getCurrentVal();
    noStroke();
    fill(val, 100 - val, 0);
    rect(0, 0, 140, - map(val, 0, 100, 0, 120));
    colorMode(RGB, 255);
    fill(97, 206, 187);
    text("CO " + map(graphCO.getCurrentVal(), 0, 100, 0, 15), 10, -140);
    popMatrix();

    // Current CH Level
    pushMatrix();
    colorMode(RGB, 100);
    translate(600, 537);
    val = graphCH.getCurrentVal();
    noStroke();
    fill(val, 100 - val, 0);
    rect(0, 0, 140, - map(val, 0, 100, 0, 120));
    colorMode(RGB, 255);
    fill(97, 206, 187);
    text("CH " + map(graphCH.getCurrentVal(), 0, 100, 0, 15), 10, -140);
    popMatrix();

    // Current AIR Level
    pushMatrix();
    colorMode(RGB, 100);
    translate(740, 537);
    val = graphAIR.getCurrentVal();
    noStroke();
    fill(100 - val, val, 0);
    rect(0, 0, 140, - map(val, 0, 100, 0, 120));
    colorMode(RGB, 255);
    fill(97, 206, 187);
    text("AIR " + map(graphAIR.getCurrentVal(), 0, 100, 0, 10), 10, -140);
    popMatrix();

    // Draw flowing data text

    fill(97, 206, 187);
    pushMatrix();
    translate(914, 116);
    for (int i = 0; i < graphCO.vals.length; i++){
        if (graphCO.vals[graphCO.vals.length - i - 1] > 0.0 && i < 34){
            float valCO = map(graphCO.vals[graphCO.vals.length - i - 1], 0, 100, 0, 15);
            text(valCO, 0, i * 12);
        }
    }
    translate(68, 0);
    for (int i = 0; i < graphCH.vals.length; i++){
        if (graphCH.vals[graphCH.vals.length - i - 1] > 0.0 && i < 34){
            float valCH = map(graphCH.vals[graphCH.vals.length - i - 1], 0, 100, 0, 15);
            text(valCH, 0, i * 12);
        }
    }
    translate(68, 0);
    for (int i = 0; i < graphAIR.vals.length; i++){
        if (graphAIR.vals[graphAIR.vals.length - i - 1] > 0.0 && i < 34){
            float valAIR = map(graphAIR.vals[graphAIR.vals.length - i - 1], 0, 100, 0, 10);
            text(valAIR, 0, i * 12);
        }
    }
    popMatrix();

    // play alarm
    // if (graphCO.getCurrentVal() > upperThreshold) player.play();
    // if (graphCH.getCurrentVal() > upperThreshold) player.play();
}

public class DisposeHandler{
    DisposeHandler(PApplet pa){
        pa.registerDispose(this);
    }

    public void dispose(){
        graphCO.log("CO");
        graphCH.log("CH");
        // graphAIR.log("AIR");
    }
}
