function ComputeBodyInertialProperties(totalMass)

global NBody Body

%Non-Normalized Inertia calculation
for i=1:NBody
    Body(i).mass = totalMass * Body(i).massPerc;
    Body(i).J = mass * (Body(i).rg * Body(i).Length)^2;
end

end