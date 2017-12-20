function slm_plotTrial(what,SIM,T,varargin);
% function slm_plotTrial(SIM,T);
% Plots the horse race on the current sequence trial

vararginoptions(varargin,{'style'});


switch what
    case 'TrialHorseRace'
        figure('color' , 'white')
        [~,~,numPresses] = size(SIM.X);
        
        numDec = unique(T.decisionTime);
        for i = 1:length(numDec)
            T.decNum(T.decisionTime == numDec(i)) = i;
        end
        for i=1:numPresses
            subplot(numPresses,1,i);
            plot(SIM.t,SIM.X(:,:,i));
            hold on;
            plot(SIM.t,SIM.B,'k', 'LineWidth' , 1.5);
            ylim = get(gca , 'YLim');
            h1 = line([T.stimTime(i) T.stimTime(i)] , ylim ,'color','r','linestyle',':' , 'LineWidth' , 2);
            h2 = line([T.decisionTime(i) T.decisionTime(i)] , ylim,'color','r', 'LineWidth' , 2);
            h3 = line([T.pressTime(i) T.pressTime(i)],ylim,'color','k', 'LineWidth' , 2);
            % just legend the first one, the rest are the same
            if i ==1
                legend([h1 h2 h3],{'Stimulus came on' , 'Decision boundry reached' , 'Press executed'})
            end
            if isfield(T , 'Horizon')
                text(10,.9 , ['Horizon = ' , num2str(T.Horizon) , '  -  Buffer size = ' , num2str(SIM.bufferSize)])
            end
            title(['Decision No. ' ,num2str(T.decNum(i)), ', press No.' , num2str(i)])
            set(gca , 'Box' , 'off' , 'FontSize' , 16)
        end;
    case 'BlockMT'
        colorz = {[0 0  1],[1 0 0],[0 1 0],[1 0 1],[0 1 1],[0.7 0.7 0.7],[1 1 0],[.3 .3 .3]};
        if isfield(T , 'Horizon') && isfield(T , 'bufferSize')
           S = tapply(T , {'Horizon' , 'bufferSize'} , {'MT' , 'nanmean'});
        else
            T.Horizon = ones(size(T.TN)) * (size(T.stimulus , 2) -1); % full
            T.bufferSize = ones(size(T.TN)) * SIM.bufferSize(1); 
            S = tapply(T , {'Horizon' , 'bufferSize'} , {'MT' , 'nanmean'});
        end
        bs = unique(S.bufferSize);
        H = unique(S.Horizon);
        figure('color' , 'white')
        subplot(211)
        if length(bs)>1 && length(H)>1 
            [x, p , e] = lineplot([T.Horizon , T.bufferSize]  ,  T.MT , 'style_shade');
            count = 1;
            for i = 1 :length(x)/length(H) : length(x)
                text(x(i)+1 , max(T.MT) , ['Horizon = ' , num2str(H(count))])
                count = count +1;
            end
            xlabel('Buffer size')
        elseif length(bs)==1 && length(H)>1
            [x, p , e] = lineplot([T.Horizon]  ,  T.MT , 'style_shade');
            xlabel('Horizon size')
        elseif length(bs)>1 && length(H)==1
            [x, p , e] = lineplot([T.bufferSize]  ,  T.MT , 'style_shade');
            xlabel('Buffer size')
        end
        P = reshape(p  , length(bs),length(H));
        E = reshape(e , length(bs),length(H));
        
        grid on
        
        title('Movement Time in Correct Trials')
        subplot(212)
        leg = {};
        for i = 1:length(bs)
            hi = errorbar([1:length(H)] , P(i,:) , E(i,:) , 'LineWidth' , 3 , 'color' , colorz{i})
            leg = [leg , ['BufferSize = ' , num2str(bs(i))]];
            hold on
        end
        grid on
        xlabel('Horizon size')
        ylabel('msec')
        legend(leg)
        set(gca , 'Box' , 'off')
        
    case 'IPIHist'
        figure('color' , 'white')
        histogram(T.pressTime(~T.isError , :)); 
        hold on
        histogram(T.pressTime(logical(T.isError) , :)); 
        legend({'Correct Trials', 'Error Trials'})
        title('Distribution of Press Times')
end
