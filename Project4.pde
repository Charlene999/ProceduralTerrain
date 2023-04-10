/*
Charlene Creighton
 CAP Project 4
 November 6, 2022
 */

// Import Statements
import controlP5.*;
ControlP5 control;
// UI Objects
Slider Rows, Cols, TerrainSize, HeightMod, SnowThresh;
Button Generate, Smooth;
PImage curImage;
Textfield FileLoad;
Toggle Stroke, Color, Blend;
// Labels
Textlabel rowsLabel, colsLabel, terrainSizeLabel, heightModLabel, snowThreshLabel;
Textlabel generateLabel, fileLoadLabel, strokeLabel, colorLabel, blendLabel;
boolean gen = false;
String fileText = "";
// Important global variables
ArrayList<PVector> vertices = null;
ArrayList<Integer> indices = null;
ArrayList<Integer> triangles = null;
int Index = 0;
float gridSize = 32;
float rows = 4, cols = 4;
// Camera Object
Camera myCam = new Camera();
int smoothCount = 0;
boolean Smooth1 = false;

void keyPressed() {
  // If spacebar pressed call CycleTarget
  if (key == ENTER) 
    if (myCam != null)
    {
      fileText = FileLoad.getText();
      gridSize = TerrainSize.getValue();
      rows = Rows.getValue();
      cols = Cols.getValue();
      smoothCount = 0;
      Smooth.setOff();
      Smooth1 = false;
    }
}
void mouseWheel(MouseEvent event) {

  // Zoom in if less than 0, out if greater
  if (event.getCount() > 0)
  {
    for (float i = 0; i < event.getCount(); i++)
    {
      if (myCam == null)
        break;

      myCam.Radius /= .75;
      if (myCam.Radius >=200)
      {
        myCam.Radius =200;
        break;
      }
    }
  } else
  {
    for (float i =0; i > event.getCount(); i--)
    {
      if (myCam == null)
        break;

      myCam.Radius *= .75;
      if (myCam.Radius <= 10)
      {
        myCam.Radius = 10;
        break;
      }
    }
  }
  myCam.Update();
}

class Camera
{
  // Initialize camera variables
  ArrayList<PVector> Targets = new ArrayList();
  float xPos;
  float yPos;
  float zPos;
  float Radius;
  float lookX;
  float lookY;
  float lookZ;
  float derX;
  float derY;
  float derZ;
  float Phi;
  float Theta;

  Camera()
  {
    lookX = 0;
    lookY = 0;
    lookZ = 0;
    xPos = -148.6;
    yPos = -5.5;
    zPos = 19.58;
    Radius = 150;
  }
  
  void callSmooth()
  {
    int vertCount = 0;
    ArrayList<Float> avgs = new ArrayList(vertices.size());
    // Add neighboring vertices and get their average
      for (int b = 0; b <= rows; b++)
      {
        for (int d = 0; d <= cols; d++)
        {
          ArrayList<Integer> neighbors = new ArrayList();
            if (b == 0 && d == 0)
            {
              neighbors.add(vertCount);
              neighbors.add(vertCount + 1);
              neighbors.add(vertCount + (int) cols + 1);
              float avg = 0;
              for (int k = 0; k < neighbors.size(); k++)
              {
                avg += vertices.get(neighbors.get(k)).y;
              }
              
              avg = avg / neighbors.size();
              avgs.add(avg);
            }
            
            else if (b == 0 && d != 0 && d < (int) cols)
            {
              neighbors.add(vertCount);
              neighbors.add(vertCount + 1);
              neighbors.add(vertCount - 1);
              neighbors.add(vertCount + (int) cols + 1);
              float avg = 0;
              for (int k = 0; k < neighbors.size(); k++)
              {
                avg += vertices.get(neighbors.get(k)).y;
              }
              
              avg = avg / neighbors.size();
              avgs.add(avg);
            }
            
            else if (b != 0 && d == 0 && b < (int) rows)
            {
              neighbors.add(vertCount);
              neighbors.add(vertCount + 1);
              neighbors.add(vertCount - 1);
              neighbors.add(vertCount - ((int) cols + 1));
              float avg = 0;
              for (int k = 0; k < neighbors.size(); k++)
              {
                avg += vertices.get(neighbors.get(k)).y;
              }
              
              avg = avg / neighbors.size();
              avgs.add(avg);
            }
            
            else if (b != 0 && d != 0 && d < (int) cols && b < (int) rows)
            {
              neighbors.add(vertCount);
              neighbors.add(vertCount + 1);
              neighbors.add(vertCount - 1);
              neighbors.add(vertCount + (int) cols + 1);
              neighbors.add(vertCount - ((int) cols + 1));
              float avg = 0;
              for (int k = 0; k < neighbors.size(); k++)
              {
                avg += vertices.get(neighbors.get(k)).y;
              }
              
              avg = avg / neighbors.size();
              avgs.add(avg);
            }
            
            else if (b == (int) rows && d == (int) cols)
            {
              neighbors.add(vertCount);
              neighbors.add(vertCount - 1);
              neighbors.add(vertCount - ((int) cols + 1));
              float avg = 0;
              for (int k = 0; k < neighbors.size(); k++)
              {
                avg += vertices.get(neighbors.get(k)).y;
              }
              
              avg = avg / neighbors.size();
              avgs.add(avg);
            }
            
            else if (b == 0 && d == (int) cols)
            {
              neighbors.add(vertCount);
              neighbors.add(vertCount - 1);
              neighbors.add(vertCount + (int) cols + 1);
              float avg = 0;
              for (int k = 0; k < neighbors.size(); k++)
              {
                avg += vertices.get(neighbors.get(k)).y;
              }
              
              avg = avg / neighbors.size();
              avgs.add(avg);
            }
            
            else if (b == (int) rows && d == 0)
            {
              neighbors.add(vertCount);
              neighbors.add(vertCount + 1);
              neighbors.add(vertCount - ((int) cols + 1));
              float avg = 0;
              for (int k = 0; k < neighbors.size(); k++)
              {
                avg += vertices.get(neighbors.get(k)).y;
              }
              
              avg = avg / neighbors.size();
              avgs.add(avg);
            }
            
            else if (b != 0 && d == (int) cols && b < (int) rows)
            {
              neighbors.add(vertCount);
              neighbors.add(vertCount - 1);
              neighbors.add(vertCount + (int) cols + 1);
              neighbors.add(vertCount - ((int) cols + 1));
              float avg = 0;
              for (int k = 0; k < neighbors.size(); k++)
              {
                avg += vertices.get(neighbors.get(k)).y;
              }
              
              avg = avg / neighbors.size();
              avgs.add(avg);
            }
            
            else if (b == (int) rows && d != 0 && d < (int) cols)
            {
              neighbors.add(vertCount);
              neighbors.add(vertCount + 1);
              neighbors.add(vertCount - 1);
              neighbors.add(vertCount - ((int) cols + 1));
              float avg = 0;
              for (int k = 0; k < neighbors.size(); k++)
              {
                avg += vertices.get(neighbors.get(k)).y;
              }
              
              avg = avg / neighbors.size();
              avgs.add(avg);
            }
            vertCount++;
          } // end inner for
        } // end outer for
      
        for (int w = 0; w < avgs.size(); w++)
        {
          vertices.get(w).y = avgs.get(w);
        }
  }
  
  // Writes Grid for UI
  void LaunchGrid()
  {
    if ( vertices == null || indices == null)
      return;

    if (vertices.size() == 0 || indices.size() == 0)
      return;
      
    color snow = color(255, 255, 255);
    color grass = color(143, 170, 64);
    color rock = color(135, 135, 135);
    color dirt = color(160, 126, 84);
    color water = color(0, 75, 200);
    
    String textFile = fileText;
    textFile += ".png";
    curImage = loadImage(textFile);
    float hfcolor;
    int vert_index = 0;
    color[] colors = new color[vertices.size()];
    
    // Determine color of each vertex
    if (curImage != null)
    {
      curImage.loadPixels();
      for (int i = 0; i <= (int)rows; i++)
      {
        for (int j = 0; j <= (int)cols; j++)
        {
          int x = (int) map(j, 0, (int) cols+1, 0, curImage.width);
          int y = (int) map(i, 0, (int) rows+1, 0, curImage.height);
          int Color = curImage.get(x, y);
          hfcolor = map(red(Color), 0, 255, 0, 1.0);
          vert_index = i * ((int) cols + 1) + j;
          float ratio = 0;
          vertices.get(vert_index).y = hfcolor;
          float relHeight = abs(vertices.get(vert_index).y * HeightMod.getValue() / (0-SnowThresh.getValue()));
          if (vert_index >= vertices.size())
            return;
          vertices.get(vert_index).y *= HeightMod.getValue();
          if (relHeight > .8)
          {
            ratio = (relHeight - .8) / .2f;

            if (Blend.getState() == true)
              colors[vert_index] = lerpColor(rock, snow, ratio);

            else
              colors[vert_index] = snow;
              
          } 
          else if (relHeight <= .8 && relHeight > .4)
          {
            ratio = (relHeight - .4f) / .4f;
            if (Blend.getState() == true)
              colors[vert_index] = lerpColor(grass, rock, ratio);

            else
              colors[vert_index] = rock;
          } 
          else if (relHeight <= .4 && relHeight > .2)
          {
            ratio = (relHeight - .2f) / .2f;
            if (Blend.getState() == true)
              colors[vert_index] = lerpColor(dirt, grass, ratio);

            else
              colors[vert_index] = grass;
          }
          else
          {
            ratio = relHeight/ .2f;
            if (Blend.getState() == true)
              colors[vert_index] = lerpColor(water, dirt, ratio);

            else
              colors[vert_index] = water;
          }
        }
      }
    } // End if null image

    strokeWeight(1);
    pushMatrix();
      rotate(179);
    
    // If Smooth button is pressed, smooth image
    if (Smooth1 == true)
      smoothCount++;
      
    for (int u = 0; u < smoothCount; u++)
        callSmooth();
    
    Smooth1 = false;
    
    // Draw vertices for each triangle
    for (int c = 0; c < indices.size(); c+=4)
    {
      if (Stroke.getState() == true)
        stroke(0, 0, 0);

      else
        noStroke();
      
      beginShape(TRIANGLES);

      if (curImage == null || Color.getState() == false)
      {
        fill(255, 255, 255);
        vertex(vertices.get(indices.get(c)).x, vertices.get(indices.get(c)).y, vertices.get(indices.get(c)).z); 
        vertex(vertices.get(indices.get(c + 1)).x, vertices.get(indices.get(c + 1)).y, vertices.get(indices.get(c + 1)).z); 
        vertex(vertices.get(indices.get(c + 2)).x, vertices.get(indices.get(c + 2)).y, vertices.get(indices.get(c + 2)).z); 

        fill(255, 255, 255);
        vertex(vertices.get(indices.get(c+3)).x, vertices.get(indices.get(c+3)).y, vertices.get(indices.get(c+3)).z); 
        vertex(vertices.get(indices.get(c + 1)).x, vertices.get(indices.get(c + 1)).y, vertices.get(indices.get(c + 1)).z); 
        vertex(vertices.get(indices.get(c + 2)).x, vertices.get(indices.get(c + 2)).y, vertices.get(indices.get(c + 2)).z); 
      }
      if (Color.getState()==true && curImage != null)
      {
        fill(colors[indices.get(c)]);
        vertex(vertices.get(indices.get(c)).x, vertices.get(indices.get(c)).y, vertices.get(indices.get(c)).z); 
        fill(colors[indices.get(c+1)]);
        vertex(vertices.get(indices.get(c + 1)).x, vertices.get(indices.get(c + 1)).y, vertices.get(indices.get(c + 1)).z); 
        fill(colors[indices.get(c+2)]);
        vertex(vertices.get(indices.get(c + 2)).x, vertices.get(indices.get(c + 2)).y, vertices.get(indices.get(c + 2)).z);

        fill(colors[indices.get(c+3)]);
        vertex(vertices.get(indices.get(c+3)).x, vertices.get(indices.get(c+3)).y, vertices.get(indices.get(c+3)).z);
        fill(colors[indices.get(c+1)]);
        vertex(vertices.get(indices.get(c + 1)).x, vertices.get(indices.get(c + 1)).y, vertices.get(indices.get(c + 1)).z); 
        fill(colors[indices.get(c+2)]);
        vertex(vertices.get(indices.get(c + 2)).x, vertices.get(indices.get(c + 2)).y, vertices.get(indices.get(c + 2)).z);
      }

      endShape();
    }
    popMatrix();
  }
  void createGrid()
  {
    // Determine vertex inices
    
    float min = 0 - (gridSize / 2);
    float max = gridSize / 2;
    float Row = Rows.getValue(), Col = Cols.getValue();
    min = 0 - (gridSize / 2);
    max = gridSize / 2;
    vertices = new ArrayList<PVector>();
    indices = new ArrayList<Integer>();

    strokeWeight(1);
    int row = 0, col = 0;

    for (float i = min; i <= max; i += gridSize / rows)
    {
      col = 0;
      for (float j = min; j <= max; j += gridSize / cols)
      {
        PVector vec = new PVector(i, 0, j);
        vertices.add(vec);

        if (row < (int) rows && col < (int) cols)
        {
          int index = row * ((int)cols + 1) + col;
          indices.add(index);
          indices.add(index+1);
          indices.add(index + (int) cols + 1);
          indices.add(index + (int) cols + 2);
        }
        col++;
      }
      row++;
    }
  }

  void Update()
  {
    // Set Angles and Camera view
    Phi = map((mouseX), 0, width - 1, 0, 360);
    Theta = map((mouseY), 0, height - 1, 1, 179);
    float deltaX=(mouseX- pmouseX) *.15f;
    float deltaY=(mouseY- pmouseY) *.15f;
    Phi+=deltaX;
    Theta += deltaY;
    derX = Radius * cos(radians(Phi)) * sin(radians(Theta));
    derY = Radius * cos(radians(Theta));
    derZ = Radius * sin(radians(Phi)) * sin(radians(Theta));
    xPos = lookX + derX;
    yPos = lookY + derY;
    zPos = lookZ + derZ;
  }
}

void setup()
{
  control = new ControlP5(this);
  background(64, 224, 208);
  size(1200, 800, P3D);

  Rows = control.addSlider(" ")
    .setValue(4)
    .setDecimalPrecision(0)
    .setColorBackground(color(43, 0, 75))
    .setColorForeground(color(72, 171, 0))
    .setPosition(10, 10)
    .setSize(243, 30)
    .setFont(createFont("Arial", 20, true));

  rowsLabel = control.addTextlabel("ROWS")
    .setPosition(265, 12)
    .setText("ROWS")
    .setFont(createFont("Arial", 20, true));

  Cols = control.addSlider("  ")
    .setValue(4)
    .setDecimalPrecision(0)
    .setColorBackground(color(43, 0, 75))
    .setColorForeground(color(72, 171, 0))
    .setPosition(10, 50)
    .setSize(243, 30)
    .setFont(createFont("Arial", 20, true));

  colsLabel = control.addTextlabel("COLUMNS")
    .setPosition(265, 52)
    .setText("COLUMNS")
    .setFont(createFont("Arial", 20, true));

  TerrainSize = control.addSlider("   ")
    .setValue(32)
    .setDecimalPrecision(0)
    .setColorBackground(color(43, 0, 75))
    .setColorForeground(color(72, 171, 0))
    .setPosition(10, 90)
    .setSize(243, 30)
    .setRange(20, 50)
    .setFont(createFont("Arial", 20, true));

  terrainSizeLabel = control.addTextlabel("TERRAIN SIZE")
    .setPosition(265, 92)
    .setText("TERRAIN SIZE")
    .setFont(createFont("Arial", 20, true));

  Generate = control.addButton("GENERATE")
    .setValue(0)
    .setColorBackground(color(43, 0, 75))
    .setColorForeground(color(72, 171, 0))
    .setPosition(10, 165)
    .setSize(175, 45)
    .setFont(createFont("Arial", 20, true));

  FileLoad = control.addTextfield("")
    .setValue("terrain0")
    .setAutoClear(false)
    .setColorBackground(color(43, 0, 75))
    .setColorForeground(color(72, 171, 0))
    .setPosition(10, 220)
    .setSize(400, 45)
    .setFont(createFont("Arial", 20, true));

  fileLoadLabel = control.addTextlabel("LOAD FROM FILE")
    .setPosition(10, 270)
    .setText("LOAD FROM FILE")
    .setFont(createFont("Arial", 20, true));

  Stroke = control.addToggle("      ")
    .setState(true)
    .setColorBackground(color(43, 0, 75))
    .setColorForeground(color(72, 171, 0))
    .setPosition(500, 10)
    .setSize(90, 50)
    .setFont(createFont("Arial", 15, true));

  strokeLabel = control.addTextlabel("STROKE")
    .setPosition(500, 65)
    .setText("STROKE")
    .setFont(createFont("Arial", 20, true));

  Color = control.addToggle("       ")
    .setValue(0)
    .setColorBackground(color(43, 0, 75))
    .setColorForeground(color(72, 171, 0))
    .setPosition(610, 10)
    .setSize(90, 50)
    .setFont(createFont("Arial", 15, true));

  colorLabel = control.addTextlabel("COLOR")
    .setPosition(610, 65)
    .setText("COLOR")
    .setFont(createFont("Arial", 20, true));

  Blend = control.addToggle("        ")
    .setValue(0)
    .setColorBackground(color(43, 0, 75))
    .setColorForeground(color(72, 171, 0))
    .setPosition(720, 10)
    .setSize(90, 50)
    .setFont(createFont("Arial", 15, true));

  blendLabel = control.addTextlabel("BLEND")
    .setPosition(720, 65)
    .setText("BLEND")
    .setFont(createFont("Arial", 20, true));

  HeightMod = control.addSlider("            ")
    .setValue(1)
    .setDecimalPrecision(2)
    .setRange(-5.0, 5.0)
    .setColorBackground(color(43, 0, 75))
    .setColorForeground(color(72, 171, 0))
    .setPosition(500, 120)
    .setSize(300, 30)
    .setFont(createFont("Arial", 20, true));

  heightModLabel = control.addTextlabel("HEIGHT MODIFIER")
    .setPosition(500, 152)
    .setText("HEIGHT MODIFIER")
    .setFont(createFont("Arial", 20, true));

  SnowThresh = control.addSlider("                   ")
    .setValue(0)
    .setDecimalPrecision(2)
    .setColorBackground(color(43, 0, 75))
    .setColorForeground(color(72, 171, 0))
    .setPosition(500, 185)
    .setRange(1.0, 5.0)
    .setSize(300, 30)
    .setFont(createFont("Arial", 20, true));

  snowThreshLabel = control.addTextlabel("SNOW THRESHOLD")
    .setPosition(500, 217)
    .setText("SNOW THRESHOLD")
    .setFont(createFont("Arial", 20, true));

  Smooth = control.addButton("SMOOTH")
    .setValue(0)
    .setColorBackground(color(43, 0, 75))
    .setColorForeground(color(72, 171, 0))
    .setPosition(950, 10)
    .setSize(175, 45)
    .setFont(createFont("Arial", 20, true));
    fileText = FileLoad.getText();
}

void draw()
{
  background(64, 224, 208);
  
  camera
    (
    myCam.xPos, myCam.yPos, myCam.zPos,
    myCam.lookX, myCam.lookY, myCam.lookZ,
    0, 1, 0
    );
  perspective(radians(90.0f), width/(float)height, 0.1, 1000);
  
  if (Generate.isPressed())
  {
    fileText = FileLoad.getText();
    gridSize = TerrainSize.getValue();
    rows = Rows.getValue();
    cols = Cols.getValue();
    smoothCount = 0;
    Smooth.setOff();
    Smooth1 = false;
  }
  
  Smooth.onRelease(new CallbackListener() 
  {
    public void controlEvent(CallbackEvent theEvent) 
    {
      Smooth1 = true;
    }
  });
  myCam.createGrid();
  
  myCam.LaunchGrid();
  perspective();
  camera();
}

void mouseDragged()
{
  // If mouse is over controls, do nothing

  if (control.isMouseOver() == true)
    return;

  // Update camera when dragged
  else
  {
    myCam.Update();
  }
}
