%% I. ��ջ�������
% ��Դ
% G:\BaiduNetdiskDownload\Matlab�����ѧϰ\03BP������

%clear all
clear;
clc

%% II. ѵ����/���Լ�����
%%
% 1. ��������
load spectra_data.mat

%%
% 2. �������ѵ�����Ͳ��Լ�
temp = randperm(size(NIR,1));
% ѵ��������50������
P_train = NIR(temp(1:50),:)';
T_train = octane(temp(1:50),:)';
% ���Լ�����10������
P_test = NIR(temp(51:end),:)';
T_test = octane(temp(51:end),:)';
N = size(P_test,2);

%% III. ���ݹ�һ��
[p_train, ps_input] = mapminmax(P_train,0,1);
p_test = mapminmax('apply',P_test,ps_input);

[t_train, ps_output] = mapminmax(T_train,0,1);

%% IV. BP�����紴����ѵ�����������
%%
% 1. �������磬�����ز�
net = newff(p_train,t_train,15); % ��9 �ĵ�15

%%
% 2. ����ѵ������
net.trainParam.epochs = 1000; % ��������
net.trainParam.goal = 1e-3; % ѵ��Ŀ�꣬���������С�ڴ���ʱ����
net.trainParam.lr = 0.01; % ѧϰ��

%%
% 3. ѵ������
net = train(net,p_train,t_train);

%%
% 4. �������
t_sim = sim(net,p_test);

%%
% 5. ���ݷ���һ��
T_sim = mapminmax('reverse',t_sim,ps_output);

%% V. ��������
%%
% 1. ������error
error = abs(T_sim - T_test)./T_test;

%%
% 2. ����ϵ��R^2
% Ԥ��ֵ����ʵֵ�Ľӽ��̶�
R2 = (N * sum(T_sim .* T_test) - sum(T_sim) * sum(T_test))^2 / ((N * sum((T_sim).^2) - (sum(T_sim))^2) * (N * sum((T_test).^2) - (sum(T_test))^2)); 

%%
% 3. ����Ա�
result = [T_test' T_sim' error'];

%% VI. ��ͼ
figure
plot(1:N,T_test,'b:*',1:N,T_sim,'r-o')
legend('��ʵֵ','Ԥ��ֵ')
xlabel('Ԥ������')
ylabel('����ֵ')
string = {'���Լ�����ֵ����Ԥ�����Ա�';['R^2=' num2str(R2)]};
title(string)

%% һЩ˵��
% BP����-�мලѧϰ���ź����򴫲������򴫲�
% plot(NIR') % ���������룬��ʾNIR����ͼ
% �����ϸ�����Ϊѵ��������֤�������Լ�
% ���ݼ�Ӧ���д����ԣ�����ģ�Ͳ�����һ����

% view(net) % ���������룬��ʾ����

% ��Ԫ�������ѡ
% ������֤��cross,���ݷ����࣬ѵ������֤������
% ��һ����ÿ��ѭ��ʱ������һ����Ԥ�⣬ѡ����õĲ���


