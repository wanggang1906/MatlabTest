%% ׼�����ݴ洢�Խ���ͼ��ͼ��Ļع�
%��ʾ����ʾ���׼��ͼ��洢��
%��ʹ��ImageDatastore��transform��combine������ѵ��ͼ��ͼ��Ļع����硣
%��ʾ��˵�����ʹ���ʺ�ѵ����������Ĺܵ�Ԥ�������ݡ�
%Ȼ�󣬸�ʾ��ʹ��Ԥ���������������ѵ���򵥵ľ���Զ�������������ȥ��ͼ��������

% ���͵�Զ��

%% ʹ��Ԥ����ܵ�׼������

%��ʾ��ʹ���κͺ�������ģ�ͣ�����һ��������ͼ����������Ϊ0��1���ֱ�Ϊ��ɫ�Ͱ�ɫ����
%���ӵ�ͼ��䵱�������롣ԭʼӳ��䵱Ԥ�ڵ�������Ӧ��
%������ѧ���Ⲣ�����κͺ�����������
%��ԭʼͼ����ص��������ݼ�����ΪimageDatastore��
%���ݴ洢������10,000����0��9�����ֺϳ�ͼ��
%��Щͼ����ͨ����ʹ�ò�ͬ���崴��������ͼ��������ת�������ɵġ�ÿ������ͼ��Ϊ28 x 28���ء�
%���ݴ洢��ÿ�����������������ͼ��
digitDatasetPath = fullfile(matlabroot,'toolbox','nnet', ...
    'nndemos','nndatasets','DigitDataset');
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

%ָ���ϴ�Ķ�ȡ��С�����̶ȵؼ����ļ�I / O�ĳɱ���
imds.ReadSize = 500;

%����ȫ��������������������԰���������֡�
rng(0)

%��ѵ��֮ǰ����ʹ��������Ź��ܶ��������ݽ���������š�
imds = shuffle(imds);

%ʹ��splitEachLabel�����ɽ�imds��Ϊ��������ԭʼͼ���ͼ�����ݴ洢��
%�Խ���ѵ������֤�Ͳ��ԡ� 
[imdsTrain,imdsVal,imdsTest] = splitEachLabel(imds,0.95,0.025);

%ʹ��ת�����ܴ���ÿ������ͼ������Ӱ汾����Щ�汾�������������롣
%ת�������ӻ������ݴ洢�ж�ȡ���ݣ�
%��ʹ�ø�������addNoise���ڴ�ʾ��ĩβ���壩�ж���Ĳ������������ݡ�
%ת�������������TransformedDatastore��
dsTrainNoisy = transform(imdsTrain,@addNoise);
dsValNoisy = transform(imdsVal,@addNoise);
dsTestNoisy = transform(imdsTest,@addNoise);

%ʹ�úϲ����ܿɽ����ӵ�ͼ���ԭʼͼ��ϲ���һ����һ�����ݴ洢�У�
%�����ݴ洢�Ὣ�������͸�trainNetwork��
%��trainNetwork�������ģ�����ϵ����ݴ洢��һ�����ݶ�ȡ�����еĵ�Ԫ�������С�
%combine�����������CombinedDatastore��
dsTrain = combine(dsTrainNoisy,imdsTrain);
dsVal = combine(dsValNoisy,imdsVal);
dsTest = combine(dsTestNoisy,imdsTest);

%ʹ�ñ任���ܿ���ִ���������Ӧ���ݴ洢�⹲�е�����Ԥ���������
%commonPreprocessing�����������ڱ�ʾ��ĩβ���壩���������Ӧͼ��Ĵ�С����Ϊ32*32���أ�
%��ƥ������������С��
%����ÿ��ͼ���е����ݱ�׼��Ϊ[0��1]��Χ��
dsTrain = transform(dsTrain,@commonPreprocessing);
dsVal = transform(dsVal,@commonPreprocessing);
dsTest = transform(dsTest,@commonPreprocessing);

%���ʹ�ñ任������ѵ������������ǿ�� 
%expandImages�����������ڱ�ʾ��ĩβ���壩�����90����תӦ�������ݡ�
%����ͬ����תӦ���������������Ӧ��Ԥ����Ӧ��
dsTrain = transform(dsTrain,@augmentImages);

%��ǿ���Լ��ٹ�����ϣ���Ϊѵ�������е���ת����³���ԡ�
%��֤��������ݼ�����Ҫ�����ǿ��

%% Ԥ��Ԥ��������

%����׼��ѵ��������Ҫ����һЩԤ���������
%�����ѵ��֮ǰԤ��Ԥ����������ȷ������������ȷ��
%ʹ��Ԥ������Ԥ�����ݡ�
%ʹ��montage�������ӻ���Ե�����ͼ���ԭʼͼ���ʾ����
%ѵ�����ݿ�������ȷ��
%�κͺ������������������е�����ͼ���С�
%������������⣬����ͼ�����Ӧͼ����ͬ��
%����ͬ�ķ�ʽ�����90����תӦ��������ͼ�����Ӧͼ��
exampleData = preview(dsTrain);
inputs = exampleData(:,1);
responses = exampleData(:,2);
minibatch = cat(2,inputs,responses);
montage(minibatch','Size',[8 2])
title('Inputs (Left) and Responses (Right)')

%% �������Զ�����������

%����Զ������������ڶ�ͼ����н���ĳ�����ϵ�ṹ��
%����Զ��������������׶���ɣ��������ͽ�������
%��������ԭʼ����ͼ��ѹ��Ϊ��Ⱥ͸߶Ƚ�С��Ǳ�ڱ�ʾ��
%����ÿ���ռ�λ�ñ�ԭʼ����ͼ���кܶ�����ͼ�������ϸ��
%ѹ����Ǳ�ڱ�ʾ�ڻָ�ԭʼͼ���еĸ�Ƶ��������������ʧ��һ�������Ŀռ�ֱ��ʣ�
%���ǻ�ѧ������ԭʼͼ��ı����в���������α��
%�����������Ա����źŽ������������Խ����ƻ���ԭʼ��ȣ��߶Ⱥ�ͨ������
%���ڱ�������������������˽���������ͼ����н��ٵ�����α��

%����ͼ������㡣
%Ϊ�˼����²������ϲ�����ص�������⣨�����Ӽ�����������
%��ѡ��32 x 32�����С����Ϊ32���Ա�2��4��8������
imageLayer = imageInputLayer([32,32,1]);

%��������㡣
%�������е��²�����ͨ�����ػ����ش�СΪ2�����Ϊ2��ʵ�ֵġ�
encodingLayers = [ ...
    convolution2dLayer(3,16,'Padding','same'), ...
    reluLayer, ...
    maxPooling2dLayer(2,'Padding','same','Stride',2), ...
    convolution2dLayer(3,8,'Padding','same'), ...
    reluLayer, ...
    maxPooling2dLayer(2,'Padding','same','Stride',2), ...
    convolution2dLayer(3,8,'Padding','same'), ...
    reluLayer, ...
    maxPooling2dLayer(2,'Padding','same','Stride',2)];

%��������㡣
%������ʹ��ת�õľ����Ա����źŽ����ϲ�����
%ʹ��createUpsampleTransponseConvLayer����������
%����ȷ���ϲ������Ӵ���ת�õľ���㡣
%�ú����ڱ�ʾ����ĩβ���塣
%����ʹ��clippedReluLayer��Ϊ���ռ���㣬��ǿ�������ΧΪ[0��1]��
decodingLayers = [ ...
    createUpsampleTransponseConvLayer(2,8), ...
    reluLayer, ...
    createUpsampleTransponseConvLayer(2,8), ...
    reluLayer, ...
    createUpsampleTransponseConvLayer(2,16), ...
    reluLayer, ...
    convolution2dLayer(3,1,'Padding','same'), ...
    clippedReluLayer(1.0), ...
    regressionLayer];

%����ͼ������㣬�����ͽ�������γɾ���Զ�������������ϵ�ṹ��
layers = [imageLayer,encodingLayers,decodingLayers];

%% ����ѵ��ѡ��

%ʹ��Adam�Ż���ѵ�����硣
%ͨ��ʹ��trainingOptions������ָ�����������á�
%ѵ��100��ʱ����
%�ϲ������ݴ洢����ʹ�úϲ����ܴ���ʱ����֧�ָ��飬
%��˽�Shuffle����ָ��Ϊ���Ӳ�����

options = trainingOptions('adam', ...
    'MaxEpochs',100, ...
    'MiniBatchSize',imds.ReadSize, ...
    'ValidationData',dsVal, ...
    'Shuffle','never', ...
    'Plots','training-progress', ...
    'Verbose',false);

%% ѵ������

%�����Ѿ�����������Դ��ѵ��ѡ�
%��ʹ��trainNetwork����ѵ������Զ����������硣
%ǿ�ҽ�����ʹ�þ���CUDA�����Ҽ�������Ϊ3.0����ߵ�NVIDIA?GPU������ѵ��
%ע�⣺��NVIDIA?Titan XP GPU�Ͻ�����ѵ��Լ��Ҫ25���ӡ�

net = trainNetwork(dsTrain,layers,options);

%% ����ȥ�����������

%ͨ��ʹ��predict�����Ӳ��Լ��л�ȡ���ͼ��
ypred = predict(net,dsTest);

%���ӻ���������ͼ���������������Ԥ�������
%���˽�ȥ��Ч����Ρ�
%��Ԥ�ڵ�������������������ͼ���Ѵ�����ͼ���������˴��������α��
%��Ϊ����ͽ�����̵Ľ����ȥ����ͼ����΢ģ����
inputImageExamples = preview(dsTest);
montage({inputImageExamples{1},ypred(:,:,:,1)});

%ͨ��������ֵ����ȣ�PSNR��������������ܡ�
ref = inputImageExamples{1,2};
originalNoisyImage = inputImageExamples{1,1};
psnrNoisy = psnr(originalNoisyImage,ref)
psnrDenoised = psnr(ypred(:,:,:,1),ref)

%��Ԥ�ڵ����������ͼ���PSNR�������ӵ�����ͼ��

%% ������
%��ʾ��˵�������ʹ��ImageDatastore��transform��combine����
%������ѵ���������������ݼ��ϵľ���Զ����������������Ԥ����

%% ֧�ֹ���

%% addNoise��������

%ͨ��ʹ��imnoise���ܽ��κͺ�����������ӵ�ͼ���С� 
%addNoise����Ҫ���������ݵĸ�ʽΪͼ�����ݵĵ�Ԫ�����飬
%��������ImageDatastore��read�������ص����ݸ�ʽƥ�䡣

function dataOut = addNoise(data)
dataOut = data;
    for idx = 1:size(data,1)
        dataOut{idx} = imnoise(data{idx},'salt & pepper');
    end
end

%% commonPreprocessing��������

%������ѵ������֤�Ͳ��Լ����е�Ԥ����
%��������ִ����ЩԤ�����衣 
%1��ͼ������ת��Ϊ��һ�������͡� 
%2ʹ��imresize��������ͼ�����ݵĴ�С��ƥ�������Ĵ�С�� 
%3ʹ���������Ź��ܽ����ݹ�һ��Ϊ[0��1]��Χ��
%��������Ҫ���������ݵĸ�ʽΪͼ�����ݵ����е�Ԫ�����飬
%����������CombinedDatastore�Ķ�ȡ�������ص����ݸ�ʽƥ�䡣
function dataOut = commonPreprocessing(data)
dataOut = cell(size(data));
for col = 1:size(data,2)
    for idx = 1:size(data,1)
        temp = single(data{idx,col});
        temp = imresize(temp,[32,32]);
        temp = rescale(temp);
        dataOut{idx,col} = temp;
    end
end
end

%% expandImages��������

%ͨ��ʹ��rot90���������90����ת��ӵ������С�
%����ͬ����תӦ���������������Ӧ��Ԥ����Ӧ��
%�ú���Ҫ���������ݵĸ�ʽΪͼ�����ݵ����е�Ԫ�����飬
%����������CombinedDatastore�Ķ�ȡ�������ص����ݸ�ʽƥ�䡣
function dataOut = augmentImages(data)
dataOut = cell(size(data));
for idx = 1:size(data,1)
    rot90Val = randi(4,1,1)-1;
    dataOut(idx,:) = {rot90(data{idx,1},rot90Val),rot90(data{idx,2},rot90Val)};
end
end

%% createUpsampleTransposeConvLayer��������

%����һ��ת�õľ��ͼ�㣬��ͼ�㽫��ָ�����Ӷ������ͼ�������������
function out = createUpsampleTransponseConvLayer(factor,numFilters)
filterSize = 2*factor - mod(factor,2); 
cropping = (factor-mod(factor,2))/2;
numChannels = 1;
out = transposedConv2dLayer(filterSize,numFilters, ... 
    'NumChannels',numChannels,'Stride',factor,'Cropping',cropping);
end