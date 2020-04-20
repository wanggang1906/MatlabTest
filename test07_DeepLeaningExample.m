%% 准备数据存储以进行图像到图像的回归
%此示例显示如何准备图像存储，
%以使用ImageDatastore的transform和combine函数来训练图像到图像的回归网络。
%此示例说明如何使用适合训练降噪网络的管道预处理数据。
%然后，该示例使用预处理的噪声数据来训练简单的卷积自动编码器网络以去除图像噪声。

% 推送到远端

%% 使用预处理管道准备数据

%此示例使用盐和胡椒噪声模型，其中一部分输入图像像素设置为0或1（分别为黑色和白色）。
%嘈杂的图像充当网络输入。原始映像充当预期的网络响应。
%该网络学会检测并消除盐和胡椒粉噪声。
%将原始图像加载到数字数据集中作为imageDatastore。
%数据存储区包含10,000个从0到9的数字合成图像。
%这些图像是通过对使用不同字体创建的数字图像进行随机转换而生成的。每个数字图像为28 x 28像素。
%数据存储区每个类别包含相等数量的图像。
digitDatasetPath = fullfile(matlabroot,'toolbox','nnet', ...
    'nndemos','nndatasets','DigitDataset');
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

%指定较大的读取大小以最大程度地减少文件I / O的成本。
imds.ReadSize = 500;

%设置全局随机数生成器的种子以帮助结果重现。
rng(0)

%在训练之前，请使用随机播放功能对数字数据进行随机播放。
imds = shuffle(imds);

%使用splitEachLabel函数可将imds分为三个包含原始图像的图像数据存储，
%以进行训练，验证和测试。 
[imdsTrain,imdsVal,imdsTest] = splitEachLabel(imds,0.95,0.025);

%使用转换功能创建每个输入图像的嘈杂版本，这些版本将用作网络输入。
%转换函数从基础数据存储中读取数据，
%并使用辅助函数addNoise（在此示例末尾定义）中定义的操作来处理数据。
%转换函数的输出是TransformedDatastore。
dsTrainNoisy = transform(imdsTrain,@addNoise);
dsValNoisy = transform(imdsVal,@addNoise);
dsTestNoisy = transform(imdsTest,@addNoise);

%使用合并功能可将嘈杂的图像和原始图像合并到一个单一的数据存储中，
%该数据存储会将数据馈送给trainNetwork。
%如trainNetwork所期望的，该组合的数据存储将一批数据读取到两列的单元格阵列中。
%combine函数的输出是CombinedDatastore。
dsTrain = combine(dsTrainNoisy,imdsTrain);
dsVal = combine(dsValNoisy,imdsVal);
dsTest = combine(dsTestNoisy,imdsTest);

%使用变换功能可以执行输入和响应数据存储库共有的其他预处理操作。
%commonPreprocessing辅助函数（在本示例末尾定义）将输入和响应图像的大小调整为32*32像素，
%以匹配网络的输入大小，
%并将每个图像中的数据标准化为[0，1]范围。
dsTrain = transform(dsTrain,@commonPreprocessing);
dsVal = transform(dsVal,@commonPreprocessing);
dsTest = transform(dsTest,@commonPreprocessing);

%最后，使用变换功能向训练集添加随机增强。 
%expandImages辅助函数（在本示例末尾定义）将随机90度旋转应用于数据。
%将相同的旋转应用于网络输入和相应的预期响应。
dsTrain = transform(dsTrain,@augmentImages);

%增强可以减少过度拟合，并为训练网络中的旋转增加鲁棒性。
%验证或测试数据集不需要随机增强。

%% 预览预处理数据

%由于准备训练数据需要进行一些预处理操作，
%因此在训练之前预览预处理数据以确认它看起来正确。
%使用预览功能预览数据。
%使用montage函数可视化配对的嘈杂图像和原始图像的示例。
%训练数据看起来正确。
%盐和胡椒粉杂音出现在左列的输入图像中。
%除了添加噪声外，输入图像和响应图像相同。
%以相同的方式将随机90度旋转应用于输入图像和响应图像
exampleData = preview(dsTrain);
inputs = exampleData(:,1);
responses = exampleData(:,2);
minibatch = cat(2,inputs,responses);
montage(minibatch','Size',[8 2])
title('Inputs (Left) and Responses (Right)')

%% 定义卷积自动编码器网络

%卷积自动编码器是用于对图像进行降噪的常见体系结构。
%卷积自动编码器由两个阶段组成：编码器和解码器。
%编码器将原始输入图像压缩为宽度和高度较小的潜在表示，
%但在每个空间位置比原始输入图像有很多特征图的意义上更深。
%压缩的潜在表示在恢复原始图像中的高频特征的能力上损失了一定数量的空间分辨率，
%但是还学会了在原始图像的编码中不包括噪声伪像。
%解码器反复对编码信号进行升采样，以将其移回其原始宽度，高度和通道数。
%由于编码器消除了噪声，因此解码后的最终图像具有较少的噪声伪像。

%创建图像输入层。
%为了简化与下采样和上采样相关的填充问题（将因子减少两个），
%请选择32 x 32输入大小，因为32可以被2、4和8整除。
imageLayer = imageInputLayer([32,32,1]);

%创建编码层。
%编码器中的下采样是通过最大池化（池大小为2，跨度为2）实现的。
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

%创建解码层。
%解码器使用转置的卷积层对编码信号进行上采样。
%使用createUpsampleTransponseConvLayer辅助函数，
%以正确的上采样因子创建转置的卷积层。
%该函数在本示例的末尾定义。
%网络使用clippedReluLayer作为最终激活层，以强制输出范围为[0，1]。
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

%连接图像输入层，编码层和解码层以形成卷积自动编码器网络体系结构。
layers = [imageLayer,encodingLayers,decodingLayers];

%% 定义训练选项

%使用Adam优化器训练网络。
%通过使用trainingOptions函数来指定超参数设置。
%训练100个时代。
%合并的数据存储区（使用合并功能创建时）不支持改组，
%因此将Shuffle参数指定为“从不”。

options = trainingOptions('adam', ...
    'MaxEpochs',100, ...
    'MiniBatchSize',imds.ReadSize, ...
    'ValidationData',dsVal, ...
    'Shuffle','never', ...
    'Plots','training-progress', ...
    'Verbose',false);

%% 训练网络

%现在已经配置了数据源和训练选项，
%请使用trainNetwork函数训练卷积自动编码器网络。
%强烈建议您使用具有CUDA功能且计算能力为3.0或更高的NVIDIA?GPU进行培训。
%注意：在NVIDIA?Titan XP GPU上进行培训大约需要25分钟。

net = trainNetwork(dsTrain,layers,options);

%% 评估去噪网络的性能

%通过使用predict函数从测试集中获取输出图像。
ypred = predict(net,dsTest);

%可视化样本输入图像和来自网络的相关预测输出，
%以了解去噪效果如何。
%如预期的那样，来自网络的输出图像已从输入图像中消除了大多数噪声伪像。
%作为编码和解码过程的结果，去噪后的图像略微模糊。
inputImageExamples = preview(dsTest);
montage({inputImageExamples{1},ypred(:,:,:,1)});

%通过分析峰值信噪比（PSNR）评估网络的性能。
ref = inputImageExamples{1,2};
originalNoisyImage = inputImageExamples{1,1};
psnrNoisy = psnr(originalNoisyImage,ref)
psnrDenoised = psnr(ypred(:,:,:,1),ref)

%如预期的那样，输出图像的PSNR高于嘈杂的输入图像。

%% 结束语
%本示例说明了如何使用ImageDatastore的transform和combine函数
%来设置训练和评估数字数据集上的卷积自动编码器所需的数据预处理。

%% 支持功能

%% addNoise辅助功能

%通过使用imnoise功能将盐和胡椒粉噪声添加到图像中。 
%addNoise函数要求输入数据的格式为图像数据的单元格数组，
%该数组与ImageDatastore的read函数返回的数据格式匹配。

function dataOut = addNoise(data)
dataOut = data;
    for idx = 1:size(data,1)
        dataOut{idx} = imnoise(data{idx},'salt & pepper');
    end
end

%% commonPreprocessing辅助函数

%定义了训练，验证和测试集共有的预处理。
%辅助函数执行这些预处理步骤。 
%1将图像数据转换为单一数据类型。 
%2使用imresize函数调整图像数据的大小以匹配输入层的大小。 
%3使用重新缩放功能将数据归一化为[0，1]范围。
%辅助函数要求输入数据的格式为图像数据的两列单元格数组，
%该数组与由CombinedDatastore的读取函数返回的数据格式匹配。
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

%% expandImages辅助函数

%通过使用rot90函数将随机90度旋转添加到数据中。
%将相同的旋转应用于网络输入和相应的预期响应。
%该函数要求输入数据的格式为图像数据的两列单元格数组，
%该数组与由CombinedDatastore的读取函数返回的数据格式匹配。
function dataOut = augmentImages(data)
dataOut = cell(size(data));
for idx = 1:size(data,1)
    rot90Val = randi(4,1,1)-1;
    dataOut(idx,:) = {rot90(data{idx,1},rot90Val),rot90(data{idx,2},rot90Val)};
end
end

%% createUpsampleTransposeConvLayer辅助函数

%定义一个转置的卷积图层，该图层将按指定因子对输入的图层进行升采样。
function out = createUpsampleTransponseConvLayer(factor,numFilters)
filterSize = 2*factor - mod(factor,2); 
cropping = (factor-mod(factor,2))/2;
numChannels = 1;
out = transposedConv2dLayer(filterSize,numFilters, ... 
    'NumChannels',numChannels,'Stride',factor,'Cropping',cropping);
end