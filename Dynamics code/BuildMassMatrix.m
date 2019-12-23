function [M] = BuildMassMatrix(Body,NBodies)
%create memory space for mass matrix
M = zeros(NCoordinates,NCoordinates);
for i = 1:NBodies
    i1 = 3*i - 2;
    i2 = i1 + 1;
    i3 = i2 + 1;
    M(i1,i1) = Body(i).mass;
    M(i2,i2) = Body(i).mass;
    M(i3,i3) = Body(i).inertia;
end
end