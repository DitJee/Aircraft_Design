%% functions
    function rho = rhocal(height)
      rho = 0.002378*(1-0.0000068756*height)^4.2561;
    end