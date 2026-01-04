# Fast Inverse Square Root (Quake III) — SystemVerilog Simulation

This project is a small SystemVerilog simulation of the famous **fast inverse square root** routine popularized by Quake III Arena.

It demonstrates the classic idea:

1. Start with an initial approximation using a **bit-level reinterpretation trick** (the “magic constant” hack)
2. Refine the estimate with **Newton–Raphson iterations**

> Important: This is primarily a *simulation/learning* project. The bit-hack and real-number system functions used here are **not synthesizable** for FPGA/ASIC.

---

## What it computes

Given a positive input $x$, it approximates:

$$y \approx \frac{1}{\sqrt{x}}$$

The design in this repo performs:

- An initial approximation based on floating-point bit patterns
- Two Newton–Raphson refinement steps:

$$y_{n+1} = y_n \cdot \left(1.5 - 0.5x\,y_n^2\right)$$

Two iterations typically produce a very accurate result for many values of $x$.
 this one high level step is why this algorithm cannot be synthesized .
---

## Files

- [quakes3.sv](quakes3.sv) — `fast_inv_sqrt_sim` module (simulation model)
- [tb_quakes3.sv](tb_quakes3.sv) — testbench that drives a few sample inputs and prints results

---

## How it works (high level)

### 1) Double-precision bit-hack (simulation)

Most Verilog simulators treat `real` as **64-bit IEEE-754 double precision**. The original Quake III routine was designed for **32-bit float**.

This project uses a **64-bit analogue** of the trick:

- Convert `real` to its raw 64-bit representation with `$realtobits`
- Apply the approximation step with a 64-bit “magic” constant
- Convert the bits back to `real` with `$bitstoreal`

### 2) Newton–Raphson refinement

After the bit-hack, the module runs two Newton iterations to converge quickly.

---

## Build and run (Icarus Verilog)

This repo was verified with **Icarus Verilog 0.9.7** on Windows using SystemVerilog mode.

From the workspace folder:

```powershell
cd s:\problems
iverilog -gsystem-verilog -o quakes3_sim quakes3.sv tb_quakes3.sv
vvp quakes3_sim
```

Expected output looks like:

```text
Fast Inverse Square Root Simulation
----------------------------------
Input: 4.000000  |  1/sqrt(x) ≈ 0.499998
Input: 9.000000  |  1/sqrt(x) ≈ 0.333333
Input: 2.000000  |  1/sqrt(x) ≈ 0.707107
Input: 0.250000  |  1/sqrt(x) ≈ 1.999991
```

---

## Module interface

Because older Icarus versions do not accept `real` ports reliably, the module uses a **bits-based interface**:

- Input: `x_bits[63:0]` is the raw IEEE-754 encoding of a double
- Output: `y_bits[63:0]` is the raw IEEE-754 encoding of the result

The testbench converts between `real` and bit patterns using `$realtobits` / `$bitstoreal`.

---

## Notes and limitations

- **Domain**: The algorithm expects $x > 0$. (Zero/negative inputs may produce meaningless results.)
- **Not synthesizable**: Uses `real` arithmetic and real/bit conversion system functions.
- **Precision**: The double-precision magic constant is an approximation analogue; accuracy is mainly ensured by Newton iterations.
- **Simulator support**: This implementation avoids `shortreal` because it is not supported in Icarus Verilog 0.9.7.

---


- Implement a fixed-point or LUT-based inverse sqrt that *is* synthesizable
