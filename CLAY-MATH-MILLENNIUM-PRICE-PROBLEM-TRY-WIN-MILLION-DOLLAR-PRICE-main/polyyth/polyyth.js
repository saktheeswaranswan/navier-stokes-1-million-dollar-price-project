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
