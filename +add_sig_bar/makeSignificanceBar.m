
function H=makeSignificanceBar(x,y,p)
    %makeSignificanceBar produces the bar and defines how many asterisks we get for a 
    %given p-value
    if p<=1E-3
        stars='***'; 
    elseif p<=1E-2
        stars='**';
    elseif p<=0.05
        stars='*';
    elseif isnan(p)
        stars='n.s.';
    else
        stars='n.s.';
    end
            
%     y  = 7;
    x=repmat(x,2,1);
    y=repmat(y,4,1);
    H(1)=plot(x(:),y,'-k','LineWidth',1.5,'Tag','sigstar_bar');
    %Increase offset between line and text if we will print "n.s."
    %instead of a star. 
%     if ~isnan(p)
%         offset=0.005;
%     else
        offset=0.02;
%     end
    starY=mean(y)+add_sig_bar.myRange(ylim)*offset;
    H(2)=text(mean(x(:)),double(starY),stars,...
        'HorizontalAlignment','Center',...
        'BackGroundColor','none',...
        'Tag','sigstar_stars','FontSize',16);
    Y=ylim;
    if Y(2)<starY
        ylim([Y(1),starY+add_sig_bar.myRange(Y)*0.05])
    end
end %close makeSignificanceBar
