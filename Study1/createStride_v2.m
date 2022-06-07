function [] = createStride_v2(optimumOutput,fileName_mot,fileName_act,translate)

    dummyFile_mot = readMOT(fileName_mot);

    %import casadi.*
    
    %d = 3; % degree of interpolating polynomial
    %method = 'radau'; % collocation method
    %tau_root = CollocationScheme(d,method);

    %h = optimumOutput.optVars_nsc.totalTime./optimumOutput.options.N;
    timeGrid = optimumOutput.timeGrid - optimumOutput.timeGrid(1);
    %timeNodes = optimumOutput.timeNodes;
    timeGrid_dummy = timeGrid + timeGrid(end);
    
    timeGrid(end) = [];
    %timeNodes(end) = [];
    
    %d = 3;
    
    %timeNodes_dummy = linspace(timeGrid(end),...
    %    timeGrid(end)+optimumOutput.optVars_nsc.totalTime,optimumOutput.options.N+1);
    
    %stride_timeNodes = [timeNodes timeNodes_dummy];
    
    %for k = 1:optimumOutput.options.N*2
    %    for kk = 1:d+1
    %        stride_timeGrid(k,kk) = stride_timeNodes(k) + h*tau_root(kk);
    %    end
    %end
    
    %stride_timeGrid = stride_timeGrid';
    %stride_timeGrid = stride_timeGrid(:);
    
    stride_timeGrid = [timeGrid; timeGrid_dummy];
    
    q = optimumOutput.optVars_nsc.q';
    q_orig = q;
    
    q_sym = q;
    q(end,:) = [];
    
    stride_q = [q;q_sym];
    
    stride_q(length(timeGrid)+1:end,7:13) = q_orig(1:end,14:20);
    stride_q(length(timeGrid)+1:end,14:20) = q_orig(1:end,7:13);
   
    stride_q(length(timeGrid)+1:end,5:6) = q_orig(1:end,5:6);
    stride_q(length(timeGrid)+1:end,[1,21]) = q_orig(1:end,[1,21]);

    stride_q(length(timeGrid)+1:end,24:30) = q_orig(1:end,31:37);
    stride_q(length(timeGrid)+1:end,31:37) = q_orig(1:end,24:30);
    
    stride_q(length(timeGrid)+1:end,[2:3,22:23]) = -q_orig(1:end,[2:3,22:23]);    
    stride_q(length(timeGrid)+1:end,4) = stride_q(length(timeGrid)+1:end,4) + abs(q_orig(1,4)) + abs(q_orig(end,4));
    
    stride_q(:,[1:3,7:37]) = rad2deg(stride_q(:,[1:3,7:37]));
    
    if translate == 'N'
        stride_q(:,4) = 0;
    end
    
    motData.labels = dummyFile_mot.labels;
    motData.data   = [stride_timeGrid stride_q];
    
    write_motionFile(motData,['symmetric_stride_' fileName_mot]);
    
    if nargin == 3
        
        dummyFile_act = readMOT(fileName_act);
                
        act = optimumOutput.optVars_nsc.act';
        act_orig = act;
        
        act_sym = act;
        act(end,:) = [];
        
        stride_act = [act; act_sym];
        
        stride_act(length(timeGrid)+1:end,1:46) = act_orig(1:end,47:end);
        stride_act(length(timeGrid)+1:end,47:end) = act_orig(1:end,1:46);
        
        actData.labels = dummyFile_act.labels;
        actData.data   = [stride_timeGrid stride_act];
        
        write_storageFile(actData,['symmetric_stride_' fileName_act]);

    end


end