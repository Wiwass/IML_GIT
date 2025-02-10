function encripted_string = RSA_enc(string,n,e)
    string=double(char(string));
    n=double(n);
    e=double(e);
    encripted_string = ModularExponentiation(string, e, n); 
end