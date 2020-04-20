% 数据分析和多项式计算
%% 可以定义实时脚本
% 三体问题的数学建模实例
clear;
G = 6.67e-11; dt = 24*3600; N = 3;
% 定义太阳和地球物理属性变量
sun.mass = 100;
earth.mass = 20;
moon.mass = 5;
% 太阳，地球，月亮的位置
sun.position = 1;
earth.position = 2;
moon.position = 3;
% 三者的速度
sun.velocity = 0; 
earth.velocity = 10; 
moon.velocity = 5;

M = [sun.mass; earth.mass; moon.mass]; %sun.mass没定义，这是结构数组类型的数据
R = [sun.position; earth.position; moon.position];
V = [sun.velocity; earth.velocity; moon.velocity];
for t = 1:365
    F = zeros(N,3); % F表示三个天体受到的三个(x,y,z)力
    for i = 1:N
        mi = M(i); 
        ri = R(i,:);
        for j = (i+1):N
            mj = M(j); 
            rj = R(j,:);
            rij = rj -ri;
            fij = G*mi*mj./(norm(rij).^3).*rij;
            F([i,j],:) = F([i,j],:) + [fij;-fij];
        end
    end
    V = V + F./repmat(M,1,3)*dt;
    R = R + V*dt;
end
disp(V);
disp(R);
disp('运行结束');
%% dir(文件名)-可以获取文件属性
%
clear;
y = imread('123.jpg');
disp('图像的大小：')
size(y)
image(y)

%% 求均值，标准差，相关系数矩阵
clear;
x = randn(10000,5);
m = mean(x);
disp(m);
d = std(x);
disp(d);
r = corrcoef(x);
disp(r);
%% 函数插值
clear;
h = 6:2:18;
t = [18,20,22,25,30,28,24;15,19,25,28,34,32,30]';
X1 = 6.5:2:17.5;
Y1 = interp1(h,t,X1,'spline'); %用3次样条插值计算
plot(Y1) %按列画线

%% 二维线性插值
clear;
x = 0:2.5:10; %
h = (0:30:60)';
T = [95,14,0,0,0;
    88,48,32,12,6;
    67,64,54,48,41]; %各测量点的温度
xi = (0:10); % 每隔1米
hi = (0:20:60)'; % 每隔20秒
T1 = interp2(x,h,T,xi,hi); % interp2用线性处理后的内插值
disp(T1)

%% 离散傅里叶变换
clear;
N = 128;
T = 1;
t = linspace(0,T,N);
x = 12*sin(2*pi*10*t + pi/4) + 5*cos(2*pi*40*t);
dt = t(2) - t(1);
f = 1/dt;
X = fft(x);
F = X(1:N/2+1);
f = f*(0:N/2)/N;
plot(f,abs(F),'-*')
xlabel('傅里叶变换');
ylabel('|F(k)|')

%% 多项式求根，建立多项式
P = [3,0,4,-5,-7.2,5];
X = roots(P); %求方程根
G = poly(X); %求多项式











