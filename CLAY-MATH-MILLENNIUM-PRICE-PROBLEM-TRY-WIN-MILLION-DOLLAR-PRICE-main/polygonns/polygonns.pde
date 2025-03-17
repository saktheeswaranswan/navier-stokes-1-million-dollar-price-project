let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);
  }
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}



centre csv export 



let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Center X,Initial Center Y,Initial Area,Final Center X,Final Center Y,Final Area\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];

    csvContent += `Polygon ${i + 1},${initialCenter.x},${initialCenter.y},${initialArea},${finalCenter.x},${finalCenter.y},${finalArea}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}






let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Center X,Initial Center Y,Initial Area,Final Center X,Final Center Y,Final Area\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];

    csvContent += `Polygon ${i + 1},${initialCenter.x},${initialCenter.y},${initialArea},${finalCenter.x},${finalCenter.y},${finalArea}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}















let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Center X,Initial Center Y,Initial Area,Final Center X,Final Center Y,Final Area\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];

    csvContent += `Polygon ${i + 1},${initialCenter.x},${initialCenter.y},${initialArea},${finalCenter.x},${finalCenter.y},${finalArea}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}












let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Center X,Initial Center Y,Initial Area,Final Center X,Final Center Y,Final Area\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];

    csvContent += `Polygon ${i + 1},${initialCenter.x},${initialCenter.y},${initialArea},${finalCenter.x},${finalCenter.y},${finalArea}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}











let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Center X,Initial Center Y,Initial Area,Final Center X,Final Center Y,Final Area\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];

    csvContent += `Polygon ${i + 1},${initialCenter.x},${initialCenter.y},${initialArea},${finalCenter.x},${finalCenter.y},${finalArea}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}







let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Center X,Initial Center Y,Initial Area,Final Center X,Final Center Y,Final Area\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];

    csvContent += `Polygon ${i + 1},${initialCenter.x},${initialCenter.y},${initialArea},${finalCenter.x},${finalCenter.y},${finalArea}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}






let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Center X,Initial Center Y,Initial Area,Final Center X,Final Center Y,Final Area\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];

    csvContent += `Polygon ${i + 1},${initialCenter.x},${initialCenter.y},${initialArea},${finalCenter.x},${finalCenter.y},${finalArea}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}












let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Center X,Initial Center Y,Initial Area,Final Center X,Final Center Y,Final Area\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];

    csvContent += `Polygon ${i + 1},${initialCenter.x},${initialCenter.y},${initialArea},${finalCenter.x},${finalCenter.y},${finalArea}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}




















let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Center X,Initial Center Y,Initial Area,Final Center X,Final Center Y,Final Area\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];

    csvContent += `Polygon ${i + 1},${initialCenter.x},${initialCenter.y},${initialArea},${finalCenter.x},${finalCenter.y},${finalArea}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}











let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Center X,Initial Center Y,Initial Area,Final Center X,Final Center Y,Final Area\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];

    csvContent += `Polygon ${i + 1},${initialCenter.x},${initialCenter.y},${initialArea},${finalCenter.x},${finalCenter.y},${finalArea}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}











let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}


















let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}




















let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}











let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}






















let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}




















let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}






without scale factor but correct code 


let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}





let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}



let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}






let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}





let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}







let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}





let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}






let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}





let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}






let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}





let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}





let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}


















let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}







let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}








let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}






let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}




wrong scaling and moving



let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y,Final Scale Factor\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;
    let finalScale = scaleSliders[i].value();

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid},${finalScale.toFixed(2)}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}





v




v





let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y,Final Scale Factor\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;
    let finalScale = scaleSliders[i].value();

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid},${finalScale.toFixed(2)}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}






let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y,Final Scale Factor\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;
    let finalScale = scaleSliders[i].value();

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid},${finalScale.toFixed(2)}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}








let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y,Final Scale Factor\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;
    let finalScale = scaleSliders[i].value();

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid},${finalScale.toFixed(2)}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}








v








let polygonVertices = [];
let polygonCenters = [];
let polygonAreas = [];
let initialPolygonCenters = [];
let initialPolygonAreas = [];
let initialPolygonVertices = [];
let initialSides = [];
let initialScaleFactors = [];
let isDragging = false;
let draggedPolygon = -1;
let draggedVertex = -1;
let originalCentroid = null;

let sidesSliders = [];
let scaleSliders = [];
let polygonCount = 10;

function setup() {
  createCanvas(1000, 800);

  // Initialize sliders for each polygon
  for (let i = 0; i < polygonCount; i++) {
    sidesSliders[i] = createSlider(3, 100, 6, 1);
    scaleSliders[i] = createSlider(0.5, 2, 1, 0.01);

    // Position sliders for each polygon on the canvas
    createDiv(`Polygon ${i + 1} Sides:`).position(20, 30 + i * 60);
    sidesSliders[i].position(150, 30 + i * 60);

    createDiv(`Polygon ${i + 1} Scale:`).position(20, 60 + i * 60);
    scaleSliders[i].position(150, 60 + i * 60);

    // Update polygons when sliders are changed
    sidesSliders[i].input(() => updatePolygon(i));
    scaleSliders[i].input(() => updatePolygon(i));

    // Initialize each polygon
    polygonVertices[i] = generatePolygonVertices(sidesSliders[i].value(), scaleSliders[i].value());
    polygonCenters[i] = getCentroid(polygonVertices[i]);
    polygonAreas[i] = calculateArea(polygonVertices[i]);

    // Save initial states
    initialPolygonCenters[i] = polygonCenters[i].copy();
    initialPolygonAreas[i] = polygonAreas[i];
    initialPolygonVertices[i] = polygonVertices[i].map(v => createVector(v.x, v.y)); // Copy initial vertices
    initialSides[i] = sidesSliders[i].value();
    initialScaleFactors[i] = scaleSliders[i].value();
  }

  // Create a button to export the data to CSV
  let exportButton = createButton('Export CSV');
  exportButton.position(20, polygonCount * 60 + 30);
  exportButton.mousePressed(exportCSV);
}

function draw() {
  background(255);

  // Draw all polygons and their areas
  for (let i = 0; i < polygonCount; i++) {
    let fillColor = color(random(255), random(255), random(255), 150); // Random colors for polygons
    drawPolygon(polygonVertices[i], fillColor, `Polygon ${i + 1}`);
    displayArea(polygonVertices[i], `Area: ${polygonAreas[i]}`, polygonCenters[i]);
  }
}

function drawPolygon(vertices, fillColor, label) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  // Draw black corner points
  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);  // Draw corner points
  }

  // Draw label near the polygon
  textSize(16);
  textAlign(CENTER, CENTER);
  fill(0);
  let centroid = getCentroid(vertices);
  text(label, centroid.x, centroid.y - 20);

  // Draw red centroid (larger than corner points)
  fill(255, 0, 0);
  ellipse(centroid.x, centroid.y, 20, 20);  // Larger red centroid
}

function displayArea(vertices, label, centroid) {
  textSize(14);
  textAlign(CENTER, CENTER);
  fill(0);
  text(label, centroid.x, centroid.y + 20); // Display area below the centroid
}

function updatePolygon(index) {
  // Update the vertices, centroid, and area for the specified polygon
  polygonVertices[index] = generatePolygonVertices(sidesSliders[index].value(), scaleSliders[index].value());
  polygonCenters[index] = getCentroid(polygonVertices[index]);
  polygonAreas[index] = calculateArea(polygonVertices[index]);
}

function generatePolygonVertices(numSides, scaleFactor) {
  let vertices = [];
  let radius = 300 / 2 * scaleFactor;
  let centerX = random(100, width - 100);
  let centerY = random(100, height - 100);
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(centerX + radius * cos(angle), centerY + radius * sin(angle)));
  }
  return vertices;
}

function getCentroid(vertices) {
  let x = 0, y = 0;
  for (let v of vertices) {
    x += v.x;
    y += v.y;
  }
  return createVector(x / vertices.length, y / vertices.length);
}

function calculateArea(vertices) {
  let area = 0;
  let n = vertices.length;
  for (let i = 0; i < n; i++) {
    let j = (i + 1) % n;
    area += vertices[i].x * vertices[j].y;
    area -= vertices[i].y * vertices[j].x;
  }
  return abs(area) / 2;
}

function mousePressed() {
  // Check if we clicked on any centroid to start dragging
  for (let i = 0; i < polygonCount; i++) {
    let centroid = polygonCenters[i];
    let d = dist(mouseX, mouseY, centroid.x, centroid.y);
    if (d < 20) {  // Larger click area for the centroid
      isDragging = true;
      draggedPolygon = i;
      originalCentroid = centroid.copy();  // Store the original centroid position
      break;
    }
    // Check if we clicked on any corner vertex
    for (let j = 0; j < polygonVertices[i].length; j++) {
      let v = polygonVertices[i][j];
      let d = dist(mouseX, mouseY, v.x, v.y);
      if (d < 10) {  // Clicked on a corner point
        isDragging = true;
        draggedPolygon = i;
        draggedVertex = j;
        break;
      }
    }
  }
}

function mouseDragged() {
  if (isDragging && draggedPolygon >= 0) {
    if (draggedVertex >= 0) {
      // Move the dragged vertex
      polygonVertices[draggedPolygon][draggedVertex].x = mouseX;
      polygonVertices[draggedPolygon][draggedVertex].y = mouseY;
    } else {
      // Move the dragged polygon based on the difference in centroid position
      let deltaX = mouseX - originalCentroid.x;
      let deltaY = mouseY - originalCentroid.y;
      
      // Update each vertex position to move the polygon
      polygonVertices[draggedPolygon].forEach(v => {
        v.x += deltaX;
        v.y += deltaY;
      });

      // Update the centroid and area after dragging
      polygonCenters[draggedPolygon] = getCentroid(polygonVertices[draggedPolygon]);
      polygonAreas[draggedPolygon] = calculateArea(polygonVertices[draggedPolygon]);
      
      // Update the original centroid for the next movement
      originalCentroid = polygonCenters[draggedPolygon].copy();
    }
  }
}

function mouseReleased() {
  isDragging = false;
  draggedPolygon = -1;
  draggedVertex = -1;
  originalCentroid = null;
}

function exportCSV() {
  let csvContent = "Polygon,Initial Sides,Initial Scale Factor,Initial Center X,Initial Center Y,Initial Area,Initial Corners,Final Center X,Final Center Y,Final Area,Final Corners,Final Red Centroid X,Final Red Centroid Y,Final Scale Factor\n";

  for (let i = 0; i < polygonCount; i++) {
    let initialCenter = initialPolygonCenters[i];
    let finalCenter = polygonCenters[i];
    let initialArea = initialPolygonAreas[i];
    let finalArea = polygonAreas[i];
    let initialSidesCount = initialSides[i];
    let initialScale = initialScaleFactors[i];
    
    let initialCorners = initialPolygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    let finalCorners = polygonVertices[i].map(v => `(${v.x.toFixed(2)}, ${v.y.toFixed(2)})`).join(" | ");
    
    let redCentroid = `(${finalCenter.x.toFixed(2)}, ${finalCenter.y.toFixed(2)})`;
    let finalScale = scaleSliders[i].value();

    csvContent += `Polygon ${i + 1},${initialSidesCount},${initialScale},${initialCenter.x.toFixed(2)},${initialCenter.y.toFixed(2)},${initialArea.toFixed(2)},${initialCorners},${finalCenter.x.toFixed(2)},${finalCenter.y.toFixed(2)},${finalArea.toFixed(2)},${finalCorners},${redCentroid},${finalScale.toFixed(2)}\n`;
  }

  // Create a download link and simulate a click to download the CSV
  let hiddenElement = createA('data:text/csv;charset=utf-8,' + encodeURIComponent(csvContent), 'Download CSV');
  hiddenElement.attribute('download', 'polygon_data.csv');
  hiddenElement.elt.click();
}




let innerPolygonVertices = [];
let outerPolygonVertices = [];
let middlePolygonVertices = [];
let previousInnerPolygonVertices = [];
let previousOuterPolygonVertices = [];
let previousMiddlePolygonVertices = [];
let draggingInnerVertex = -1;
let draggingOuterVertex = -1;
let draggingMiddleVertex = -1;
let innerSidesSlider, outerSidesSlider, middleSidesSlider;
let innerScaleSlider, outerScaleSlider, middleScaleSlider;
let innerPolygonAreaBefore = 0, innerPolygonAreaAfter = 0;
let outerPolygonAreaBefore = 0, outerPolygonAreaAfter = 0;
let middlePolygonAreaBefore = 0, middlePolygonAreaAfter = 0;
let polygonDiameter = 300;
let polygonCenter;

function setup() {
  createCanvas(1000, 800);

  // Sliders for controlling the number of sides
  createDiv("Inner Polygon Sides:").position(20, height - 210);
  innerSidesSlider = createSlider(3, 100, 6, 1);
  innerSidesSlider.position(150, height - 210);
  innerSidesSlider.input(updateInnerPolygon);

  createDiv("Middle Polygon Sides:").position(20, height - 180);
  middleSidesSlider = createSlider(3, 100, 6, 1);
  middleSidesSlider.position(150, height - 180);
  middleSidesSlider.input(updateMiddlePolygon);

  createDiv("Outer Polygon Sides:").position(20, height - 150);
  outerSidesSlider = createSlider(3, 100, 6, 1);
  outerSidesSlider.position(150, height - 150);
  outerSidesSlider.input(updateOuterPolygon);

  // Sliders for scaling
  createDiv("Inner Scale Factor:").position(20, height - 120);
  innerScaleSlider = createSlider(0.5, 2, 1, 0.01);
  innerScaleSlider.position(150, height - 120);
  innerScaleSlider.input(scaleInnerPolygon);

  createDiv("Middle Scale Factor:").position(20, height - 90);
  middleScaleSlider = createSlider(0.5, 2, 1, 0.01);
  middleScaleSlider.position(150, height - 90);
  middleScaleSlider.input(scaleMiddlePolygon);

  createDiv("Outer Scale Factor:").position(20, height - 60);
  outerScaleSlider = createSlider(0.5, 2, 1, 0.01);
  outerScaleSlider.position(150, height - 60);
  outerScaleSlider.input(scaleOuterPolygon);

  // Buttons to save CSV
  let saveInnerButton = createButton("Save Inner CSV");
  saveInnerButton.position(400, height - 120);
  saveInnerButton.mousePressed(saveInnerCSV);

  let saveMiddleButton = createButton("Save Middle CSV");
  saveMiddleButton.position(400, height - 90);
  saveMiddleButton.mousePressed(saveMiddleCSV);

  let saveOuterButton = createButton("Save Outer CSV");
  saveOuterButton.position(400, height - 60);
  saveOuterButton.mousePressed(saveOuterCSV);

  polygonCenter = createVector(width / 2, height / 2);
  updateInnerPolygon();
  updateMiddlePolygon();
  updateOuterPolygon();
}

function draw() {
  background(255);

  drawPolygon(innerPolygonVertices, color(0, 0, 255, 150));
  drawPolygon(middlePolygonVertices, color(0, 255, 0, 150));
  drawPolygon(outerPolygonVertices, color(255, 0, 0, 150));

  displayInfo();
  displayCoordinateTable();
}

function drawPolygon(vertices, fillColor) {
  fill(fillColor);
  stroke(0);
  beginShape();
  for (let v of vertices) {
    vertex(v.x, v.y);
  }
  endShape(CLOSE);

  fill(0);
  noStroke();
  for (let v of vertices) {
    ellipse(v.x, v.y, 10, 10);
  }
}

function displayInfo() {
  fill(0);
  textSize(16);
  text(`Inner Polygon Area (Before): ${innerPolygonAreaBefore.toFixed(2)} units²`, 20, height - 270);
  text(`Inner Polygon Area (After): ${innerPolygonAreaAfter.toFixed(2)} units²`, 20, height - 250);
  text(`Middle Polygon Area (Before): ${middlePolygonAreaBefore.toFixed(2)} units²`, 20, height - 230);
  text(`Middle Polygon Area (After): ${middlePolygonAreaAfter.toFixed(2)} units²`, 20, height - 210);
  text(`Outer Polygon Area (Before): ${outerPolygonAreaBefore.toFixed(2)} units²`, 20, height - 190);
  text(`Outer Polygon Area (After): ${outerPolygonAreaAfter.toFixed(2)} units²`, 20, height - 170);
}

function updateInnerPolygon() {
  innerPolygonVertices = generatePolygonVertices(innerSidesSlider.value());
  previousInnerPolygonVertices = [...innerPolygonVertices];
  calculateInnerPolygonAreas();
}

function updateMiddlePolygon() {
  middlePolygonVertices = generatePolygonVertices(middleSidesSlider.value());
  previousMiddlePolygonVertices = [...middlePolygonVertices];
  calculateMiddlePolygonAreas();
}

function updateOuterPolygon() {
  outerPolygonVertices = generatePolygonVertices(outerSidesSlider.value());
  previousOuterPolygonVertices = [...outerPolygonVertices];
  calculateOuterPolygonAreas();
}

function generatePolygonVertices(numSides) {
  let vertices = [];
  let radius = polygonDiameter / 2;
  for (let i = 0; i < numSides; i++) {
    let angle = map(i, 0, numSides, 0, TWO_PI);
    vertices.push(createVector(polygonCenter.x + radius * cos(angle), polygonCenter.y + radius * sin(angle)));
  }
  return vertices;
}

function calculateInnerPolygonAreas() {
  innerPolygonAreaBefore = calculateArea(previousInnerPolygonVertices);
  innerPolygonAreaAfter = calculateArea(innerPolygonVertices);
}

function calculateMiddlePolygonAreas() {
  middlePolygonAreaBefore = calculateArea(previousMiddlePolygonVertices);
  middlePolygonAreaAfter = calculateArea(middlePolygonVertices);
}

function calculateOuterPolygonAreas() {
  outerPolygonAreaBefore = calculateArea(previousOuterPolygonVertices);
  outerPolygonAreaAfter = calculateArea(outerPolygonVertices);
}

function calculateArea(vertices) {
  let area = 0;
  for (let i = 0; i < vertices.length; i++) {
    let next = vertices[(i + 1) % vertices.length];
    area += vertices[i].x * next.y - vertices[i].y * next.x;
  }
  return abs(area) / 2;
}

function scaleInnerPolygon() {
  scalePolygon(innerPolygonVertices, previousInnerPolygonVertices, innerScaleSlider.value());
  calculateInnerPolygonAreas();
}

function scaleMiddlePolygon() {
  scalePolygon(middlePolygonVertices, previousMiddlePolygonVertices, middleScaleSlider.value());
  calculateMiddlePolygonAreas();
}

function scaleOuterPolygon() {
  scalePolygon(outerPolygonVertices, previousOuterPolygonVertices, outerScaleSlider.value());
  calculateOuterPolygonAreas();
}

function scalePolygon(vertices, previousVertices, scaleFactor) {
  for (let i = 0; i < vertices.length; i++) {
    vertices[i].x = polygonCenter.x + (previousVertices[i].x - polygonCenter.x) * scaleFactor;
    vertices[i].y = polygonCenter.y + (previousVertices[i].y - polygonCenter.y) * scaleFactor;
  }
}

function saveCSV(polygonName, vertices, previousVertices, fileName) {
  let rows = [["Polygon", "Vertex", "Previous X", "Previous Y", "Current X", "Current Y"]];
  for (let i = 0; i < vertices.length; i++) {
    rows.push([polygonName, `Vertex ${i + 1}`, previousVertices[i].x.toFixed(2), previousVertices[i].y.toFixed(2), vertices[i].x.toFixed(2), vertices[i].y.toFixed(2)]);
  }
  let csvContent = rows.map(row => row.join(",")).join("\n");
  saveStrings([csvContent], fileName);
}

function saveInnerCSV() {
  saveCSV("Inner", innerPolygonVertices, previousInnerPolygonVertices, "inner_polygon_coordinates.csv");
}

function saveMiddleCSV() {
  saveCSV("Middle", middlePolygonVertices, previousMiddlePolygonVertices, "middle_polygon_coordinates.csv");
}

function saveOuterCSV() {
  saveCSV("Outer", outerPolygonVertices, previousOuterPolygonVertices, "outer_polygon_coordinates.csv");
}

function displayCoordinateTable() {
  let xOffset = 600;
  let yOffset = 50;
  textSize(12);
  textAlign(LEFT);
  fill(0);
  text("Polygon | Vertex | Previous X | Previous Y | Current X | Current Y", xOffset, yOffset);
  let rowIndex = 1;

  displayPolygonTable("Inner", innerPolygonVertices, previousInnerPolygonVertices, xOffset, yOffset, rowIndex);
  rowIndex += innerPolygonVertices.length;

  displayPolygonTable("Middle", middlePolygonVertices, previousMiddlePolygonVertices, xOffset, yOffset, rowIndex);
  rowIndex += middlePolygonVertices.length;

  displayPolygonTable("Outer", outerPolygonVertices, previousOuterPolygonVertices, xOffset, yOffset, rowIndex);
}

function displayPolygonTable(name, vertices, previousVertices, xOffset, yOffset, rowIndex) {
  for (let i = 0; i < vertices.length; i++) {
    text(
      `${name}   | V${i + 1}   | ${previousVertices[i].x.toFixed(2)} | ${previousVertices[i].y.toFixed(2)} | ${vertices[i].x.toFixed(2)} | ${vertices[i].y.toFixed(2)}`,
      xOffset,
      yOffset + 20 * rowIndex++
    );
  }
}

function mousePressed() {
  handleMousePressed(innerPolygonVertices, draggingInnerVertex);
  handleMousePressed(middlePolygonVertices, draggingMiddleVertex);
  handleMousePressed(outerPolygonVertices, draggingOuterVertex);
}

function handleMousePressed(vertices, draggingVertex) {
  for (let i = 0; i < vertices.length; i++) {
    if (dist(mouseX, mouseY, vertices[i].x, vertices[i].y) < 10) {
      draggingVertex = i;
      break;
    }
  }
}

function mouseDragged() {
  handleMouseDragged(innerPolygonVertices, draggingInnerVertex, calculateInnerPolygonAreas);
  handleMouseDragged(middlePolygonVertices, draggingMiddleVertex, calculateMiddlePolygonAreas);
  handleMouseDragged(outerPolygonVertices, draggingOuterVertex, calculateOuterPolygonAreas);
}

function handleMouseDragged(vertices, draggingVertex, recalculateAreas) {
  if (draggingVertex !== -1) {
    vertices[draggingVertex].x = mouseX;
    vertices[draggingVertex].y = mouseY;
    recalculateAreas();
  }
}

function mouseReleased() {
  handleMouseReleased(innerPolygonVertices, draggingInnerVertex, previousInnerPolygonVertices);
  handleMouseReleased(middlePolygonVertices, draggingMiddleVertex, previousMiddlePolygonVertices);
  handleMouseReleased(outerPolygonVertices, draggingOuterVertex, previousOuterPolygonVertices);
}

function handleMouseReleased(vertices, draggingVertex, previousVertices) {
  if (draggingVertex !== -1) {
    previousVertices[draggingVertex] = vertices[draggingVertex].copy();
    draggingVertex = -1;
  }
}
