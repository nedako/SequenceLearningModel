function slm_plotTrial(SIM,T,varargin);
% function slm_plotTrial(SIM,T);
% Plots the horse race on the current sequence trial 

vararginoptions(varargin,{'style'}); 
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

