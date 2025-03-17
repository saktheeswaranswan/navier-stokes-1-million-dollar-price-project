import random
import csv
import sympy as sp

# Define symbols
x, y, z, t = sp.symbols('x y z t')

# Define available special functions in WxMaxima
functions = [
    sp.sin, sp.cos, sp.tan, sp.sinh, sp.cosh, sp.tanh,   # Trigonometric & Hyperbolic
    sp.exp, sp.log, sp.sqrt, sp.Abs,                    # Exponential, Log, Square Root, Absolute
    sp.atan,                                            # Inverse Trigonometry
    lambda v: sp.besselj(0, v), lambda v: sp.besselj(1, v),  # Bessel J0, J1
    lambda v: sp.bessely(0, v), lambda v: sp.bessely(1, v),  # Bessel Y0, Y1
    lambda v: sp.chebyshevt(random.randint(1, 5), v),   # Chebyshev Polynomial
    lambda v: sp.legendre(random.randint(1, 5), v)      # Legendre Polynomial
]

# Define operators
operators = ["+", "-", "*", "/"]

# Generate a single large, complex equation ensuring all variables exist
def generate_large_equation(variable):
    vars_list = [x, y, z, t]
    terms = []
    used_vars = set()

    # Ensure each equation contains x, y, z, t at least once
    for v in vars_list:
        coeff = round(random.uniform(1, 50), 2)
        func = random.choice(functions)
        var1 = v
        var2 = random.choice(vars_list)
        operator = random.choice(operators)
        term = f"{coeff} * {func(var1)} {operator} {round(random.uniform(1, 20), 2)} * {var2}**{random.randint(1, 5)}"
        terms.append(term)
        used_vars.add(var1)
        used_vars.add(var2)

    # Add extra terms to make the equation long
    for _ in range(6):
        coeff = round(random.uniform(1, 50), 2)
        func = random.choice(functions)
        var1 = random.choice(vars_list)
        var2 = random.choice(vars_list)
        operator = random.choice(operators)
        term = f"{coeff} * {func(var1)} {operator} {round(random.uniform(1, 20), 2)} * {var2}**{random.randint(1, 5)}"
        terms.append(term)
        used_vars.add(var1)
        used_vars.add(var2)

    # Verify all variables are included, otherwise add missing ones
    for v in vars_list:
        if v not in used_vars:
            terms.append(f"{round(random.uniform(1, 20), 2)} * {v}**{random.randint(2, 5)}")

    # Shuffle terms for a jumbled order
    random.shuffle(terms)

    # Construct the equation
    equation = f"{variable}(x,y,z,t) := " + " + ".join(terms) + ";"
    return equation

# Generate multiple equations
num_equations = 100  # Adjust the number of equations as needed
equations = []

for _ in range(num_equations // 3):
    equations.append(["u", generate_large_equation("u")])
    equations.append(["v", generate_large_equation("v")])
    equations.append(["w", generate_large_equation("w")])

# Save to CSV file
csv_filename = "large_navier_stokes_equations.csv"
with open(csv_filename, "w", newline="") as csvfile:
    csv_writer = csv.writer(csvfile)
    csv_writer.writerow(["Function", "Equation"])
    csv_writer.writerows(equations)

print(f"✅ Successfully generated {num_equations} large equations and saved to {csv_filename}")

