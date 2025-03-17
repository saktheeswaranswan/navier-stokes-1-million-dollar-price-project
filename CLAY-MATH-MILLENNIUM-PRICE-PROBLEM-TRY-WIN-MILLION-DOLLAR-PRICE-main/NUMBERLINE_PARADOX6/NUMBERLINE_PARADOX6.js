let numCount = 1000;  // Total numbers in the list
let binLength = 1000;  // Number of digits per number
let numbers = [];    // Store random numbers
let diagonal = "";   // Extracted diagonal number
let changedDiagonal = ""; // The missing number
let slider; // Slider for step control
let missingGaps = []; // Numbers that "cannot exist" in the sequence

function setup() {
  createCanvas(700, 600);
  generateNumbers();
  
  // Create a slider to control steps
  slider = createSlider(1, numCount, 10, 1);
  slider.position(20, 20);
  
  // Create export button
  let exportBtn = createButton('Export to CSV');
  exportBtn.position(20, 50);
  exportBtn.mousePressed(exportCSV);
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

// Display numbers up to the slider value
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
  missingGaps = [];

  for (let i = 0; i < step; i++) {
    let digit = numbers[i][i + 2]; // Extract diagonal digit (skip "0.")
    diagonal += digit;

    // Change the digit (ensure uniqueness)
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
  
  // Find numbers that "cannot exist" between listed numbers
  findImpossibleNumbers(step);
}

// Identify gaps where missing numbers would not fit
function findImpossibleNumbers(step) {
  missingGaps = [];
  for (let i = 1; i < step; i++) {
    let midValue = (parseFloat(numbers[i - 1]) + parseFloat(numbers[i])) / 2;
    missingGaps.push(midValue.toFixed(binLength));
  }
}

// Export data to CSV
function exportCSV() {
  let csvContent = "data:text/csv;charset=utf-8,Index,Original Numbers,Diagonal Digit,New Missing Number,Impossible Midpoint\n";

  for (let i = 0; i < slider.value(); i++) {
    let digit = numbers[i][i + 2] || "";
    let missingNum = i < changedDiagonal.length ? changedDiagonal[i] : "";
    let gap = i < missingGaps.length ? missingGaps[i] : "";
    csvContent += `${i},${numbers[i]},${digit},${missingNum},${gap}\n`;
  }

  let encodedUri = encodeURI(csvContent);
  let link = document.createElement("a");
  link.setAttribute("href", encodedUri);
  link.setAttribute("download", "cantor_diagonal.csv");
  document.body.appendChild(link);
  link.click();
}
