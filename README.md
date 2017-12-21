# SequenceLearningModel
# Modelling of Sequence production and learning 

All the changes that I’ve made are accessible in my branch of the project.
I used the core function: slm_simTrial as the template, and created a modified version of it: slm_simTrialCap, which incorporates buffer sizes of more than 1 and horizon size.

The number of decision making processes  for a sequence of length N, with buffer size C (M.capacity) and horizon size H (T.Horizon) is defined by: max(ceil(N/C) , ceil(N/H));  
The idea is that all the digits within the range of the buffer (or horizon, whichever is smaller) will all be planned in one decision making process, and the motor command(s) will not be issued unless all the presses to be planned have hit the decision boundary.
slm_simTrial function is the exact same as the upstream master for comparison.
For M.capacity = 1 , the functions slm_simTrial and slm_simTrialCap will be the same.
I have also made some changes to the slm_plotTrial and slm_testModel in my branch.
# Problems to be fixed: 
buffer size 1 shows the fastest MT compared to higher buffersizes, which considering the data, shouldn't be the case.

Reason: 
when planning more than 1 digit at the same time, the execution command is not issued unless all the digits within planning range hit the boundary at the same time. This can take considerable longer than one digit, since out of N digits that are being planned even if 1 is not above threshold, the horserace has to continue for all.

Possible Solutions:
1 -  lower the noise SD exponentially when planning more than 1 digits
2-  boost the information integration rate


# Important note1 : 
I added the field Horizon to the T structure in the slm_testModel function. Therefore we don’t need the T.stimtime to be set to e.g. -1 or -2. Since the T.Horizon = 2 for example, means that each stimulus will come up when 2 digits behind it has been pressed. So I use T.stimTime to denote the actual time the stimuli came on in the slm_simTrialCap. If Horizon = full, T.stimTime would be all zeros.

# Important note2 : 
I changed the indexing within the T structure, so that each trail is added as a row (used to be column which made stacking them up weird), so beware that in function slm_simTrial, line 33, transpose (‘) has been removed from index.

# Important note3 : 
in my simulations I cranked up the integration rate to 0.5 to speed up batch trial simulations.

# Important note4 : 
the data structure slm_CapHorz.mat is generated and saved for seqLength = 10,  with horizon sizes between [1:9] and buffer sizes between [1:7], . load it up, and Run slm_plotTrial(‘BlockMT’ , SIM ,R) to see MT.


