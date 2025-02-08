function original = RSA_dec(cipher, d, n)
    d=double(d);
    n=double(n);
    original = ModularExponentiation(cipher, d, n);
end