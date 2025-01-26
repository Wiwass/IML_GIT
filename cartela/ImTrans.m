function x=ImTrans(Img, mode)
    
    if mode=='neg'
        x= imadjust(Img, [0 1], [1 0]);
        return;
    
    elseif mode=='pot'
        prompt = 'value pot:';
        c=input(prompt);
        x = imadjust(Img, [ ], [ ], c);
        return;
    
    elseif mode=='log'
        prompt = 'value c:';
        c=input(prompt);
        x=c*log(1+double(Img));
        return;

    elseif mode=='con'
        prompt = 'value E:';
        E=input(prompt);
        prompt = 'value m:';
        m=input(prompt);
        
        eps=0.00000000001;
        x=1./(1+(m./(double(Img)+eps)).^E);
        return;

    else %caso base
        return ;
    end
   
end