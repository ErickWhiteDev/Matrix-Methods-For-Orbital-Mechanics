function [x, y, z, ox, oy, oz] = ProcessEphemeris(r, v, cov, runs, steps)
    if nargin < 4
        runs = 1000;
    end

    if nargin < 5
        steps = 10000;
    end
    
    [~, n, af, ag, chi, psi, lM] = convert_cartesian_to_equinoctial(r, v);
    eqeph = [af, ag, lM, n, chi, psi];
    eqcov = ECI2EQN(cov, r, v);
    
    orbit = PropagateOrbit(eqeph, steps);
    
    ox = orbit(:, 1);
    oy = orbit(:, 2);
    oz = orbit(:, 3);
    
    eqmat = mvnrnd(eqeph, eqcov, runs);
    
    len = size(eqmat, 1);
    
    cartmat = zeros(len, 3);
    
    n = eqmat(:, 4);
    af = eqmat(:, 1);
    ag = eqmat(:, 2);
    chi = eqmat(:, 5);
    psi = eqmat(:, 6);
    lM = eqmat(:, 3);
    
    for i = 1:len
        cartmat(i, :) = convert_equinoctial_to_cartesian(n(i), af(i), ag(i), chi(i), psi(i), lM(i), 0)';
    end
    
    x = cartmat(:, 1);
    y = cartmat(:, 2);
    z = cartmat(:, 3);
end
