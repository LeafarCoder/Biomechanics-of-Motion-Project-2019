function [g] = BuildForceVector(t)

%add the gravitational forces
g = ForceGravity();

%add the spring-damper-actuator forces - not used
%[g] = ForceSDA(g);

%add contact forces
g = ForceContact(g,t);

end