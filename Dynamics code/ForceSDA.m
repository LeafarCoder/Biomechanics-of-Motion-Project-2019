function [g] = ForceSDA(g)

global SpringDamper NSpringDampers

%for each spring damper actuator

for e=1:NSpringDampers
    i = SpringDamper(e).i;
    j = SpringDamper(e).j;
    spi = SpringDamper(e).spi;
    spj = SpringDamper(e).spj;
    k = SpringDamper(e).k;
    l0 = SpringDamper(e).l0;
    c = SpringDamper(e).c;
    a = SpringDamper(e).a;
    
    %evaluate the force direction
    spi = Body(i).A*sPpi;
    spj = Body(j).A*sppj;
    rpi = Body(i).r + spi;
    rpj = Body(j).r + spj;
    d = rpj - rpi;
    l = sqrt(d'*d);
    u = d/l;
    fspring = k*(l-l0);
    
    dd = (Body(j).rd + Body(j).B*sPpj*Body(j).thetad)-...
        (Body(i).rd + Body(i).B*sPpi*Body(i).tehtad);
    
    ld = dd'*u;
    fdamper = c*ld;
    factuator = a;
    
    force = (fspring + fdamper + factuator)*u;
    
    [g] = ApplyForce(i,g,force,n,spi);
    [g] = ApplyForce(j,g,force,n, spj); 
    
end    

end