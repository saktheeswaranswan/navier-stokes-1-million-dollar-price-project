let equations = [];
let numEquations = 10000; // Number of equations to generate

function setup() {
  createCanvas(800, 600);
  textSize(14);
  generateEquations();
}

function draw() {
  background(255);
  fill(0);
  text("Generated Large Engineering Equations:", 20, 30);
  for (let i = 0; i < equations.length; i++) {
    text(equations[i], 20, 50 + i * 20);
  }
}

// Function to generate a large equation ensuring all variables exist
function generateRandomEquation(variable) {
  let vars = ["x", "y", "z", "t"];
  let funcs = [
    "sin", "cos", "tan", "sinh", "cosh", "tanh",  // Trigonometric & Hyperbolic
    "exp", "log", "sqrt", "abs",                 // Exponential, Log, Absolute
    "atan", "atan2",                             // Inverse Trigonometry
    "besselj", "bessely",                        // Bessel Functions (J & Y)
    "chebyshev_t", "legendre_p"                  // Chebyshev & Legendre
  ];
  
  let operators = ["+", "-", "*", "/"];
  let equation = variable + "(x,y,z,t) := ";

  let terms = [];
  let usedVars = new Set();

  // Ensure all variables x, y, z, t appear in equation
  for (let v of vars) {
    let coeff = round(random(1, 50), 2);
    let func = random(funcs);
    let var1 = v;
    let var2 = random(vars);
    let operator = random(operators);
    let term = `${coeff} * ${func}(${var1}) ${operator} ${round(random(1, 20), 2)} * ${var2}^${round(random(1, 5))}`;
    terms.push(term);
    usedVars.add(var1);
    usedVars.add(var2);
  }

  // Add extra terms to make the equation long
  for (let i = 0; i < 6; i++) {
    let coeff = round(random(1, 50), 2);
    let func = random(funcs);
    let var1 = random(vars);
    let var2 = random(vars);
    let operator = random(operators);
    let term = `${coeff} * ${func}(${var1}) ${operator} ${round(random(1, 20), 2)} * ${var2}^${round(random(1, 5))}`;
    terms.push(term);
    usedVars.add(var1);
    usedVars.add(var2);
  }

  // Shuffle terms for a jumbled order
  shuffle(terms, true);

  // Verify all variables are included, otherwise add missing ones
  for (let v of vars) {
    if (!usedVars.has(v)) {
      terms.push(`${round(random(1, 20), 2)} * ${v}^${round(random(2, 5))}`);
    }
  }

  // Construct the equation
  equation += terms.join(" + ") + ";";
  return equation;
}

// Function to generate multiple equations
function generateEquations() {
  equations = [];
  for (let i = 0; i < numEquations / 3; i++) {
    equations.push(["u", generateRandomEquation("u")]);
    equations.push(["v", generateRandomEquation("v")]);
    equations.push(["w", generateRandomEquation("w")]);
  }
}

// Function to export equations to a CSV file
function exportEquationsToCSV() {
  let csvContent = "Function,Equation\n";

  for (let eq of equations) {
    csvContent += eq[0] + "," + eq[1] + "\n";
  }

  let blob = new Blob([csvContent], { type: "text/csv" });
  let a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = "large_navier_stokes_equations.csv";
  a.click();
}

// Press "E" to export equations
function keyPressed() {
  if (key === "E") {
    exportEquationsToCSV();
  }
}
