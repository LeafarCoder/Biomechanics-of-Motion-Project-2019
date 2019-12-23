function [g] = ForceContact(g)

global NGroundForce GroundForce Body

%for each ground force
for k=1:NGroundForce
    i = groundForce(k).i;
    [force,sPpi] = groundreaction(k,time);
    spi = Body(i).A*sPpi;
    [g] = ApplyForce(i,g,force,n,sp);
end

end
