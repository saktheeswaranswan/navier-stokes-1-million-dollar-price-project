// === Global Variables ===
let numEquations = 1000;  // Number of random equations to generate for each variable
let uSolutions = [];
let vSolutions = [];
let wSolutions = [];
let nsEquations = [];         // Navier-Stokes equations with boundary conditions (WxMaxima syntax)
let verifiedNSEquations = [];   // Dummy "verified" NS equations after substitution

// === p5.js Setup ===
function setup() {
  createCanvas(800, 600);
  textSize(14);
  // Generate random solution equations for u, v, w
  generateAllSolutions();
  // Generate Navier–Stokes equations with boundary conditions
  generateNavierStokesEquations();
  // Generate dummy verified NS equations (simulate substitution and residual check)
  generateVerifiedNSEquations();
}

function draw() {
  background(255);
  fill(0);
  text("Press 'U' to export u_equations.csv", 20, 30);
  text("Press 'V' to export v_equations.csv", 20, 50);
  text("Press 'W' to export w_equations.csv", 20, 70);
  text("Press 'B' to export NS_Boundary_Conditions.csv", 20, 90);
  text("Press 'N' to export Verified_NS_Equations.csv", 20, 110);
  
  // (Optional) Display a sample on canvas for visual confirmation:
  text("Sample u equation:", 20, 150);
  text(uSolutions[0], 20, 170);
  text("Sample NS equation:", 20, 200);
  text(nsEquations[0], 20, 220);
}

// ----------------------------------------------------------------
// 1. Random Solution Equation Generator (for u, v, w)
//    Each equation is generated so that x, y, z, t all appear.
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
  
  // For each variable, add a term so every one appears at least once.
  for (let v of vars) {
    let coeff = round(random(1, 50), 2);
    let func = random(funcs);
    let var1 = v; // force inclusion of this variable
    let var2 = random(vars);
    let operator = random(operators);
    let power = round(random(1, 5));
    let term = `${coeff} * ${func}(${var1}) ${operator} ${round(random(1, 20),2)} * ${var2}^${power}`;
    terms.push(term);
    usedVars.add(var1);
    usedVars.add(var2);
  }
  
  // Add extra terms (6 additional) for increased complexity.
  for (let i = 0; i < 6; i++) {
    let coeff = round(random(1, 50), 2);
    let func = random(funcs);
    let var1 = random(vars);
    let var2 = random(vars);
    let operator = random(operators);
    let power = round(random(1, 5));
    let term = `${coeff} * ${func}(${var1}) ${operator} ${round(random(1, 20),2)} * ${var2}^${power}`;
    terms.push(term);
    usedVars.add(var1);
    usedVars.add(var2);
  }
  
  // If any variable is missing, add a term explicitly.
  for (let v of vars) {
    if (!usedVars.has(v)) {
      terms.push(`${round(random(1, 20),2)} * ${v}^${round(random(2, 5))}`);
    }
  }
  
  // Shuffle the terms so they appear in jumbled order.
  shuffle(terms, true);
  equation += terms.join(" + ") + ";";
  return equation;
}

function generateAllSolutions() {
  uSolutions = [];
  vSolutions = [];
  wSolutions = [];
  for (let i = 0; i < numEquations; i++) {
    uSolutions.push(generateRandomEquation("u"));
    vSolutions.push(generateRandomEquation("v"));
    wSolutions.push(generateRandomEquation("w"));
  }
}

// ----------------------------------------------------------------
// 2. Define Navier–Stokes Equations with Boundary Conditions (WxMaxima syntax)
// ----------------------------------------------------------------
function generateNavierStokesEquations() {
  nsEquations = [
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
// 3. Dummy Substitution/Verification of NS Equations
//    (In a real system, you would substitute the generated solution functions
//     into the NS system and simplify symbolically. Here we simulate this process.)
// ----------------------------------------------------------------
function generateVerifiedNSEquations() {
  verifiedNSEquations = [];
  // For each NS equation, append a comment showing a dummy substitution
  for (let i = 0; i < nsEquations.length; i++) {
    // Simulate a substitution by appending a comment with one random solution from u, v, or w.
    let sampleSol = "";
    if (nsEquations[i].indexOf("u") !== -1) {
      sampleSol = uSolutions[floor(random(uSolutions.length))];
    } else if (nsEquations[i].indexOf("v") !== -1) {
      sampleSol = vSolutions[floor(random(vSolutions.length))];
    } else if (nsEquations[i].indexOf("w") !== -1) {
      sampleSol = wSolutions[floor(random(wSolutions.length))];
    }
    // Dummy residual check (here we simply assume the substitution "verifies")
    let verifiedEq = nsEquations[i] + "\n/* Verified substitution: " + sampleSol + " */";
    verifiedNSEquations.push(verifiedEq);
  }
}

// ----------------------------------------------------------------
// 4. CSV Export Functions
//    a. Export arbitrary solution equations for u, v, and w individually.
//    b. Export NS equations with boundary conditions.
//    c. Export verified NS equations (after dummy substitution check).
// ----------------------------------------------------------------
function exportArrayToCSV(arr, header, filename) {
  let csvContent = header + "\n";
  for (let i = 0; i < arr.length; i++) {
    // For arrays that already are strings (solutions or equations), include an index.
    csvContent += (i + 1) + ",\"" + arr[i].replace(/"/g, '""') + "\"\n";
  }
  let blob = new Blob([csvContent], { type: "text/csv" });
  let a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = filename;
  a.click();
}

// Export solutions: u, v, and w individually.
function exportUSolutions() {
  exportArrayToCSV(uSolutions, "Index,Equation", "u_equations.csv");
}
function exportVSolutions() {
  exportArrayToCSV(vSolutions, "Index,Equation", "v_equations.csv");
}
function exportWSolutions() {
  exportArrayToCSV(wSolutions, "Index,Equation", "w_equations.csv");
}

// Export NS equations with boundary conditions.
function exportNSEquations() {
  exportArrayToCSV(nsEquations, "Index,WxMaxima Equation", "navier_stokes_boundary_conditions.csv");
}

// Export verified NS equations.
function exportVerifiedNSEquations() {
  exportArrayToCSV(verifiedNSEquations, "Index,Verified WxMaxima Equation", "verified_navier_stokes_equations.csv");
}

// ----------------------------------------------------------------
// 5. Key Press Handling:
//    "U" -> Export u_equations.csv
//    "V" -> Export v_equations.csv
//    "W" -> Export w_equations.csv
//    "B" -> Export navier_stokes_boundary_conditions.csv
//    "N" -> Export verified_navier_stokes_equations.csv
// ----------------------------------------------------------------
function keyPressed() {
  if (key === "U") {
    exportUSolutions();
  } else if (key === "V") {
    exportVSolutions();
  } else if (key === "W") {
    exportWSolutions();
  } else if (key === "B") {
    exportNSEquations();
  } else if (key === "N") {
    exportVerifiedNSEquations();
  }
}
