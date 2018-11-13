# Solving partial differential equations numerically using Laplace Transformation (Thesis)
Calculation of wave equations using mixed boundary conditions.

The use of a transmission line to model the wave propagation of signals is a widely used
technique. First derived by English mathematician Oliver Heaviside, the telegrapher’s equa-
tions give the wave propagation inside a cable. Its broad field of usage also makes its ways
into Computational Photonics by applying telegrapher’s equations to simulate the connection
of the source to the micro strip transmission line in the quantum cascade laser (QCL) for an
analysis of the variables in the circuit. An adapted version is used in the QCL to determine
the behavior of the voltage and current inside the micro strip transmission line.

## Numerical Treatment
For a further discussion and in order to compute the transmission line equations it is useful
to dig deeper into the finite difference time domain (FDTD) method and especially into the so
called Yee-scheme. In order to solve equations numerically an approximation of those
equations has to be obtained.

The previously mentioned Yee-grid describes Maxwell’s equations and can be written as a set
of finite difference equations with perfectly conducting surfaces as a condition. So when the
boundary conditions are pertinent for perfect conductors, Yee provides a general numerical
solution. The transmission line equations used in this case are time and spatially dependent,
leading to a one-dimensional grid which fully describes the transmission line equations. I. e.
a solution for the current and the voltage can be calculated for every time and spatial step in
the grid. With a smart allocation of the vectors used to solve the partial differential equations
a relatively fast simulation can be obtained. However, Yee derived his method in 3D locating
the various field component in a cube. For the equation used in our case, it is sufficient to
simplify the Yee-scheme for a more simpler case in a one dimensional grid.
For the Yee-grid method, conditions in concern to the grid and the stability of the grid must
be taken into account. Courant et al. provide a proof why the spatial distance ∆z and the
distance ∆t for the time between two grid points can converge to zero without the calcula-
tions getting instable. The lower limit can convert to zero, although it must not be zero
for obvious reasons. Since the lower limit is set, the question of an upper limit for the size
between two grid points remains. The distance between two grid points regarding the maxi-
mum ∆z has to be small enough so that there are no significant changes within two following 
grid points determinable. When ∆z fulfills this condition, also the value for ∆t fulfills the 
verysame conditions because of the relations introduced in the following equation ∆z ≥ c∆t.
After speaking about the relation between ∆t and ∆z there is also another condition which
has to be fulfilled: The Courant-Friedrichs-Lewy condition. At the edge case of ∆z = c∆t
numerical instability in the one dimensional case occurs which is referred to the magical time-
step. This instability was proven by [14]. Also for the case that ∆z < ∆t, instability ensues as
Min et al. proves. If for the electric permittivity  and the magnetic permittivity μ constants
are used, the so called Courant number can be used to get a relation between the grid size
of the spatial component and the time component so that the system stays numerical stable
for the calculations. This stability condition is also called Courant-Friedrichs-Lewy condition
∆t ≤ ∆z/c. with the constant c referring to the velocity of propagation. The Courant number thus has
to be chosen smaller than one but also close to one. In the transmission lines used in the
simulation a Courant number C = 0.9 is used. The Courant number C can be calculated with
C =∆tc/∆z, 
where C should be chosen smaller than 1. If C = 1 instability occurs. This state is also called
magic time step.
