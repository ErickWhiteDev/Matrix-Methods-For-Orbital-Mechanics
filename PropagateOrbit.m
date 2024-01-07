function orbit = PropagateOrbit(eqeph, steps)
    orbit = zeros(steps, 3);

    lM = linspace(0, 2 * pi, steps);

    n = eqeph(4);
    af = eqeph(1);
    ag = eqeph(2);
    chi = eqeph(5);
    psi = eqeph(6);

    for i = 1:steps
        orbit(i, :) = convert_equinoctial_to_cartesian(n, af, ag, chi, psi, lM(i), 0)';
    end
end
