function [g] = ForceContact(g,t)

global NFPlate FPlate NBody Body

%for each ground force
for k=1:NFPlate

    %Evaluate the splines of Forces and COP at time t
    Fxy =   ppval(FPlate(k).Fxy_spline, t);
    Fz =    ppval(FPlate(k).Fz_spline, t);
    CoPxy = ppval(FPlate(k).COPxy_spline, t);
    
    force=[Fxy; Fz];
    
    [force,sPpi] = groundreaction(k,t);
    spi = Body(i).A*sPpi;
    
    %Applys to the right body the force and corresponding Moment
    [g] = ApplyForce(i,g,force,n,sp);
end

end
