function [T,SIM]=slm_simTrialCap(M,T,varargin);
% function [T,SIM]=slm_simTrial(M,T);
% Simulates a trial using a parallel evidence-accumulation model 
% for sequential response tasks 

dT = 2;     % delta-t in ms
maxTime = 10000; % Maximal time for trial simulation 
vararginoptions(varargin,{'dT','maxTime'}); 
% Determine length of the trial 
maxPresses = max(T.numPress); 

% number of decision steps is defined by the number of stimuli devided by capacity
if isfield(T , 'Horizon') && T.Horizon<M.capacity
    dec=1: max(ceil(maxPresses/M.capacity) , ceil(maxPresses/T.Horizon));  % Number of decision
    T.stimTime(T.Horizon+1:end) = NaN;
    maxPlan = min(M.capacity , T.Horizon);
else
    dec=1: ceil(maxPresses/M.capacity);  % Number of decision
end

decSteps = max(dec);

% initialize variables 
X = zeros(M.numOptions,maxTime/dT,maxPresses); % Hidden state 
S = zeros(M.numOptions,maxTime/dT,maxPresses); % Stimulus present 
B = ones(1,maxTime/dT)*M.Bound;                % Decision Bound - constant value 
t = [1:maxTime/dT]*dT-dT;   % Time in ms  
i = 1;                    % Index of simlation 
nDecision = 1;           % Current decision to male 
numPresses = 0;          % Number of presses produced 
isPressing = 0;          % Is the motor system currently occupied? 
remPress = maxPresses;            % Remaining presses
% Set up parameters 
 linDecay=(1/(1-max(dec)))*(dec-max(dec));  % How much stimulus linear decay
A  = eye(M.numOptions)*(M.Aintegrate-M.Ainhibit)+...
     ones(M.numOptions)*M.Ainhibit; 

% Start time-by-time simulation 

while remPress && i<maxTime/dT
    mult = zeros(1,length(dec));
    % Update the stimulus: Fixed stimulus time
    indx = find(t(i)>(T.stimTime+M.dT_visual)); % Index of which stimuli are present T.
    for j=indx'
        S(T.stimulus(j),i,j)=1;
    end;
    
    % Update the evidence state
    eps = randn([M.numOptions 1 maxPresses]) * M.SigEps;
%     mult=exp(-[dec-nDecision]./maxPlan);  % How much stimulus exponentia decay
    mult(nDecision:end) = linDecay(1:max(dec)-nDecision+1);
    mult(dec<nDecision)=0;                  % Made decisions will just decay
    for j =1:maxPresses
        X(:,i+1,j)= A * X(:,i,j) + M.theta_stim .* mult(ceil(j/maxPlan)) .* S(:,i,j) + dT*eps(:,1,j);
    end
    % Determine if we issue a decision
    
    indx1= nDecision * maxPlan - (maxPlan-1):min(nDecision * maxPlan , maxPresses);
    hit_thresh = 0;
    if ~isPressing && sum(sum(squeeze(X(:,i+1,indx1))>B(i+1))) == length(indx1)
        count = 1;
        for prs = indx1
            [~,T.response(prs,1)]=max(X(:,i+1,prs));
            T.decisionTime(prs,1) = t(i+1);                            % Decision made at this time
            T.pressTime(prs,1) = T.decisionTime(prs)+count*M.dT_motor; % Press time delayed by motor delay
            if sum(isnan(T.stimTime))
                idx2  = find(isnan(T.stimTime));
                T.stimTime(idx2(1)) = T.pressTime(prs,1);
            end
            isPressing = 1;                % Motor system engaged
            count = count+1;
        end
    end;
    
    % Update the motor system: Checking if current movement is done
    if (isPressing)
        if (t(i+1))>=T.pressTime(prs)
            isPressing = 0;
            remPress = remPress - maxPlan;
            nDecision = nDecision+1;       % Waiting for the next decision
        end; 
    end 
    i=i+1; 
end; 
tmax = T.pressTime(maxPresses);
i = find(t == tmax);
if (nargout>1)
    SIM.X = X(:,1:i-1,:); % Hidden state
    SIM.S = S(:,1:i-1,:); % Stimulus present
    SIM.B = B(1,1:i-1);     % Bound
    SIM.t = t(1,1:i-1);    % Time
end;
