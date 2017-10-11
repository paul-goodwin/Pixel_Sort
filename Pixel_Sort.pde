// Pixel Sort
// Paul Goodwin

// Keys:
// 's' to save
// 'c' to clear the rendered image
// SPACE to toggle between rendered image and underlying edge mask
// Hold UP and CLICK to start sort from mouse position and move up (to do)
// Hold DOWN and CLICK to start sort from mouse position and move down
// Hold LEFT and CLICK to start sort from mouse position and move left (to do)
// Hold RIGHT and CLICK to start sort from mouse position and move right

//Requires openCV for Processing. Import the library through processing. 
import gab.opencv.*;
OpenCV opencv;

// set how many edges the sort will to pass over
int decay = 1;

// Initialize the image object, and a the coresponding mask
PImage img;
PImage mask;

// Load image from a folder. Image path is relative to sketch directory
//String imgFileName = "7";

// Load image from a web server
String url = "https://d1o50x50snmhul.cloudfront.net/wp-content/uploads/2017/01/03164223/rexfeatures_7455108a-800x533.jpg";
String fileType = "jpg";

int loops = 1;

// mask threshold values to determine sorting start and end pixels
int whiteValue = -13000000;

int row = 0;
int column = 0;

boolean showMask = false;

void setup() {
  // Load image from a folder
  //img = loadImage(imgFileName+"."+fileType);
  //mask = loadImage(imgFileName+"."+fileType);

  // Load image from a web server
  img = loadImage(url, fileType);
  mask = loadImage(url, fileType);

  // Initialize the mask
  opencv = new OpenCV(this, mask);
  opencv.findSobelEdges(1, 0);
  mask = opencv.getSnapshot();

  // use only numbers (not variables) for the size() command, Processing 3
  size(1, 1);

  // allow resize and update surface to image dimensions
  surface.setResizable(true);
  surface.setSize(img.width, img.height);

  // load image onto surface - scale to the available width,height for display
  image(img, 0, 0, width, height);
}


void draw() {
  // Check the sorting direction
  if (key == CODED) {
    // Sort rows to the right of the mouse
    if (keyCode == RIGHT) { 
      if (mousePressed == true && row != mouseY) {
        row = mouseY;
        println("Sorting Row " + row);
        mask.loadPixels(); 
        sortRowRight();
        row++;
        img.updatePixels();
      }
    }

    // Sort columns below the mouse
    if (keyCode == DOWN) { 
      if (mousePressed == true && column != mouseX) {
        column = mouseX;
        println("Sorting Col " + column);
        mask.loadPixels(); 
        sortColumnDown();
        img.updatePixels();
        //redraw();
      }
    }

    // Sort columns above the mouse
    if (keyCode == UP) { 
      if (mousePressed == true && column != mouseX) {
        column = mouseX;
        println("Sorting Col " + column);
        mask.loadPixels(); 
        sortColumnUP();
        img.updatePixels();
        //redraw();
      }
    }

    // Sort columns left the mouse
    if (keyCode == LEFT) { 
      if (mousePressed == true && row != mouseY) {
        row = mouseY;
        println("Sorting Row " + row);
        mask.loadPixels(); 
        sortRowLeft();
        row++;
        img.updatePixels();
      }
    }
  }

  // render underlying mask or the rendered image
  if (showMask == false) {
    image(img, 0, 0, width, height);
  } else if (showMask == true) {
    image(mask, 0, 0, width, height);
  }
}

void keyPressed() {
  // Save the image to the dir
  if ((key == 'S') || (key == 's')) {
    //img.save(imgFileName+"_"+mode+".png");
    img.save("test"+frameCount+"_"+decay+".png");

    println("Saved "+frameCount+" Frame(s)");
  }

  // Clear the screen of any sorts
  if ((key == 'C') || (key == 'c')) {
    setup();
  }

  // Toggle between the mask and the rendered image
  if ((key == ' ') || (key == ' ')) {
    showMask = !showMask;
    println("Show mask: "+showMask);
  }
}


void sortRowRight() {
  // current row
  int y = row;

  // where to start sorting
  int x = mouseX;

  // where to stop sorting
  int xend = 0;

  while (xend < img.width-1) {
    x = getFirstNotWhiteX(x, y);
    xend = getNextWhiteX(x, y);


    if (x < 0) break;

    int sortLength = xend-x;

    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];

    for (int i=0; i<sortLength; i++) {
      unsorted[i] = img.pixels[x + i + y * img.width];
    }

    sorted = sort(unsorted);

    for (int i=0; i<sortLength; i++) {
      img.pixels[x + i + y * img.width] = sorted[i];
    }

    x = xend+1;
  }
}


void sortColumnDown() {
  // current column
  int x = column;

  // where to start sorting
  int y = mouseY;

  // where to stop sorting
  int yend = 0;

  while (yend < img.height-1) {
    y = getFirstNotWhiteY(x, y);
    yend = getNextWhiteY(x, y);

    if (y < 0) break;

    int sortLength = yend-y;

    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];

    for (int i=0; i<sortLength; i++) {
      unsorted[i] = img.pixels[x + (y+i) * img.width];
    }

    sorted = sort(unsorted);

    for (int i=0; i<sortLength; i++) {
      img.pixels[x + (y+i) * img.width] = sorted[i];
    }

    y = yend+1;
  }
}

void sortRowLeft() {
  // current row
  int y = row;

  // where to start sorting
  int x = mouseX;

  // where to stop sorting
  int xend = 0;

  while (xend < img.width-1) {
    x = getFirstNotWhiteX(x, y);
    xend = getNextWhiteX(x, y);


    if (x < 0) break;

    int sortLength = xend-x;

    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];

    for (int i=0; i<sortLength; i++) {
      unsorted[i] = img.pixels[x + i + y * img.width];
    }

    sorted = sort(unsorted);

    for (int i=0; i<sortLength; i++) {
      img.pixels[x + i + y * img.width] = sorted[i];
    }

    x = xend+1;
  }
}

void sortColumnUP() {
  // current column
  int x = column;

  // where to start sorting
  int y = mouseY;

  // where to stop sorting
  int yend = 0;

  while (yend < img.height-1) {
    y = getFirstNotWhiteY(x, y);
    yend = getNextWhiteY(x, y);

    if (y < 0) break;

    int sortLength = yend-y;

    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];

    for (int i=0; i<sortLength; i++) {
      unsorted[i] = img.pixels[x + (y+i) * img.width];
    }

    sorted = sort(unsorted);

    for (int i=0; i<sortLength; i++) {
      img.pixels[x + (y+i) * img.width] = sorted[i];
    }

    y = yend+1;
  }
}

// white x
int getFirstNotWhiteX(int x, int y) {

  while(mask.pixels[x + y * mask.width] > whiteValue) {
    x++;
    if(x >= mask.width) 
      return -1;
  }
  return x;
}

int getNextWhiteX(int x, int y) {
  x++;

  while(mask.pixels[x + y * mask.width] < whiteValue) {
    x++;
    if(x >= mask.width) 
      return mask.width-1;
  }
  return x-1;
}

int getFirstNotWhiteY(int x, int y) {

  if(y < mask.height) {
    while(mask.pixels[x + y * mask.width] > whiteValue) {
      y++;
      if(y >= mask.height)
        return -1;
    }
  }
  
  return y;
}

int getNextWhiteY(int x, int y) {
  y++;
  
  if(y < mask.height) {
    while(mask.pixels[x + y * mask.width] < whiteValue) {
      y++;
      if(y >= mask.height) 
        return mask.height-1;
    }
  }
  
  return y-1;
}