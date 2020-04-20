%% 官方文档学习
% Try Deep Learning in 10 Lines of MATLAB Code
% 10行代码训练深度学习
clear;
camera = webcam; % 连接摄像头
net = alexnet; % 加载神经网络

while true
    im = snapshot(camera);       % Take a picture
    image(im);                   % Show the picture
    im = imresize(im,[227 227]); % Resize the picture for alexnet
    label = classify(net,im);    % Classify the picture
    title(char(label));          % Show the class label
    drawnow;                      % 刷新屏幕，将未处理的图像显示出来
end
disp('结束');

%% 另一个例子
% 识别摄像头的一幅图片
clear;
camera = webcam; % 连接到摄像头 
nnet = alexnet; % 加载神经网络 
picture = camera.snapshot;  % 抓取图片 
picture = imresize(picture,[227,227]);  % 调整图片大小 
label = classify(nnet, picture);  % 对图片分类 
image(picture); % 显示图片 
title(char(label)); % 显示标签

%% 拍照程序

%获得设备信息
clear;
imaqhwinfo
obj = videoinput('winvideo');
set(obj, 'FramesPerTrigger', 1);
set(obj, 'TriggerRepeat', Inf);
disp(obj);

%定义一个监控界面
hf = figure('Units', 'Normalized', 'Menubar', 'None','NumberTitle', 'off', 'Name', '实时拍照系统');
ha = axes('Parent', hf, 'Units', 'Normalized', 'Position', [0.05 0.2 0.85 0.7]);
axis off % 轴关闭

%定义两个按钮控件
hb1 = uicontrol('Parent', hf, 'Units', 'Normalized','Position', [0.25 0.05 0.2 0.1], 'String', ...
     '预览', 'Callback', ['objRes = get(obj, ''VideoResolution'');' ...
     'nBands = get(obj, ''NumberOfBands'');' ...
     'hImage = image(zeros(objRes(2), objRes(1), nBands));' ...
     'preview(obj, hImage);']);

hb2 = uicontrol('Parent', hf, 'Units', 'Normalized','Position', [0.55 0.05 0.2 0.1], 'String', '拍照', 'Callback', 'imwrite(getsnapshot(obj), ''im.jpg'')');
disp('结束');
















