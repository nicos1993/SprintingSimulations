% Left leg/Rear
% GMAX
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,1))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(20,:)) % 
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(21,:)) % 
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(22,:)) % 
title('L GMAX')

hold off

% Left leg/Rear
% BF
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,2))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(9,:)) % long head
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(10,:)) % short head
title('L BF')

hold off

% Left leg/Rear
% ST
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,3))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(8,:)) % long head
title('L ST')

hold off

% Left leg/Rear
% GASTM
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,4))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(32,:)) % med
title('L GASTM')

hold off

% Left leg/Rear
% TFL
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,5))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(17,:)) % long head
title('L TFL')

hold off

% Left leg/Rear
% RF
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,6))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(28,:)) % long head
title('L RF')

hold off

% Left leg/Rear
% VL
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,7))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(31,:)) % vas lat
title('L VL')

hold off

% Left leg/Rear
% VM
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,8))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(29,:)) % vas med
title('L VM')

hold off





% Left leg/Rear
% TA
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,9))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(38,:)) % 

title('L TA')

hold off

% Left leg/Rear
% SOL
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,10))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(34,:))
title('L SOL')

hold off

% Right leg/Front
% GMAX
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,11))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(66,:)) % 
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(67,:)) % 
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(68,:)) % 
title('R GMAX')

hold off

% Right leg/Front
% BF
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,12))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(55,:)) % long
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(56,:)) % short
title('R BF')

hold off

% Right leg/Front
% GASTM
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,13))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(78,:)) % 
title('R GASTM')

hold off

% Right leg/Front
% TFL
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,14))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(63,:)) % 
title('R TFL')

hold off

% Right leg/Front
% VM
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,15))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(75,:)) % 
title('R VM')

hold off

% Right leg/Front
% SOL
plot(emgDataStruct.p02_m_01_labelled_dataStructure.data.analog_data.Time(208:656)-0.048,emgDataStruct.normalised.p02_m_01_labelled_dataStructure(208:656,16))
hold on
plot(optimumOutput.timeGrid,optimumOutput.optVars_nsc.act(80,:)) 
title('R SOL')

hold off



