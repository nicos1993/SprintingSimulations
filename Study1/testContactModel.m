clc

import casadi.*

% Path of main folder repository
pathmain = pwd; % Print Working Directory


outInd.r_contGRF      = 38:58;
outInd.l_contGRF      = 59:79;
outInd.tibia_l_toes_r_mag  = 121;
outInd.tibia_r_toes_l_mag  = 122;




%% Load optimised contact model parameters & non-optimised frictional parameters
contPrms = load('Sph_Plane_simultOptContPrms_Fmax_2_Vmax_12.mat');
mu_s = 0.95;
mu_d = 0.3;
mu_v = 0.3;
tv   = 0.001;
contPrms_nsc = [contPrms.simultOptContPrms; mu_s; mu_d; mu_v; tv];
contPrms_nsc = repmat(contPrms_nsc,1,8);

scaling_vec = [0.1 1 2 5 8 10 100 1000];

contPrms_nsc(20,:) = contPrms_nsc(20,:).*scaling_vec;

%% Load External Function
pathExternalFuncs = [erase(pathmain,'\Study1'),'\ExternalFunctions\'];

% Change directory to load functions
cd(pathExternalFuncs);

% Implicit inverse dynamics, both feet, air drag
% Input: positions,velocities,accelerations,contact parameters
% Output: residuals & joint moments,contact GRFs,plus additional outputs
%         (see below for indices)
F_cont = external('F_cont','Spr_Imp_GRFs_ownCont_V2.dll');

F_cont_ana = external('F_cont_ana','Spr_Imp_GRFs_ownCont_V2an.dll');

% Change directory back to main directory
cd(pathmain);


% File
load('pred_Sprinting_matching_50_meshInts_optimum_p02_maxVel_01_06-July-2022__22-11-15.mat');

d = 3;
nq.all = 37;



dFTtilde  = optimumOutput.optVars_nsc.dFTtilde(:,2:end);
uActdot   = optimumOutput.optVars_nsc.uActdot(:,2:end);
uAcc      = optimumOutput.optVars_nsc.uAcc(:,2:end);
uReserves = optimumOutput.optVars_nsc.uReserves(:,2:end);
armExct   = optimumOutput.optVars_nsc.armExcts(:,2:end);

for ii = 1:length(scaling_vec)
    
    optimumOutput.optVars_nsc.q(:,:) = 0;
    optimumOutput.optVars_nsc.qdot(:,:) = 0;
    
    optimumOutput.optVars_nsc.q(5,:) = 0.92;
    
    for k = 0:optimumOutput.options.N-1

        Xk_nsc       = [optimumOutput.optVars_nsc.q(:,1+k*(d+1)); optimumOutput.optVars_nsc.qdot(:,1+k*(d+1))];
        %Xk_nsc(:,1) = 0;
        actk_nsc     = [optimumOutput.optVars_nsc.act(:,1+k*(d+1))];
        FTtildek_nsc = [optimumOutput.optVars_nsc.FTtilde(:,1+k*(d+1))];
        armActsk_nsc = [optimumOutput.optVars_nsc.armActs(:,1+k*(d+1))];

        if k == 0
            Xk_nsc_ini       = Xk_nsc;                
            actk_nsc_ini     = actk_nsc;
            FTtildek_nsc_ini = FTtildek_nsc;
            armActsk_nsc_ini = armActsk_nsc; 
        end

        Xkj_nsc = {};
        for j=1:d
            Xkj_nsc{j} = [optimumOutput.optVars_nsc.q(:,k*(d+1)+1+j); optimumOutput.optVars_nsc.qdot(:,k*(d+1)+1+j)];
        end

        actkj_nsc = {};
        for j=1:d
            actkj_nsc{j} = [optimumOutput.optVars_nsc.act(:,k*(d+1)+1+j)];
        end

        FTtildekj_nsc = {};
        for j=1:d
            FTtildekj_nsc{j} = [optimumOutput.optVars_nsc.FTtilde(:,k*(d+1)+1+j)];
        end

        armActskj_nsc = {};
        for j=1:d
            armActskj_nsc{j} = [optimumOutput.optVars_nsc.armActs(:,k*(d+1)+1+j)];
        end

        dFTtildekj_nsc = {};
        for j=1:d
            dFTtildekj_nsc{j} = [dFTtilde(:,k*d+j)];
        end

        uActdotkj_nsc = {};
        for j=1:d
            uActdotkj_nsc{j} = [uActdot(:,k*d+j)];
        end

        uAcckj_nsc = {};
        for j=1:d
            uAcckj_nsc{j} = [uAcc(:,k*d+j)];
        end

        uReserveskj_nsc = {};
        for j=1:d
            uReserveskj_nsc{j} = [uReserves(:,k*d+j)];
        end

        armExctkj_nsc = {};
        for j=1:d
            armExctkj_nsc{j} = [armExct(:,k*d+j)];
        end

                if k == 0

                    dFTtilde_nsc_ini  = optimumOutput.optVars_nsc.dFTtilde(:,1);
                    uActdot_nsc_ini   = optimumOutput.optVars_nsc.uActdot(:,1);
                    uAcc_nsc_ini      = optimumOutput.optVars_nsc.uAcc(:,1);
                    uReserves_nsc_ini = optimumOutput.optVars_nsc.uReserves(:,1);
                    armExct_nsc_ini   = optimumOutput.optVars_nsc.armExcts(:,1);

                    % Reorder the skeleton states as q1 u1 q2 u2...
                    % For compatibility with F function
                    Xk_nsc_ORD = zeros(nq.all*2,1);
                    for i = 0:nq.all-1
                        Xk_nsc_ORD(i+1*(i+1),1) = Xk_nsc_ini(i+1,1);
                        Xk_nsc_ORD(2*(i+1),1)   = Xk_nsc_ini(nq.all+i+1,1);
                    end

                    % Evaluate F Function 
                    % Evaluation returns residuals, joint torques 
                    % and GRFs from contact model
                    % Output used later
                    outputF = F_cont_ana([Xk_nsc_ORD;uAcc_nsc_ini;contPrms_nsc(:,ii) ]);
                    outputF_ini = full(outputF);

                    % Contact model GRFs; right then left
                    xGRFk_r(1,ii) = sum(full(outputF(outInd.r_contGRF(1):3:outInd.r_contGRF(end)-2)));
                    yGRFk_r(1,ii) = sum(full(outputF(outInd.r_contGRF(1)+1:3:outInd.r_contGRF(end)-1)));
                    yGRFk_r1(1,ii) = full(outputF(outInd.r_contGRF(1)+1));
                    yGRFk_r2(1,ii) = full(outputF(outInd.r_contGRF(1)+4));
                    yGRFk_r3(1,ii) = full(outputF(outInd.r_contGRF(1)+7));
                    yGRFk_r4(1,ii) = full(outputF(outInd.r_contGRF(1)+10));
                    yGRFk_r5(1,ii) = full(outputF(outInd.r_contGRF(1)+13));
                    yGRFk_r6(1,ii) = full(outputF(outInd.r_contGRF(1)+16));
                    yGRFk_r7(1,ii) = full(outputF(outInd.r_contGRF(1)+19));
                    zGRFk_r(1,ii) = sum(full(outputF(outInd.r_contGRF(1)+2:3:outInd.r_contGRF(end))));            

                    xGRFk_l(1,ii) = sum(full(outputF(outInd.l_contGRF(1):3:outInd.l_contGRF(end)-2)));
                    yGRFk_l(1,ii) = sum(full(outputF(outInd.l_contGRF(1)+1:3:outInd.l_contGRF(end)-1)));
                    zGRFk_l(1,ii) = sum(full(outputF(outInd.l_contGRF(1)+2:3:outInd.l_contGRF(end))));
                    
                    tibia_l_toes_r_mag(1,ii) = full(outputF(outInd.tibia_l_toes_r_mag));
                    tibia_r_toes_l_mag(1,ii) = full(outputF(outInd.tibia_r_toes_l_mag));

                end

        for j=1:d

            index = j+(k*d)+1; 

            % Reorder the skeleton states as q1 u1 q2 u2...
            % For compatibility with F function
            Xkj_nsc_ORD = zeros(nq.all*2,1);
            for i = 0:nq.all-1
                Xkj_nsc_ORD(i+1*(i+1),1) = Xkj_nsc{j}(i+1,1);
                Xkj_nsc_ORD(2*(i+1),1)   = Xkj_nsc{j}(nq.all+i+1,1);
            end

            % Evaluate F Function 
            % Evaluation returns residuals, joint torques 
            % and GRFs from contact model
            % Output used later
            outputF = F_cont_ana([Xkj_nsc_ORD;uAcckj_nsc{j};contPrms_nsc(:,ii) ]);

            % Contact model GRFs; right then left
            xGRFk_r(index,ii) = sum(full(outputF(outInd.r_contGRF(1):3:outInd.r_contGRF(end)-2)));
            yGRFk_r(index,ii) = sum(full(outputF(outInd.r_contGRF(1)+1:3:outInd.r_contGRF(end)-1))); 
            yGRFk_r1(index,ii) = full(outputF(outInd.r_contGRF(1)+1));
            yGRFk_r2(index,ii) = full(outputF(outInd.r_contGRF(1)+4));
            yGRFk_r3(index,ii) = full(outputF(outInd.r_contGRF(1)+7));
            yGRFk_r4(index,ii) = full(outputF(outInd.r_contGRF(1)+10));
            yGRFk_r5(index,ii) = full(outputF(outInd.r_contGRF(1)+13));
            yGRFk_r6(index,ii) = full(outputF(outInd.r_contGRF(1)+16));
            yGRFk_r7(index,ii) = full(outputF(outInd.r_contGRF(1)+19));
            zGRFk_r(index,ii) = sum(full(outputF(outInd.r_contGRF(1)+2:3:outInd.r_contGRF(end))));            

            xGRFk_l(index,ii) = sum(full(outputF(outInd.l_contGRF(1):3:outInd.l_contGRF(end)-2)));
            yGRFk_l(index,ii) = sum(full(outputF(outInd.l_contGRF(1)+1:3:outInd.l_contGRF(end)-1)));
            zGRFk_l(index,ii) = sum(full(outputF(outInd.l_contGRF(1)+2:3:outInd.l_contGRF(end))));
            
            tibia_l_toes_r_mag(index,ii) = full(outputF(outInd.tibia_l_toes_r_mag));
            tibia_r_toes_l_mag(index,ii) = full(outputF(outInd.tibia_r_toes_l_mag));
            
            if k == 0 
                outputF_change = full(outputF);
            end

        end

    end
    
end


pause;  