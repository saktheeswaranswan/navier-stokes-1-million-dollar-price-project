import csv

# Define Navier-Stokes equations in WxMaxima syntax
navier_stokes_equations = [
    ["Continuity Equation", "diff(u, x) + diff(v, y) + diff(w, z) = 0;"],

    ["Momentum Equation - x-direction",
     "diff(u, t) + u * diff(u, x) + v * diff(u, y) + w * diff(u, z) = - (1/rho) * diff(p, x) + nu * (diff(u, x, 2) + diff(u, y, 2) + diff(u, z, 2));"],

    ["Momentum Equation - y-direction",
     "diff(v, t) + u * diff(v, x) + v * diff(v, y) + w * diff(v, z) = - (1/rho) * diff(p, y) + nu * (diff(v, x, 2) + diff(v, y, 2) + diff(v, z, 2));"],

    ["Momentum Equation - z-direction",
     "diff(w, t) + u * diff(w, x) + v * diff(w, y) + w * diff(w, z) = - (1/rho) * diff(p, z) + nu * (diff(w, x, 2) + diff(w, y, 2) + diff(w, z, 2));"],

    ["No-Slip Boundary Condition", "u = 0, v = 0, w = 0;"],

    ["Free-Slip Boundary Condition", "n.u = 0, t.diff(u, t) = 0;"],

    ["Inlet Boundary Condition", "u(x, y, z) = f(y, z), v = 0, w = 0;"],

    ["Uniform Inlet", "u = U0;"],

    ["Parabolic Inlet (Poiseuille Flow)", "u = Umax * (1 - (r^2 / R^2));"],

    ["Outlet Boundary Condition",
     "diff(u, x) = 0, diff(v, x) = 0, diff(w, x) = 0, p = p_outlet;"],

    ["Periodic Boundary Condition", "u(x+L, y, z) = u(x, y, z);"]
]

# Save to CSV file
csv_filename = "navier_stokes_equations.csv"
with open(csv_filename, "w", newline="") as csvfile:
    csv_writer = csv.writer(csvfile)
    csv_writer.writerow(["Equation Type", "WxMaxima Syntax"])
    csv_writer.writerows(navier_stokes_equations)

print(f"✅ Successfully generated Navier-Stokes equations and saved to {csv_filename}")

