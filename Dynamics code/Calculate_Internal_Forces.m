function F = Calculate_Internal_Forces(lambda, Jac)

global NBody NCoord Body NRevolute JntRevolute NDriver Driver;

F = zeros(3*NRevolute, 1);
%Calculates forces F
for k = 1:NRevolute
    i = JntRevolute(k).i;
    j = JntRevolute(k).j;
    k1=3*k-2;
    i1=3*i-2;
    %Picks out correct lines from Jacobian and lambdas for Fx Fz
    
    Jac_rev = [Jac(2*k-1:2*k,:)]';
    lambda_rev = [lambda(2*k-1:2*k,1)];
    F_rev = Jac_rev * lambda_rev;
    F(k1 : k1+1, 1) = F(k1 : k1 + 1, 1) + F_rev(i1 : i1 + 1, 1);
    
    %Picks out correct lines from Jacobian and lambdas for Moment
    Nskip = 2*NRevolute;
    Jac_driver = Jac(Nskip + k,:)';
    lambda_driver = lambda(Nskip + k, 1);
    F_driver = Jac_driver * lambda_driver;
    %this line needs revision!!!!!!!!!!!!!!!!!!!!!!
    F(k1+2, 1) = F(k1+2, 1) + F_driver(i1+2, 1);
    a=1;
end


end

