function [F,converged,cF,sF] = equinoctial_kepeq(lam,af,ag,Ftol,maxiter,errflag)
    
    % Solve Kepler's equation in equinoctial elements.
    
    % Ensure mean longitude in the range 0 <= lam < 2*pi
    
    twopi = 2*pi;
    lam = mod(lam,twopi);
    
    % Initialize convergence flag
    
    converged = false;
    
    % Calculate eccentricity squared
    
    ecc2 = af^2+ag^2;
    
    if ecc2 >= 1
        % Handle warning or error
        errtext = 'equinoctial_kepeq cannot process eccentricities >= 1' ;
        if errflag == 1
            warning(errtext);
            F = []; cF = []; sF = [];
            return;
        elseif errflag == 2
            error(errtext);
        elseif errflag ~= 0
            error('Invalid errflag value');
        end
    end
    
    % if ecc2 < 0.81 % Corresponds to ecc < 0.9 (used for testing)
        
        % Use iterative algorithm of Valado and Alfano (2015) equation 10 
        % to find eccentric longitude F
    
        F = lam; cF = cos(F); sF = sin(F);
        
        iter = 0;
        still_looping = true;
    
        while still_looping
    
            % Calculate the increment for F
    
            top  = F + ag*cF - af*sF - lam;
            bot  = 1 - ag*sF - af*cF;
            Fdel = top/bot;
    
            % Update F
    
            F = F - Fdel; cF = cos(F); sF = sin(F);
    
            % Check for F convergence
    
            absFdel = abs(Fdel);
            
            if iter == 0
                maxabsFdel = absFdel;
            else
                maxabsFdel = max(absFdel,maxabsFdel);
            end
            
            if (absFdel < Ftol)
                % Nominal convergence
                converged = true; still_looping = false;
            elseif (iter >= maxiter) || (absFdel >= pi)
                % Failure to converge from to many iterations or for too large
                % an increment
                still_looping = false;
            else
                % Increment iteration counter
                iter = iter+1;
            end
    
        end
    
    % end
    
    % If solution remains unconverged, then use Matlab's fminbnd function, 
    % which is more stable for high eccentricites than algorithm of 
    % Valado and Alfano (2015).
    
    if ~converged
        
        % Anonymous function for Kepler's equation in equinoctial elements
        
        KEP = @(FF) abs(FF + ag*cos(FF) - af*sin(FF) - lam);
    
        % Solve Kepler's equation using Matlab's fminbnd function
        
        options = optimset('fminbnd');
        options = optimset(options,'TolX',Ftol,'MaxIter',max(maxiter,500));
        
        [F0,~,exitflag] = fminbnd(KEP,0,twopi,options);
        
        % Check for convergence
        
        if exitflag == 1
            converged = true;
            F = F0; cF = cos(F); sF = sin(F);
        end
    
    end
    
    % If solution still remains unconverged, then issue warning or error
    
    if ~converged
        % Handle warning or error
        errtext = 'equinoctial_kepeq failed to converge' ;
        if errflag == 1
            warning(errtext);
            F = []; cF = []; sF = [];
        elseif errflag == 2
            error(errtext);
        elseif errflag ~= 0
            error('Invalid errflag value');
        end
    end
end
