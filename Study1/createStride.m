function [] = createStride(optimumOutput,fileName_mot,fileName_act)

    dummyFile_mot = readMOT(fileName_mot);

    import casadi.*
    
    d = 3; % degree of interpolating polynomial
    method = 'radau'; % collocation method
    tau_root = CollocationScheme(d,method);

    h = optimumOutput.optVars_nsc.totalTime./optimumOutput.options.N;
    timeGrid = optimumOutput.timeGrid;
    timeNodes = optimumOutput.timeNodes;
    
    timeGrid(end) = [];
    timeNodes(end) = [];
    
    d = 3;
    
    timeNodes_dummy = linspace(timeGrid(end),...
        timeGrid(end)+optimumOutput.optVars_nsc.totalTime,optimumOutput.options.N+1);
    
    stride_timeNodes = [timeNodes timeNodes_dummy];
    
    for k = 1:optimumOutput.options.N*2
        for kk = 1:d+1
            stride_timeGrid(k,kk) = stride_timeNodes(k) + h*tau_root(kk);
        end
    end
    
    stride_timeGrid = stride_timeGrid';
    stride_timeGrid = stride_timeGrid(:);
    
    
    q = optimumOutput.optVars_nsc.q';
    q(end,:) = [];
    
    q_sym = q;
    
    stride_q = [q;q_sym];
    
    stride_q(length(timeGrid)+1:end,7:13) = q(1:end,14:20);
    stride_q(length(timeGrid)+1:end,14:20) = q(1:end,7:13);
   
    stride_q(length(timeGrid)+1:end,5:6) = q(1:end,5:6);
    stride_q(length(timeGrid)+1:end,[1,21]) = q(1:end,[1,21]);

    stride_q(length(timeGrid)+1:end,24:30) = q(1:end,31:37);
    stride_q(length(timeGrid)+1:end,31:37) = q(1:end,24:30);
    
    stride_q(length(timeGrid)+1:end,[2:3,22:23]) = -q(1:end,[2:3,22:23]);    
    stride_q(length(timeGrid)+1:end,4) = stride_q(length(timeGrid)+1:end,4) + abs(q(1,4)) + abs(q(end,4));
    
    stride_q(:,[1:3,7:37]) = rad2deg(stride_q(:,[1:3,7:37]));
    
    motData.labels = dummyFile_mot.labels;
    motData.data   = [stride_timeGrid stride_q];
    
    write_motionFile(motData,'pred_Sprinting_symmetric_stride.mot');
    
    if nargin == 3
        
        dummyFile_act = readMOT(fileName_act);
                
        act = optimumOutput.optVars_nsc.act';
        act(end,:) = [];
        
        act_sym = act;
        
        stride_act = [act; act_sym];
        
        stride_act(length(timeGrid)+1:end,1:46) = act(1:end,47:end);
        stride_act(length(timeGrid)+1:end,47:end) = act(1:end,1:46);
        
        actData.labels = dummyFile_act.labels;
        actData.data   = [stride_timeGrid stride_act];
        
        write_storageFile(actData,'pred_Sprinting_symmetric_stride_act.sto');

    end


end