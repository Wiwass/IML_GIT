function somma=addnumbers(m)
    % somma=sum(sum(m)); %programma della richiesta
    somma=0;
    [a, b]=size(m);
    for i = 1:a
        for j = 1:b
        somma=somma+m(i,j);
        end
    end

end