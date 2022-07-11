clear
clc

opt_fname = 'pred_Sprinting_matching_50_meshInts_optimum_20-June-2022__10-36-23_p02_maxVel_01.mot';
nom_fname = 'Splined_50_meshInts_p02_maxVel_01.mot';
nom_grf_fname = 'p02_m_01_labelled_grf.mot';

opt_f_mat = load('pred_Sprinting_matching_50_meshInts_optimum_p02_maxVel_01_20-June-2022__10-36-23.mat');
opt_f_mat1 = load('pred_Sprinting_matching_50_meshInts_optimum_p02_maxVel_01_08-July-2022__02-28-24.mat');
%opt_f_mat = opt_f_mat1;

opt_act_fname = 'symmetric_stride_pred_Sprinting_matching_acts_50_meshInts_optimum_20-June-2022__10-36-23.sto';

exp_data = load('ID_max_v_01.mat');




opt_f = readMOT(opt_fname);
nom_f = readMOT(nom_fname);
nom_grf_f = readMOT(nom_grf_fname);
opt_act = readMOT(opt_act_fname);
opt_act.data(:,1) = opt_act.data(:,1) + opt_f.data(1,1);

opt_data = opt_f.data;
nom_data = nom_f.data;
nom_grf_data = nom_grf_f.data;
idx_grf_start = find(nom_grf_data(:,1) == nom_data(1,1));
[~,idx_grf_end] = min(abs(nom_grf_data(:,1)-nom_data(end,1)));

opt_takeoff_frame = find(opt_f_mat.optimumOutput.GRFs.R(10:end,2) < 20,1) + 8;
opt_takeoff_time = opt_f_mat.optimumOutput.timeNodes(opt_takeoff_frame);
[~,opt_takeoff_kin_ind] = min(abs(opt_data(:,1) - opt_takeoff_time));
opt_takeoff_act_ind = find(opt_act.data(:,1) == opt_data(opt_takeoff_kin_ind,1));

% Calculate contact time

% Raw GRF
raw_index_start = idx_grf_start+3;
raw_index_end = find(nom_grf_data(idx_grf_start+5:end,30)<20,1)+idx_grf_start-2+5;
raw_tc = nom_grf_data(find(nom_grf_data(idx_grf_start+5:end,30)<20,1)+idx_grf_start-2+5,1) - nom_grf_data(idx_grf_start+3,1);

% Filtered GRF
filt_index_start = 1;
filt_index_end = find(exp_data.intGRF(:,2)<20,1);
filt_tc = exp_data.timeGrid(find(exp_data.intGRF(:,2)<20,1)) - exp_data.timeGrid(1,1);

% Predictive GRF
opt_index_start = 1;
opt_index_end = find(opt_f_mat.optimumOutput.GRFs.R(10:end,2)<20,1)+8;
opt_tc = opt_f_mat.optimumOutput.timeNodes(find(opt_f_mat.optimumOutput.GRFs.R(10:end,2)<20,1)+8,1)-opt_f_mat.optimumOutput.timeNodes(1,1);

opt_index_start1 = 1;
opt_index_end1 = find(opt_f_mat1.optimumOutput.GRFs.R(10:end,2)<20,1)+8;
opt_tc1 = opt_f_mat1.optimumOutput.timeNodes(find(opt_f_mat1.optimumOutput.GRFs.R(10:end,2)<20,1)+8,1)-opt_f_mat1.optimumOutput.timeNodes(1,1);

% Calculate vertical impulse

% Raw GRF
raw_impulse = trapz(nom_grf_data(raw_index_start:raw_index_end,1),nom_grf_data(raw_index_start:raw_index_end,30));

% Filtered GRF
filt_impulse = trapz(exp_data.timeGrid(filt_index_start:filt_index_end,1),exp_data.intGRF(filt_index_start:filt_index_end,2));

% Predictive GRF
opt_impulse = trapz(opt_f_mat.optimumOutput.timeNodes(opt_index_start:opt_index_end,1),opt_f_mat.optimumOutput.GRFs.R(opt_index_start:opt_index_end,2));
opt_impulse1 = trapz(opt_f_mat1.optimumOutput.timeNodes(opt_index_start1:opt_index_end1,1),opt_f_mat1.optimumOutput.GRFs.R(opt_index_start1:opt_index_end1,2));


musclesNames = {'glut_med1_l','glut_med2_l','glut_med3_l',...
        'glut_min1_l','glut_min2_l','glut_min3_l','semimem_l',...
        'semiten_l','bifemlh_l','bifemsh_l','sar_l','add_long_l',...
        'add_brev_l','add_mag1_l','add_mag2_l','add_mag3_l','tfl_l',...
        'pect_l','grac_l','glut_max1_l','glut_max2_l','glut_max3_l',......
        'iliacus_l','psoas_l','quad_fem_l','gem_l','peri_l',...
        'rect_fem_l','vas_med_l','vas_int_l','vas_lat_l','med_gas_l',...
        'lat_gas_l','soleus_l','tib_post_l','flex_dig_l','flex_hal_l',...
        'tib_ant_l','per_brev_l','per_long_l','per_tert_l','ext_dig_l',...
        'ext_hal_l','ercspn_l','intobl_l','extobl_l'...
            'glut_med1_r','glut_med2_r','glut_med3_r',...
        'glut_min1_r','glut_min2_r','glut_min3_r','semimem_r',...
        'semiten_r','bifemlh_r','bifemsh_r','sar_r','add_long_r',...
        'add_brev_r','add_mag1_r','add_mag2_r','add_mag3_r','tfl_r',...
        'pect_r','grac_r','glut_max1_r','glut_max2_r','glut_max3_r',......
        'iliacus_r','psoas_r','quad_fem_r','gem_r','peri_r',...
        'rect_fem_r','vas_med_r','vas_int_r','vas_lat_r','med_gas_r',...
        'lat_gas_r','soleus_r','tib_post_r','flex_dig_r','flex_hal_r',...
        'tib_ant_r','per_brev_r','per_long_r','per_tert_r','ext_dig_r',...
        'ext_hal_r','ercspn_r','intobl_r','extobl_r'};
    
ind_gmax_r_1 = find(convertCharsToStrings(musclesNames) == 'glut_max1_r') + 1;
ind_gmax_r_2 = find(convertCharsToStrings(musclesNames) == 'glut_max2_r') + 1;
ind_gmax_r_3 = find(convertCharsToStrings(musclesNames) == 'glut_max3_r') + 1;
ind_tfl_r    = find(convertCharsToStrings(musclesNames) == 'tfl_r') + 1;
ind_rf_r     = find(convertCharsToStrings(musclesNames) == 'rect_fem_r') + 1;
ind_vm_r     = find(convertCharsToStrings(musclesNames) == 'vas_med_r') + 1;
ind_vl_r     = find(convertCharsToStrings(musclesNames) == 'vas_lat_r') + 1;
ind_st_r     = find(convertCharsToStrings(musclesNames) == 'semiten_r') + 1;
ind_bf_r     = find(convertCharsToStrings(musclesNames) == 'bifemlh_r') + 1;
ind_ta_r     = find(convertCharsToStrings(musclesNames) == 'tib_ant_r') + 1;
ind_gm_r     = find(convertCharsToStrings(musclesNames) == 'med_gas_r') + 1;
ind_gl_r     = find(convertCharsToStrings(musclesNames) == 'lat_gas_r') + 1;
ind_so_r     = find(convertCharsToStrings(musclesNames) == 'soleus_r') + 1;

ham_vert1 = [opt_act.data(1,1) opt_act.data(round(0.21*(length(opt_act.data(:,1)))),1) opt_act.data(round(0.21*(length(opt_act.data(:,1)))),1) opt_act.data(1,1); 0 0 1 1];
ham_vert2 = [opt_act.data(round(0.71*(length(opt_act.data(:,1)))),1) opt_act.data(end,1) opt_act.data(end,1) opt_act.data(round(0.71*(length(opt_act.data(:,1)))),1); 0 0 1 1];
rf_vert1 = [opt_act.data(1,1) opt_act.data(round(0.16*(length(opt_act.data(:,1)))),1) opt_act.data(round(0.16*(length(opt_act.data(:,1)))),1) opt_act.data(1,1); 0 0 1 1];
rf_vert2 = [opt_act.data(round(0.35*(length(opt_act.data(:,1)))),1) opt_act.data(round(0.62*(length(opt_act.data(:,1)))),1) opt_act.data(round(0.62*(length(opt_act.data(:,1)))),1) opt_act.data(round(0.35*(length(opt_act.data(:,1)))),1); 0 0 1 1];
rf_vert3 = [opt_act.data(round(0.88*(length(opt_act.data(:,1)))),1) opt_act.data(end,1) opt_act.data(end,1) opt_act.data(round(0.88*(length(opt_act.data(:,1)))),1); 0 0 1 1];
vl_vert1 = [opt_act.data(1,1) opt_act.data(round(0.22*(length(opt_act.data(:,1)))),1) opt_act.data(round(0.22*(length(opt_act.data(:,1)))),1) opt_act.data(1,1); 0 0 1 1];
vl_vert2 = [opt_act.data(round(0.78*(length(opt_act.data(:,1)))),1) opt_act.data(end,1) opt_act.data(end,1) opt_act.data(round(0.78*(length(opt_act.data(:,1)))),1); 0 0 1 1];
gmax_vert1 = [opt_act.data(1,1) opt_act.data(round(0.15*(length(opt_act.data(:,1)))),1) opt_act.data(round(0.15*(length(opt_act.data(:,1)))),1) opt_act.data(1,1); 0 0 1 1];
gmax_vert2 = [opt_act.data(round(0.76*(length(opt_act.data(:,1)))),1) opt_act.data(end,1) opt_act.data(end,1) opt_act.data(round(0.76*(length(opt_act.data(:,1)))),1); 0 0 1 1];
gas_vert1 = [opt_act.data(1,1) opt_act.data(round(0.19*(length(opt_act.data(:,1)))),1) opt_act.data(round(0.19*(length(opt_act.data(:,1)))),1) opt_act.data(1,1); 0 0 1 1];
gas_vert2 = [opt_act.data(round(0.76*(length(opt_act.data(:,1)))),1) opt_act.data(end,1) opt_act.data(end,1) opt_act.data(round(0.76*(length(opt_act.data(:,1)))),1); 0 0 1 1];
sol_vert1 = [opt_act.data(1,1) opt_act.data(round(0.28*(length(opt_act.data(:,1)))),1) opt_act.data(round(0.28*(length(opt_act.data(:,1)))),1) opt_act.data(1,1); 0 0 1 1];
sol_vert2 = [opt_act.data(round(0.80*(length(opt_act.data(:,1)))),1) opt_act.data(end,1) opt_act.data(end,1) opt_act.data(round(0.80*(length(opt_act.data(:,1)))),1); 0 0 1 1];
tib_vert1 = [opt_act.data(1,1) opt_act.data(round(0.16*(length(opt_act.data(:,1)))),1) opt_act.data(round(0.16*(length(opt_act.data(:,1)))),1) opt_act.data(1,1); 0 0 1 1];
tib_vert2 = [opt_act.data(round(0.52*(length(opt_act.data(:,1)))),1) opt_act.data(end,1) opt_act.data(end,1) opt_act.data(round(0.52*(length(opt_act.data(:,1)))),1); 0 0 1 1];





%scatter(opt_data(:,11),nom_data(:,11))
%%
subplot(4,4,1)
plot(opt_data(:,1),opt_data(:,8),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,8)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['R Hip Flex (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,8),nom_data(:,8));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,2)
plot(opt_data(:,1),opt_data(:,11),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,11)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['R Knee Ext (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,11),nom_data(:,11));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,3)
plot(opt_data(:,1),opt_data(:,12),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,12)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
ylabel(['R Ankle Dflex (', char(0176), ')'],'fontweight','bold')
r = corrcoef(opt_data(:,12),nom_data(:,12));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,4)
plot(opt_data(:,1),opt_data(:,15),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,15)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['L Hip Flex (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,15),nom_data(:,15));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,5)
plot(opt_data(:,1),opt_data(:,18),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,18)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['L Knee Ext (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,18),nom_data(:,18));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,6)
plot(opt_data(:,1),opt_data(:,19),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,19)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['L Ankle Dflex (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,19),nom_data(:,19));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,7)
plot(opt_data(:,1),opt_data(:,22),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,22)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['Trunk Ext (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,22),nom_data(:,22));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,8)
plot(opt_data(:,1),opt_data(:,5),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),(nom_data(:,5)-nom_data(1,5))','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['Pelvis Ant-Post (m)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,5),nom_data(:,5));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,9)
plot(opt_data(:,1),opt_data(:,6),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,6)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['Pelvis Vert (m)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,6),nom_data(:,6));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,10)
plot(opt_data(:,1),opt_data(:,25),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,25)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['R Sho Flex (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,25),nom_data(:,25));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,11)
plot(opt_data(:,1),opt_data(:,28),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,28)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['R Elb Flex (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,28),nom_data(:,28));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,12)
plot(opt_data(:,1),opt_data(:,32),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,32)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['L Sho Flex (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,32),nom_data(:,32));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,13)
plot(opt_data(:,1),opt_data(:,35),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,35)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['L Elb Flex (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,35),nom_data(:,35));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
legend('Pred','IK','location','best')
legend('boxoff')
set(gca,'linewidth',1.0)

% subplot(4,4,14)
% plot(opt_data(:,1),opt_f_mat.optimumOutput.GRFs.R,'linewidth',1.5,'color','r');
% hold on
% plot(nom_data(:,1),nom_data(:,15)','linewidth',1.5,'color','b');
% xlabel('Time (s)','fontweight','bold')
% ylabel(['L Hip Flex (', char(0176), ')'],'fontweight','bold')
% r = corrcoef(opt_data(:,15),nom_data(:,15));
% title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')

%%

subplot(4,4,1)
plot(opt_data(:,1),opt_data(:,2),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,2)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['Pelvis Tilt (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,2),nom_data(:,2));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,2)
plot(opt_data(:,1),opt_data(:,3),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,3)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['Pelvis List (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,3),nom_data(:,3));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,3)
plot(opt_data(:,1),opt_data(:,4),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,4)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
ylabel(['Pelvis Rot (', char(0176), ')'],'fontweight','bold')
r = corrcoef(opt_data(:,4),nom_data(:,4));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)



subplot(4,4,5)
plot(opt_data(:,1),opt_data(:,22),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,22)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['Trunk Ext (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,22),nom_data(:,22));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,6)
plot(opt_data(:,1),opt_data(:,23),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),(nom_data(:,23)-nom_data(1,5))','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['Trunk Bend (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,23),nom_data(:,23));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,7)
plot(opt_data(:,1),opt_data(:,24),'linewidth',1.5,'color','r');
hold on
plot(nom_data(:,1),nom_data(:,24)','linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['Trunk Rot (', char(0176), ')'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
r = corrcoef(opt_data(:,24),nom_data(:,24));
title(['R: ' num2str(round(r(1,2),3))],'linestyle','none','fontweight','bold')
set(gca,'linewidth',1.0)
legend('Pred','IK','location','best')
legend('boxoff')
set(gca,'linewidth',1.0)


%%

subplot(4,4,1)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.GRFs.R(:,1),'linewidth',1.5,'color','r');
hold on
plot(nom_grf_data(idx_grf_start:idx_grf_end,1),nom_grf_data(idx_grf_start:idx_grf_end,29),'linewidth',1.5,'color','b');
plot(opt_f_mat1.optimumOutput.timeNodes,opt_f_mat1.optimumOutput.GRFs.R(:,1),'linewidth',1.5,'color','k');
plot(exp_data.timeGrid,exp_data.intGRF(:,1),'linewidth',1.5,'color','g');
xlabel('Time (s)','fontweight','bold')
ylabel(['Ant-Post GRF (N)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
ylim([-1700 800])
set(gca,'linewidth',1.0)


subplot(4,4,2)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.GRFs.R(:,2),'linewidth',1.5,'color','r');
hold on
plot(nom_grf_data(idx_grf_start:idx_grf_end,1),nom_grf_data(idx_grf_start:idx_grf_end,30)','linewidth',1.5,'color','b');
plot(opt_f_mat1.optimumOutput.timeNodes,opt_f_mat1.optimumOutput.GRFs.R(:,2),'linewidth',1.5,'color','k');
plot(exp_data.timeGrid,exp_data.intGRF(:,2),'linewidth',1.5,'color','g');
xlabel('Time (s)','fontweight','bold')
ylabel(['Vert GRF (N)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
ylim([0 4000])
legend('Pred','Exp-raw','Exp-filt','location','east')
legend('boxoff')
set(gca,'linewidth',1.0)


%%

figure
subplot(4,4,1)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.muscleMoments.joints(7,:),'linewidth',1.5,'color','r');
hold on
plot(exp_data.timeGrid,exp_data.torques_ID(7,:),'linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['R Hip Flex (Nm)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
set(gca,'linewidth',1.0)

subplot(4,4,2)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.muscleMoments.joints(10,:),'linewidth',1.5,'color','r');
hold on
plot(exp_data.timeGrid,exp_data.torques_ID(10,:),'linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['R Knee Ext (Nm)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
set(gca,'linewidth',1.0)

subplot(4,4,3)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.muscleMoments.joints(11,:),'linewidth',1.5,'color','r');
hold on
plot(exp_data.timeGrid,exp_data.torques_ID(11,:),'linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
ylabel(['R Ankle Dflex (Nm)'],'fontweight','bold')
set(gca,'linewidth',1.0)

subplot(4,4,4)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.muscleMoments.joints(14,:),'linewidth',1.5,'color','r');
hold on
plot(exp_data.timeGrid,exp_data.torques_ID(14,:),'linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['L Hip Flex (Nm)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
legend('Pred','Exp-filt','location','best')
legend('boxoff')
set(gca,'linewidth',1.0)

subplot(4,4,5)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.muscleMoments.joints(17,:),'linewidth',1.5,'color','r');
hold on
plot(exp_data.timeGrid,exp_data.torques_ID(17,:),'linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['L Knee Ext (Nm)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
set(gca,'linewidth',1.0)

subplot(4,4,6)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.muscleMoments.joints(18,:),'linewidth',1.5,'color','r');
hold on
plot(exp_data.timeGrid,exp_data.torques_ID(18,:),'linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['L Ankle Dflex (Nm)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
set(gca,'linewidth',1.0)

subplot(4,4,7)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.muscleMoments.joints(21,:),'linewidth',1.5,'color','r');
hold on
plot(exp_data.timeGrid,exp_data.torques_ID(21,:),'linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['Trunk Ext (Nm)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
set(gca,'linewidth',1.0)

subplot(4,4,8)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.muscleMoments.joints(22,:),'linewidth',1.5,'color','r');
hold on
plot(exp_data.timeGrid,exp_data.torques_ID(22,:),'linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['Trunk Bend (Nm)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
set(gca,'linewidth',1.0)

subplot(4,4,9)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.muscleMoments.joints(23,:),'linewidth',1.5,'color','r');
hold on
plot(exp_data.timeGrid,exp_data.torques_ID(23,:),'linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['Trunk Rot (Nm)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
set(gca,'linewidth',1.0)

subplot(4,4,10)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.muscleMoments.joints(24,:),'linewidth',1.5,'color','r');
hold on
plot(exp_data.timeGrid,exp_data.torques_ID(24,:),'linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['R Sho Flex (Nm)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
set(gca,'linewidth',1.0)

subplot(4,4,11)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.muscleMoments.joints(27,:),'linewidth',1.5,'color','r');
hold on
plot(exp_data.timeGrid,exp_data.torques_ID(27,:),'linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['R Elb Flex (Nm)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
set(gca,'linewidth',1.0)

subplot(4,4,12)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.muscleMoments.joints(30,:),'linewidth',1.5,'color','r');
hold on
plot(exp_data.timeGrid,exp_data.torques_ID(30,:),'linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['L Sho Flex (Nm)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
set(gca,'linewidth',1.0)

subplot(4,4,13)
plot(opt_f_mat.optimumOutput.timeNodes,opt_f_mat.optimumOutput.muscleMoments.joints(33,:),'linewidth',1.5,'color','r');
hold on
plot(exp_data.timeGrid,exp_data.torques_ID(33,:),'linewidth',1.5,'color','b');
xlabel('Time (s)','fontweight','bold')
ylabel(['L Elb Flex (Nm)'],'fontweight','bold')
xlim([nom_data(1,1) nom_data(end,1)])
set(gca,'linewidth',1.0)




%%
subplot(3,4,1)
plot(opt_act.data(:,1),opt_act.data(:,ind_gmax_r_1),'linewidth',1.5,'color','r');
hold on
plot(opt_act.data(:,1),opt_act.data(:,ind_gmax_r_2),'linewidth',1.5,'color','g');
plot(opt_act.data(:,1),opt_act.data(:,ind_gmax_r_3),'linewidth',1.5,'color','b');
patch(gmax_vert1(1,:),gmax_vert1(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
patch(gmax_vert2(1,:),gmax_vert2(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
xlabel('Time (s)','fontweight','bold')
ylabel(['R Gmax Act (-)'],'fontweight','bold')
xlim([opt_act.data(1,1) opt_act.data(end,1)]) 
ylim([0 1])
set(gca,'linewidth',1.0)

subplot(3,4,2)
plot(opt_act.data(:,1),opt_act.data(:,ind_tfl_r),'linewidth',1.5,'color','r');
xlabel('Time (s)','fontweight','bold')
ylabel(['R Tfl Act (-)'],'fontweight','bold')
xlim([opt_act.data(1,1) opt_act.data(end,1)]) 
ylim([0 1])
set(gca,'linewidth',1.0)

subplot(3,4,3)
plot(opt_act.data(:,1),opt_act.data(:,ind_rf_r),'linewidth',1.5,'color','r');
xlabel('Time (s)','fontweight','bold')
ylabel(['R Rect F Act (-)'],'fontweight','bold')
patch(rf_vert1(1,:),rf_vert1(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
patch(rf_vert2(1,:),rf_vert2(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
patch(rf_vert3(1,:),rf_vert3(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
xlim([opt_act.data(1,1) opt_act.data(end,1)]) 
ylim([0 1])
set(gca,'linewidth',1.0)

subplot(3,4,4)
plot(opt_act.data(:,1),opt_act.data(:,ind_vm_r),'linewidth',1.5,'color','r');
xlabel('Time (s)','fontweight','bold')
ylabel(['R VM Act (-)'],'fontweight','bold')
xlim([opt_act.data(1,1) opt_act.data(end,1)]) 
ylim([0 1])
set(gca,'linewidth',1.0)

subplot(3,4,5)
plot(opt_act.data(:,1),opt_act.data(:,ind_vl_r),'linewidth',1.5,'color','r');
xlabel('Time (s)','fontweight','bold')
ylabel(['R VL Act (-)'],'fontweight','bold')
patch(vl_vert1(1,:),vl_vert1(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
patch(vl_vert2(1,:),vl_vert2(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
xlim([opt_act.data(1,1) opt_act.data(end,1)]) 
ylim([0 1])
set(gca,'linewidth',1.0)

subplot(3,4,6)
plot(opt_act.data(:,1),opt_act.data(:,ind_st_r),'linewidth',1.5,'color','r');
xlabel('Time (s)','fontweight','bold')
ylabel(['R ST Act (-)'],'fontweight','bold')
patch(ham_vert1(1,:),ham_vert1(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
patch(ham_vert2(1,:),ham_vert2(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
xlim([opt_act.data(1,1) opt_act.data(end,1)]) 
ylim([0 1])
set(gca,'linewidth',1.0)

subplot(3,4,7)
plot(opt_act.data(:,1),opt_act.data(:,ind_bf_r),'linewidth',1.5,'color','r');
xlabel('Time (s)','fontweight','bold')
ylabel(['R BF Long Act (-)'],'fontweight','bold')
patch(ham_vert1(1,:),ham_vert1(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
patch(ham_vert2(1,:),ham_vert2(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
xlim([opt_act.data(1,1) opt_act.data(end,1)]) 
ylim([0 1])
set(gca,'linewidth',1.0)

subplot(3,4,8)
plot(opt_act.data(:,1),opt_act.data(:,ind_ta_r),'linewidth',1.5,'color','r');
xlabel('Time (s)','fontweight','bold')
ylabel(['R Tib Ant Act (-)'],'fontweight','bold')
patch(tib_vert1(1,:),tib_vert1(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
patch(tib_vert2(1,:),tib_vert2(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
xlim([opt_act.data(1,1) opt_act.data(end,1)]) 
ylim([0 1])
set(gca,'linewidth',1.0)

subplot(3,4,9)
plot(opt_act.data(:,1),opt_act.data(:,ind_gm_r),'linewidth',1.5,'color','r');
xlabel('Time (s)','fontweight','bold')
ylabel(['R Gas M Act (-)'],'fontweight','bold')
patch(gas_vert1(1,:),gas_vert1(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
patch(gas_vert2(1,:),gas_vert2(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
xlim([opt_act.data(1,1) opt_act.data(end,1)]) 
ylim([0 1])
set(gca,'linewidth',1.0)

subplot(3,4,10)
plot(opt_act.data(:,1),opt_act.data(:,ind_gl_r),'linewidth',1.5,'color','r');
xlabel('Time (s)','fontweight','bold')
patch(gas_vert1(1,:),gas_vert1(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
patch(gas_vert2(1,:),gas_vert2(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
ylabel(['R Gas L Act (-)'],'fontweight','bold')
xlim([opt_act.data(1,1) opt_act.data(end,1)]) 
ylim([0 1])
set(gca,'linewidth',1.0)

subplot(3,4,11)
plot(opt_act.data(:,1),opt_act.data(:,ind_so_r),'linewidth',1.5,'color','r');
xlabel('Time (s)','fontweight','bold')
patch(sol_vert1(1,:),sol_vert1(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
patch(sol_vert2(1,:),sol_vert2(2,:),[.7 .7 .7],'EdgeColor','none','FaceAlpha',0.5)
ylabel(['R Sol Act (-)'],'fontweight','bold')
xlim([opt_act.data(1,1) opt_act.data(end,1)])
ylim([0 1])
set(gca,'linewidth',1.0)

