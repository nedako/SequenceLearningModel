function slm_plotTrial(SIM,T,varargin);
% function slm_plotTrial(SIM,T);
% Plots the horse race on the current sequence trial 

style = 'multipanel'; 
vararginoptions(varargin,{'style'}); 
figure('color' , 'white')
[numOptions,~,numPresses] = size(SIM.X);

numDec = unique(T.decisionTime);
for i = 1:length(numDec)
    temp = find(T.decisionTime == numDec(i));
    T.decNum(temp) = i;
end
for i=1:numPresses 
    
    subplot(numPresses,1,i); 
    plot(SIM.t,SIM.X(:,:,i)); 
    hold on; 
    plot(SIM.t,SIM.B,'k'); 
    drawline(T.stimTime(i),'color','r','linestyle',':'); 
    drawline(T.decisionTime(i),'color','r'); 
    drawline(T.pressTime(i),'color','k'); 
    hold off; 
    title(['Decision process between 5 options for press(es) ' , num2str(i)])
end; 

