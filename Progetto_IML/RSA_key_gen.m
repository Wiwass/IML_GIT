function [n,e,d] = RSA_key_gen(p,q)
    n = int32(p*q);
    r = int32((p-1)*(q-1));
    e = int32(2);
    while gcd(e,r) ~= 1
        e = e + 1;
    end
    d = int32(modinv(e,r));
    
end


function Xinv = modinv(X,p)

if numel(p) ~= 1
  error('p must be a scalar')
end

% pre-allocate Xinv as NaN in case some elements of X have no inverse
Xinv = NaN(size(X));

% if p is symbolic, then Xinv should also be symbolic.
if isa(p,'sym')
  Xinv = sym(Xinv);
end

% all the hard work will be done by gcd.
[G,C] = gcd(X,p);

% if G is not equal to 1, then no solution exists.
k = G == 1;
Xinv(k) = mod(C(k),p);

end