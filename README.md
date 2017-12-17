# SequenceLearningModel
Modelling of Sequence production and learning 
I added the function slm_simTrialCap, which takes into account the buffer size, as defined in M.capacity, to plan multiple digits at a time.
for example with 5 presses in the sequences, and M.capacity = 2, there will be 3 planning steps : presses 1,2 - presses 3,4 , press 5
The xecution does not get initiated, unless all the presses within the planning horizon hit the decision boundry.
