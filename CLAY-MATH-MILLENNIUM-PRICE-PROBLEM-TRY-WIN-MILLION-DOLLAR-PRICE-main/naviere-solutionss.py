import random
import sympy as sp

# Define symbols
x, y, z, t = sp.symbols('x y z t')

# Define available special functions in WxMaxima
functions = [
    sp.sin, sp.cos, sp.tan, sp.sinh, sp.cosh, sp.tanh,   # Trigonometric & Hyperbolic
    sp.exp, sp.log, sp.sqrt, sp.Abs,                    # Exponential, Log, Square Root, Absolute
    sp.atan, sp.atan2,                                  # Inverse Trigonometric
    lambda v: sp.besselj(0, v), lambda v: sp.besselj(1, v),  # Bessel J0, J1
    lambda v: sp.bessely(0, v), lambda v: sp.bessely(1, v),  # Bessel Y0, Y1
    lambda v: sp.chebyshevt(random.randint(1, 5), v),   # Chebyshev Polynomial
    lambda v: sp.legendre(random.randint(1, 5), v)      # Legendre Polynomial
]

# Define operators
operators = ["+", "-", "*", "/"]

# Generate a single large, complex equation with all variables
def generate_large_equation():
    terms = []
    for _ in range(random.randint(8, 12)):  # 8 to 12 terms per equation
        var = random.choice([x, y, z, t])
        func = random.choice(functions)
        coeff = round(random.uniform(1, 50), 2)  # Arbitrary constant
        operator = random.choice(operators)

        # Construct mathematical term using function and variable
        term = f"{coeff} * {func(var)} {operator}"
        terms.append(term)

    # Ensure all x, y, z, t are present at least once
    extra_terms = [
        f"{round(random.uniform(1, 20), 2)} * x^2",
        f"{round(random.uniform(1, 20), 2)} * y^3",
        f"{round(random.uniform(1, 20), 2)} * z^4",
        f"{round(random.uniform(1, 20), 2)} * t^5"
    ]
    terms.extend(extra_terms)

    # Shuffle terms for a jumbled order
    random.shuffle(terms)

    # Construct the full equation in WxMaxima syntax
    equation = " + ".join(terms) + ";"
    return equation.replace("+ -", "- ")  # Correct signs

# Generate 2000 equations
num_equations = 2000
equations = {
    "u(x,y,z,t)": [],
    "v(x,y,z,t)": [],
    "w(x,y,z,t)": []
}

for _ in range(num_equations // 3):  # Divide equations among u, v, w
    equations["u(x,y,z,t)"].append(generate_large_equation())
    equations["v(x,y,z,t)"].append(generate_large_equation())
    equations["w(x,y,z,t)"].append(generate_large_equation())

# Save to WxMaxima-compatible text file
with open("large_navier_stokes_equations.txt", "w") as f:
    for key, eq_list in equations.items():
        for eq in eq_list:
            f.write(f"{key} := {eq}\n")

print(f"✅ Successfully generated {num_equations} large equations and saved to large_navier_stokes_equations.txt")

