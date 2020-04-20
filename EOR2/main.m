% name = {'UU.mat','UD.mat','DU.mat','DD.mat','IT1.mat','IT2.mat','IT3.mat','IT4.mat','IT5.mat','IT6.mat','IT7.mat','IT8.mat'};
% for item = 1:12
%     load(name{item});
% end
insample = {'ISGMSUU','ISGMSUD','ISGMSDU','ISGMSDD','ISORLIT1','ISORLIT2','ISORLIT3','ISORLIT4','ISORLIT5','ISORLIT6','ISORLIT7','ISORLIT8'};
outsample = {'OoSGMSUU','OoSGMSUD','OoSGMSDU','OoSGMSDD','OoSORLIT1','OoSORLIT2','OoSORLIT3','OoSORLIT4','OoSORLIT5','OoSORLIT6','OoSORLIT7','OoSORLIT8'};

for i = 1:12
    figure(i)
    eor_2_model(eval(insample{i}),eval(outsample{i}))
end
    
    