function [g] = ForceContact(g,t)

global NFPlate FPlate Body

%for each ground force
for k=1:NFPlate

    %Evaluate the splines of Forces and COP at time t 
    Fxy =   ppval(FPlate(k).Fxy_spline, t);
    Fz =    ppval(FPlate(k).Fz_spline, t);
    CoPxy = ppval(FPlate(k).COPxy_spline, t);
    CoPz = ppval(FPlate(k).COPz_spline, t);
    %Simplifying variable use
    i=FPlate(k).i;
    j=FPlate(k).j;
    spiB=FPlate(k).spi;
    
    %Applys to the right body the force and corresponding Moment
    
    Force=[Fxy; Fz];
    %Deciding in which body to apply the force
    Boundary_Point = Body(i).r + Body(i).A * spiB;
    
    if CoPxy < Boundary_Point
        %apply force to body i
        Rcm=[CoPxy;CoPz]-Body(i).r;
        [g] = ApplyForce(i,g,Force,Rcm);
    else
        %apply force to body j
        Rcm=[CoPxy;CoPz]-Body(j).r;
        [g] = ApplyForce(j,g,Force,Rcm);
        
    end

end

end
