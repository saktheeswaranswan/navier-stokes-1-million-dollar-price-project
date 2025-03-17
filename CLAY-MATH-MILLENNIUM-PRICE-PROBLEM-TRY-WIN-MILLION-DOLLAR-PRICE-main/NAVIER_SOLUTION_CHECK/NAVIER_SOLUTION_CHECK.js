let equations = [];            // Array for arbitrary (generated) solution equations: each element is [variable, equation]
let navierStokesEquations = []; // Array for NS equations (with boundary conditions) in WxMaxima syntax

let numSol = 1000; // We generate one solution equation per variable (u, v, w)

function setup() {
  createCanvas(800, 600);
  textSize(14);
  // Generate the arbitrary solution equations and NS equations
  generateSolutionEquations();
  generateNavierStokesEquations();
}

function draw() {
  background(255);
  fill(0);
  text("Press 'S' to export Generated Equations CSV", 20, 30);
  text("Press 'B' to export NS + Boundary Conditions CSV", 20, 50);
  
  // Display a few arbitrary equations on canvas (for visual check)
  let yPos = 80;
  text("Generated Arbitrary Equations:", 20, yPos);
  yPos += 20;
  for (let i = 0; i < equations.length; i++) {
    text(equations[i][0] + ": " + equations[i][1], 20, yPos + i * 20);
  }
  
  yPos += equations.length * 20 + 20;
  text("Navier-Stokes + Boundary Conditions:", 20, yPos);
  yPos += 20;
  for (let i = 0; i < navierStokesEquations.length; i++) {
    text(navierStokesEquations[i], 20, yPos + i * 20);
  }
}

// ----------------------------------------------------------------
// 1. Generate Arbitrary (Random) Solution Equations for u, v, w
// ----------------------------------------------------------------
function generateRandomEquation(variable) {
  let vars = ["x", "y", "z", "t"];
  let funcs = [
    "sin", "cos", "tan", "sinh", "cosh", "tanh",  // Trigonometric & Hyperbolic
    "exp", "log", "sqrt", "abs",                  // Exponential, Log, Absolute
    "atan", "atan2",                              // Inverse Trigonometry
    "besselj", "bessely",                         // Bessel Functions (J & Y)
    "chebyshev_t", "legendre_p"                   // Chebyshev & Legendre
  ];
  
  let operators = ["+", "-", "*", "/"];
  let equation = variable + "(x,y,z,t) := ";
  let terms = [];
  let usedVars = new Set();

  // For each variable in vars, add one term so that all appear at least once.
  for (let v of vars) {
    let coeff = round(random(1, 50), 2);
    let func = random(funcs);
    let var1 = v;  // force the term to include v
    let var2 = random(vars);
    let operator = random(operators);
    let power = round(random(1, 5));
    let term = `${coeff} * ${func}(${var1}) ${operator} ${round(random(1,20),2)} * ${var2}^${power}`;
    terms.push(term);
    usedVars.add(var1);
    usedVars.add(var2);
  }
  
  // Add extra terms (6 additional) to lengthen the equation.
  for (let i = 0; i < 6; i++) {
    let coeff = round(random(1, 50), 2);
    let func = random(funcs);
    let var1 = random(vars);
    let var2 = random(vars);
    let operator = random(operators);
    let power = round(random(1,5));
    let term = `${coeff} * ${func}(${var1}) ${operator} ${round(random(1,20),2)} * ${var2}^${power}`;
    terms.push(term);
    usedVars.add(var1);
    usedVars.add(var2);
  }
  
  // Ensure every variable appears at least once
  for (let v of vars) {
    if (!usedVars.has(v)) {
      terms.push(`${round(random(1,20),2)} * ${v}^${round(random(2,5))}`);
    }
  }
  
  // Shuffle the terms so they appear in jumbled order.
  shuffle(terms, true);
  
  equation += terms.join(" + ") + ";";
  return equation;
}

function generateSolutionEquations() {
  equations = [];
  equations.push(["u", generateRandomEquation("u")]);
  equations.push(["v", generateRandomEquation("v")]);
  equations.push(["w", generateRandomEquation("w")]);
}

// ----------------------------------------------------------------
// 2. Define Navier–Stokes Equations with Boundary Conditions (WxMaxima syntax)
// ----------------------------------------------------------------
function generateNavierStokesEquations() {
  navierStokesEquations = [
    "/* Continuity Equation */",
    "diff(u, x) + diff(v, y) + diff(w, z) = 0;",
    
    "/* Momentum Equation - x-direction */",
    "diff(u, t) + u * diff(u, x) + v * diff(u, y) + w * diff(u, z) = - (1/rho) * diff(p, x) + nu * (diff(u, x, 2) + diff(u, y, 2) + diff(u, z, 2));",
    
    "/* Momentum Equation - y-direction */",
    "diff(v, t) + u * diff(v, x) + v * diff(v, y) + w * diff(v, z) = - (1/rho) * diff(p, y) + nu * (diff(v, x, 2) + diff(v, y, 2) + diff(v, z, 2));",
    
    "/* Momentum Equation - z-direction */",
    "diff(w, t) + u * diff(w, x) + v * diff(w, y) + w * diff(w, z) = - (1/rho) * diff(p, z) + nu * (diff(w, x, 2) + diff(w, y, 2) + diff(w, z, 2));",
    
    "/* No-Slip Boundary Condition */",
    "u = 0, v = 0, w = 0;",
    
    "/* Free-Slip Boundary Condition */",
    "n.u = 0, t.diff(u, t) = 0;",
    
    "/* Inlet Boundary Condition */",
    "u(x, y, z) = f(y, z), v = 0, w = 0;",
    
    "/* Uniform Inlet */",
    "u = U0;",
    
    "/* Parabolic Inlet (Poiseuille Flow) */",
    "u = Umax * (1 - (r^2 / R^2));",
    
    "/* Outlet Boundary Condition */",
    "diff(u, x) = 0, diff(v, x) = 0, diff(w, x) = 0, p = p_outlet;",
    
    "/* Periodic Boundary Condition */",
    "u(x+L, y, z) = u(x, y, z);"
  ];
}

// ----------------------------------------------------------------
// 3. CSV Export Functions
//    a. Export the arbitrary generated solution equations
//    b. Export the NS equations with boundary conditions
// ----------------------------------------------------------------
function exportSolutionsToCSV() {
  let csvContent = "Function,Arbitrary Equation\n";
  for (let eq of equations) {
    csvContent += eq[0] + ",\"" + eq[1].replace(/"/g, '""') + "\"\n";
  }
  
  let blob = new Blob([csvContent], { type: "text/csv" });
  let a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = "generated_equations.csv";
  a.click();
}

function exportNSBoundaryToCSV() {
  let csvContent = "Equation Type,WxMaxima Syntax\n";
  // Process each NS equation.
  for (let i = 0; i < navierStokesEquations.length; i++) {
    let line = "";
    if (navierStokesEquations[i].startsWith("/*")) {
      // Remove comment delimiters for CSV readability.
      line = navierStokesEquations[i].replace("/*", "").replace("*/", "").trim();
      csvContent += line + ",\"\"\n";
    } else {
      // Otherwise, mark it as an "Equation"
      csvContent += "Equation," + "\"" + navierStokesEquations[i].replace(/"/g, '""') + "\"\n";
    }
  }
  
  let blob = new Blob([csvContent], { type: "text/csv" });
  let a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = "navier_stokes_boundary_conditions.csv";
  a.click();
}

// ----------------------------------------------------------------
// 4. Key Press Handling
//    Press "S" to export the arbitrary generated solution equations CSV.
//    Press "B" to export the NS equations with boundary conditions CSV.
// ----------------------------------------------------------------
function keyPressed() {
  if (key === "S") {
    exportSolutionsToCSV();
  } else if (key === "B") {
    exportNSBoundaryToCSV();
  }
}
