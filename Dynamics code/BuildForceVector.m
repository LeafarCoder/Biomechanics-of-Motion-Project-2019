function [g] = BuildForceVector()

global

%add the gravitational forces
[g] = Forcegravity();

%add the spring-damper-actuator forces
[g] = ForceSDA(g);

%add contact forces
[g] = ForceContact(g);

end