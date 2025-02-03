function original = RSA_dec(cipher, d, n)
    original = ModularExponentiation(cipher, d, n);
end