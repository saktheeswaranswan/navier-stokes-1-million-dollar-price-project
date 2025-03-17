let numCount = 100;  // Number of numbers in the list
let binLength = 10;  // Digits per number
let numbers = [];    // Store random numbers
let diagonal = "";   // Extracted diagonal number
let changedDiagonal = ""; // New missing number
let slider; // Slider for user control

function setup() {
  createCanvas(700, 600);
  generateNumbers();
  
  // Create a slider to control the number of digits shown
  slider = createSlider(1, numCount, 10, 1);
  slider.position(20, 20);
}

function draw() {
  background(20);
  fill(255);
  textSize(16);
  text("Cantor’s Diagonal Argument Visualization", 200, 40);
  
  let step = slider.value(); // Get current step from slider
  text("Step: " + step, 600, 40);
  
  drawNumberList(step);
  drawDiagonal(step);
}

// Generate 100 random decimal numbers in [0,1]
function generateNumbers() {
  numbers = [];
  for (let i = 0; i < numCount; i++) {
    let num = "0.";
    for (let j = 0; j < binLength; j++) {
      num += floor(random(10)); // Random digit (0-9)
    }
    numbers.push(num);
  }
}

// Display numbers on screen up to slider value
function drawNumberList(step) {
  textSize(14);
  for (let i = 0; i < step; i++) {
    fill(255);
    text(numbers[i], 120, 70 + i * 15);
  }
}

// Extract diagonal digits and generate missing number
function drawDiagonal(step) {
  diagonal = "";
  changedDiagonal = "";
  
  for (let i = 0; i < step; i++) {
    let digit = numbers[i][i + 2]; // Extract diagonal digit (skip "0.")
    diagonal += digit;

    // Change the digit (avoid repeating)
    let newDigit = (parseInt(digit) + 1) % 10;
    changedDiagonal += newDigit;
  }

  fill(255, 0, 0);
  textSize(16);
  text("Diagonal Digits: " + diagonal, 120, 70 + step * 15);
  
  fill(0, 255, 0);
  text("New Missing Number: 0." + changedDiagonal + "...", 120, 100 + step * 15);
  
  textSize(14);
  text("This number does NOT exist in the list!", 120, 130 + step * 15);
}

// Regenerate numbers when clicking
function mousePressed() {
  generateNumbers();
}
