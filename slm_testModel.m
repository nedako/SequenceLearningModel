function vararout=slm_testModel(what,varargin)
% Wrapper function to test different aspects of the sml toolbox 
switch(what)
   
    case 'singleResp'
        % Make Model 
        M.Aintegrate = 1;    % Diagnonal of A  
        M.Ainhibit = 0;      % Inhibition of A 
        M.theta_stim = 0.01;  % Rate constant for integration of sensory information 
        M.dT_motor = 90;     % Motor non-decision time 
        M.dT_visual = 70;    % Visual non-decision time 
        M.SigEps    = 0.01;   % Standard deviation of the gaussian noise 
        M.Bound     = 0.45;     % Boundary condition 
        M.numOptions = 5;    % Number of response options 
        M.capacity   = 3;   % Capacity for preplanning (buffer size) 
        % Make experiment 
        T.TN = 1; 
        T.numPress = 1; 
        T.stimTime = 0; 
        T.forcedPressTime = [NaN NaN]; 
        T.stimulus = 1; 
        
        R=[]; 
        for i=1:1000
            [TR,SIM]=slm_simTrial(M,T); 
            % slm_plotTrial(SIM,TR); 
            R=addstruct(R,TR); 
        end; 
            % slm_plotTrial(SIM,TR); 
        subplot(1,2,1); 
        histplot(R.pressTime,'split',R.stimulus==R.response,'style_bar1'); 
        subplot(1,2,2); 
        
        keyboard; 
    case 'simpleSeq'
          % Make Model 
        M.Aintegrate = 0.98;    % Diagnonal of A  
        M.Ainhibit = 0;      % Inhibition of A 
        M.theta_stim = 0.01;  % Rate constant for integration of sensory information 
        M.dT_motor = 90;     % Motor non-decision time 
        M.dT_visual = 70;    % Visual non-decision time 
        M.SigEps    = 0.02;   % Standard deviation of the gaussian noise 
        M.Bound     = 0.45;     % Boundary condition 
        M.numOptions = 5;    % Number of response options 
        M.capacity   = 5;   % Capacity for preplanning (buffer size) 
        
        % Make experiment 
        T.TN = 1; 
        T.numPress = 10; 
        T.stimTime = zeros(T.numPress , 1);  
        T.forcedPressTime = nan(T.numPress,2); 
        T.stimulus = [1;2;5;4;3;3;5;2;2;4];  
        % Horizon feature added. stimTime will be the actual time that the stimulus came on.
        T.Horizon = 7;    
        
        R=[]; 
        for i=1:100
            i
            [TR,SIM]=slm_simTrialCap(M,T); 
            slm_plotTrial(SIM,TR); 
            R=addstruct(R,TR); 
        end; 
        figure('color' , 'white')
        histogram(R.pressTime(R.stimulus==R.response , :)); 
        hold on
        histogram(R.pressTime(R.stimulus~=R.response , :)); 
        legend({'Correct Trials', 'Error Trials'})
        title('Distribution of Press Times')
        
        
        keyboard; 
        
end