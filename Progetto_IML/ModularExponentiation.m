function Result = ModularExponentiation(Base, Exponent, Modulus)
    Result          = 1;
    TempExponent    = 0;
    
    while true
        
        TempExponent    = TempExponent + 1;        
        Result          = mod((Base .* Result), Modulus);
        
        if TempExponent == Exponent
            break
        end
        
    end
    
end
