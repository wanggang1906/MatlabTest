%% �ٷ��ĵ�ѧϰ
% Try Deep Learning in 10 Lines of MATLAB Code
% 10�д���ѵ�����ѧϰ
clear;
camera = webcam; % ��������ͷ
net = alexnet; % ����������

while true
    im = snapshot(camera);       % Take a picture
    image(im);                   % Show the picture
    im = imresize(im,[227 227]); % Resize the picture for alexnet
    label = classify(net,im);    % Classify the picture
    title(char(label));          % Show the class label
    drawnow;                      % ˢ����Ļ����δ�����ͼ����ʾ����
end
disp('����');

%% ��һ������
% ʶ������ͷ��һ��ͼƬ
clear;
camera = webcam; % ���ӵ�����ͷ 
nnet = alexnet; % ���������� 
picture = camera.snapshot;  % ץȡͼƬ 
picture = imresize(picture,[227,227]);  % ����ͼƬ��С 
label = classify(nnet, picture);  % ��ͼƬ���� 
image(picture); % ��ʾͼƬ 
title(char(label)); % ��ʾ��ǩ

%% ���ճ���

%����豸��Ϣ
clear;
imaqhwinfo
obj = videoinput('winvideo');
set(obj, 'FramesPerTrigger', 1);
set(obj, 'TriggerRepeat', Inf);
disp(obj);

%����һ����ؽ���
hf = figure('Units', 'Normalized', 'Menubar', 'None','NumberTitle', 'off', 'Name', 'ʵʱ����ϵͳ');
ha = axes('Parent', hf, 'Units', 'Normalized', 'Position', [0.05 0.2 0.85 0.7]);
axis off % ��ر�

%����������ť�ؼ�
hb1 = uicontrol('Parent', hf, 'Units', 'Normalized','Position', [0.25 0.05 0.2 0.1], 'String', ...
     'Ԥ��', 'Callback', ['objRes = get(obj, ''VideoResolution'');' ...
     'nBands = get(obj, ''NumberOfBands'');' ...
     'hImage = image(zeros(objRes(2), objRes(1), nBands));' ...
     'preview(obj, hImage);']);

hb2 = uicontrol('Parent', hf, 'Units', 'Normalized','Position', [0.55 0.05 0.2 0.1], 'String', '����', 'Callback', 'imwrite(getsnapshot(obj), ''im.jpg'')');
disp('����');
















