let navierStokesEquations = [];

function setup() {
  createCanvas(800, 600);
  textSize(14);
  generateEquations();
}

function draw() {
  background(255);
  fill(0);
  text("Navier-Stokes Equations (WxMaxima Format):", 20, 30);
  for (let i = 0; i < navierStokesEquations.length; i++) {
    text(navierStokesEquations[i], 20, 50 + i * 20);
  }
}

// Function to generate Navier-Stokes equations in WxMaxima format
function generateEquations() {
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

// Function to export equations to a text file (WxMaxima format)
function exportToTxt() {
  let content = navierStokesEquations.join("\n") + "\n";
  
  let blob = new Blob([content], { type: "text/plain" });
  let a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = "navier_stokes_equations.wxmx";
  a.click();
}

// Function to export equations to a CSV file
function exportToCSV() {
  let csvContent = "Equation Type,WxMaxima Syntax\n";

  for (let eq of navierStokesEquations) {
    let line = eq.startsWith("/*") ? eq.replace("/*", "").replace("*/", "").trim() : "Equation," + eq;
    csvContent += line + "\n";
  }

  let blob = new Blob([csvContent], { type: "text/csv" });
  let a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = "navier_stokes_equations.csv";
  a.click();
}

// Press "T" to export as .txt (WxMaxima format)
// Press "C" to export as .csv
function keyPressed() {
  if (key === "T") {
    exportToTxt();
  } else if (key === "C") {
    exportToCSV();
  }
}
