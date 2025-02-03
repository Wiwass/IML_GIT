function encripted_string = RSA_enc(string,n,e)
    string=char(string);
    encripted_string = ModularExponentiation(string, e, n); 
end