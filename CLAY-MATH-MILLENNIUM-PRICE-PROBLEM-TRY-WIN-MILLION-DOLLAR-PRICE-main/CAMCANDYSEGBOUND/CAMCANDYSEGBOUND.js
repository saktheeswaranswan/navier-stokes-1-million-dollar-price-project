let video;
let gridSize = 8;
let cellSize = 70;
let candies = [];
let selected = null;
let score = 0;
let candyTypes = ["🍭", "🍬", "🍫", "🍩", "🧁", "🍪", "🎂", "🍎", "🧃", "🍉"];
let processedFrame;

function setup() {
  createCanvas(gridSize * cellSize, gridSize * cellSize);
  
  video = createCapture(VIDEO);
  video.size(width, height);
  video.hide();

  initializeBoard();
}

function draw() {
  background(0);
  processVideoFrame();
  drawBoard();
}

function processVideoFrame() {
  video.loadPixels();
  processedFrame = createImage(video.width, video.height);
  processedFrame.loadPixels();
  
  for (let i = 0; i < video.pixels.length; i += 4) {
    let r = video.pixels[i];
    let g = video.pixels[i + 1];
    let b = video.pixels[i + 2];
    let brightness = (r + g + b) / 3;
    
    if (brightness > 200) { // Detect white regions
      processedFrame.pixels[i] = 255;
      processedFrame.pixels[i + 1] = 255;
      processedFrame.pixels[i + 2] = 255;
    } else {
      processedFrame.pixels[i] = 0;
      processedFrame.pixels[i + 1] = 0;
      processedFrame.pixels[i + 2] = 0;
    }
    processedFrame.pixels[i + 3] = 255;
  }
  processedFrame.updatePixels();
  image(processedFrame, 0, 0, width, height);
  
  drawCandyCrushGame();
}

function drawCandyCrushGame() {
  fill(255);
  rect(0, 0, width, height);
  drawBoard();
}

function initializeBoard() {
  for (let i = 0; i < gridSize; i++) {
    candies[i] = [];
    for (let j = 0; j < gridSize; j++) {
      candies[i][j] = randomCandy();
    }
  }
  removeMatches();
}

function drawBoard() {
  for (let i = 0; i < gridSize; i++) {
    for (let j = 0; j < gridSize; j++) {
      drawCandy(i, j, candies[i][j]);
    }
  }
}

function drawCandy(i, j, candy) {
  let x = i * cellSize + cellSize / 2;
  let y = j * cellSize + cellSize / 2;
  let size = cellSize * 0.8;
  fill(0);
  textSize(size / 2);
  textAlign(CENTER, CENTER);
  text(candy, x, y);
}

function randomCandy() {
  return random(candyTypes);
}

function mousePressed() {
  let i = floor(mouseX / cellSize);
  let j = floor(mouseY / cellSize);
  if (i >= 0 && i < gridSize && j >= 0 && j < gridSize) {
    if (selected) {
      if (isAdjacent(selected, { i: i, j: j })) {
        swapCandies(selected, { i: i, j: j });
        if (!removeMatches()) {
          swapCandies(selected, { i: i, j: j }); // Undo if no match
        }
        selected = null;
      } else {
        selected = { i: i, j: j };
      }
    } else {
      selected = { i: i, j: j };
    }
  }
}

function isAdjacent(a, b) {
  return abs(a.i - b.i) + abs(a.j - b.j) === 1;
}

function swapCandies(a, b) {
  let temp = candies[a.i][a.j];
  candies[a.i][a.j] = candies[b.i][b.j];
  candies[b.i][b.j] = temp;
}

function removeMatches() {
  let matches = [];
  for (let i = 0; i < gridSize; i++) {
    for (let j = 0; j < gridSize - 2; j++) {
      if (candies[i][j] === candies[i][j + 1] && candies[i][j] === candies[i][j + 2]) {
        matches.push({ i: i, j: j });
        matches.push({ i: i, j: j + 1 });
        matches.push({ i: i, j: j + 2 });
      }
    }
  }
  for (let j = 0; j < gridSize; j++) {
    for (let i = 0; i < gridSize - 2; i++) {
      if (candies[i][j] === candies[i + 1][j] && candies[i][j] === candies[i + 2][j]) {
        matches.push({ i: i, j: j });
        matches.push({ i: i + 1, j: j });
        matches.push({ i: i + 2, j: j });
      }
    }
  }
  if (matches.length > 0) {
    for (let match of matches) {
      candies[match.i][match.j] = randomCandy();
    }
    removeMatches();
    return true;
  }
  return false;
}
