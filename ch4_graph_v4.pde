// Main data arraylists
DataGraph graphCO = new DataGraph(new Rectangle(27, 116, 390, 150));
DataGraph graphCH = new DataGraph(new Rectangle(474, 116, 390, 150));
DataGraph graphAIR = new DataGraph(new Rectangle(27, 388, 390, 150));

// Noise feeders
float xoff = 0.0;
float yoff = 0.0;
float zoff = 0.0;

// Graphic objects
PImage bg;

void setup(){
    size(1125, 617);

    bg = loadImage("Grafik.jpg");
}

void draw(){
    background(bg);

    // incerement noise
    xoff += .075;
    yoff += .008;
    zoff += .012;

    // calculate some noise
    float noiseCO = map(noise(xoff) * width, 0, width, 0, 100);
    float noiseCH = map(noise(yoff) * width, 0, width, 0, 100);
    float noiseAIR = map(noise(zoff) * width, 0, width, 0, 100);

    graphCO.update(noiseCO);
    graphCH.update(noiseCH);
    graphAIR.update(noiseAIR);

    graphCO.draw();
    graphCH.draw();
    graphAIR.draw();
}


