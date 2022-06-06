fields = fieldnames(optimumOutput.angMom);

for i = 0:length(fields)-1
   
    angMom_array(:,1+i*3:3+i*3) = getfield(optimumOutput.angMom,fields{i+1})';
    
end

angMom_total = sum(angMom_array,2);

angMom_r_leg(:,1:3) = getfield(optimumOutput.angMom,fields{1})';
angMom_r_leg(:,4:6) = getfield(optimumOutput.angMom,fields{3})';
angMom_r_leg(:,7:9) = getfield(optimumOutput.angMom,fields{5})';
angMom_r_leg(:,10:12) = getfield(optimumOutput.angMom,fields{7})';
angMom_r_leg(:,13:15) = getfield(optimumOutput.angMom,fields{9})';

angMom_r_leg_total = sum(angMom_r_leg,2);
angMom_r_leg_total_X = sum(angMom_r_leg(:,[1:3:13]),2);
angMom_r_leg_total_Y = sum(angMom_r_leg(:,[2:3:14]),2);
angMom_r_leg_total_Z = sum(angMom_r_leg(:,[3:3:15]),2);

angMom_l_leg(:,1:3) = getfield(optimumOutput.angMom,fields{2})';
angMom_l_leg(:,4:6) = getfield(optimumOutput.angMom,fields{4})';
angMom_l_leg(:,7:9) = getfield(optimumOutput.angMom,fields{6})';
angMom_l_leg(:,10:12) = getfield(optimumOutput.angMom,fields{8})';
angMom_l_leg(:,13:15) = getfield(optimumOutput.angMom,fields{10})';

angMom_l_leg_total = sum(angMom_l_leg,2);
angMom_l_leg_total_X = sum(angMom_l_leg(:,[1:3:13]),2);
angMom_l_leg_total_Y = sum(angMom_l_leg(:,[2:3:14]),2);
angMom_l_leg_total_Z = sum(angMom_l_leg(:,[3:3:15]),2);

angMom_r_arm(:,1:3) = getfield(optimumOutput.angMom,fields{11})';
angMom_r_arm(:,4:6) = getfield(optimumOutput.angMom,fields{13})';
angMom_r_arm(:,7:9) = getfield(optimumOutput.angMom,fields{15})';
angMom_r_arm(:,10:12) = getfield(optimumOutput.angMom,fields{17})';

angMom_r_arm_total = sum(angMom_r_arm,2);
angMom_r_arm_total_X = sum(angMom_r_arm(:,[1:3:10]),2);
angMom_r_arm_total_Y = sum(angMom_r_arm(:,[2:3:11]),2);
angMom_r_arm_total_Z = sum(angMom_r_arm(:,[3:3:12]),2);

angMom_l_arm(:,1:3) = getfield(optimumOutput.angMom,fields{12})';
angMom_l_arm(:,4:6) = getfield(optimumOutput.angMom,fields{14})';
angMom_l_arm(:,7:9) = getfield(optimumOutput.angMom,fields{16})';
angMom_l_arm(:,10:12) = getfield(optimumOutput.angMom,fields{18})';

angMom_l_arm_total = sum(angMom_l_arm,2);
angMom_l_arm_total_X = sum(angMom_l_arm(:,[1:3:10]),2);
angMom_l_arm_total_Y = sum(angMom_l_arm(:,[2:3:11]),2);
angMom_l_arm_total_Z = sum(angMom_l_arm(:,[3:3:12]),2);

angMom_pelvis_total = sum(getfield(optimumOutput.angMom,fields{19})',2);
angMom_torso_total = sum(getfield(optimumOutput.angMom,fields{20})',2);

plot(angMom_total,'linewidth',2);
hold on
plot(angMom_r_leg_total,'linewidth',2);
plot(angMom_l_leg_total,'linewidth',2);
plot(angMom_r_arm_total,'linewidth',2);
plot(angMom_l_arm_total,'linewidth',2);
plot(angMom_pelvis_total,'linewidth',2);
plot(angMom_torso_total,'linewidth',2);

plot(angMom_torso_total+angMom_l_leg_total);

legend('total','r leg','l leg','r arm','l arm','pelvis','torso')

line([33 33],[-40 20],'linewidth',0.5,'linestyle','--','color','k');