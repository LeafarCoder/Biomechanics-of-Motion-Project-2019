function [g] = BuildForceVector()

%add the gravitational forces
[g] = ForceGravity();

%add the spring-damper-actuator forces
[g] = ForceSDA(g);

%add contact forces
[g] = ForceContact(g);

end