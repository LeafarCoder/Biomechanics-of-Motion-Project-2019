function [g] = ForceSDA(g)
% Add to the current 'g' all the spring-damper forces

global SpringDamper NSpringDamper

%for each spring damper actuator

for e = 1:NSpringDamper
    i = SpringDamper(e).i;
    j = SpringDamper(e).j;
    sPpi = SpringDamper(e).spi;
    sPpj = SpringDamper(e).spj;
    k = SpringDamper(e).k;
    l0 = SpringDamper(e).l0;
    c = SpringDamper(e).c;
    a = SpringDamper(e).a;
    
    %evaluate the force direction
    sPi = Body(i).A*sPpi;
    sPj = Body(j).A*sppj;
    rpi = Body(i).r + sPi;
    rpj = Body(j).r + sPj;
    d = rpj - rpi;
    l = sqrt(d'*d);
    u = d/l;
    f_spring = k*(l-l0);
    
    dd =    (Body(j).rd + Body(j).B*sPpj*Body(j).thetad) - ...
            (Body(i).rd + Body(i).B*sPpi*Body(i).tehtad);
    ld = dd'*u;
    f_damper = c*ld;
    f_actuator = a;
    
    force = (f_spring + f_damper + f_actuator) * u;
    
    [g] = ApplyForce(i, g, force, n, sPpi);
    [g] = ApplyForce(j, g, force, n, sPpj);
    
end    

end