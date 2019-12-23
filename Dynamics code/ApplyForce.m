function [g] = ApplyForce(i,g,force,n,sp)
i1 = 3*i-2;
i2 = i1 + 1;
i3 = i2 + 1;
g(i1:i2,1) = g(i1:i2,1) + force;
g(i3,1) = g(i3,1) + sp(1,1)*force(2,1) - sp(2,1)*force(1,1);
end