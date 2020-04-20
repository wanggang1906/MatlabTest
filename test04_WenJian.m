%% 文件操作,存储魔方矩阵
clear;
fid = fopen('magic5.dat','W');
cnt = fwrite(fid,magic(5),'int32');
fclose(fid);

%% 绘制图像-曲线条数为矩阵列数
x = 0:pi/100:2*pi;
y = 2*exp(-0.5*x).*cos(4*pi*x);
plot(x,y) %只有一个参数时以向量下标为横坐标，元素值为纵坐标的折线图

% 绘制多条曲线
x1 = linspace(0,2*pi,100);
x2 = linspace(0,3*pi,100);
x3 = linspace(0,4*pi,100);

y1 = sin(x1);
y2 = 1 + sin(x2);
y3 = 2 + sin(x3);
x = [x1;x2;x3]';
y = [y1;y2;y3]';
plot(x,y,x1,y1-1)

% 两个纵坐标标度
x = 0:pi/100:2*pi;
y1 = 0.2*exp(-0.5*x).*cos(4*pi*x); %点乘表示标量相乘
y2 = 2*exp(-0.5).*cos(pi*x);
plotyy(x,y1,x,y2); %两个纵坐标标度

%图形保持(不刷新)
x = 0:pi/100:pi;
y1 = 0.2*exp(-0.5*x).*cos(4*pi*x);
plot(x,y1)
hold on %保持原有图像
y2 = 2*exp(-0.5*x).*cos(pi*x);
plot(x,y2);
hold off %刷新图像

%% 线标记
clear;
x = linspace(0,2*pi,1000);
y1 = 0.2*exp(-0.5*x).*cos(4*pi*x);
y2 = 2*exp(-0.5*x).*cos(pi*x);
k = find(abs(y1-y2) < le -2);%%%%%%%%%%%有错
x1 = x(k); %y1和y2相等点的x坐标
y3 = 0.2*exp(-0.5*x1).*cos(4*pi*x1);
plot(x,y1,x,y2,'k:',x1,y3,'bp');

%% 图形标注
clear;
x = 0:pi/100:2*pi;
y1 = 2*exp(-0.5*x);
y2 = cos(4*pi*x);
plot(x,y1,x,y2)
title('x 为0-2{\pi}');
xlabel('X坐标');
ylabel('Y坐标');
text(0.8,1.5,'曲线y1=2^e{-0.5x}');
text(2.5,1.1,'曲线y2=cos(4{\pi}x)');
legend('y1','y2')

%% 坐标控制
t = 0:0.01:2*pi;
x = exp(i*t);
y = [x;2*x;3*x]';
plot(y)
grid on; %加网格线
box on; %加坐标边框
axis equal %坐标轴采用等刻度

%对函数自适应采样的绘图函数
fplot('cos(tan(pi*x))',[0,1],le-4) %%%%%%%%%%出错

%极坐标图
t = 0:pi/50:2*pi;
r = sin(t).*cos(t);
polar(t,r,'-*');

%% 统计分析图
clear;
x = 0:pi/10:2*pi;
y = 2*sin(x);
subplot(2,2,1);bar(x,y,'g');%1 条形图
title('bar(x,y,''g'')');axis([0,7,-2,2]);
subplot(2,2,2);stairs(x,y,'b');%2 阶梯图
title('stairs(x,y,''b'')');axis([0,7,-2,2]);
subplot(2,2,3);stem(x,y,'k');%3 杆图
title('stem(x,y,''k'')');axis([0,7,-2,2]);
subplot(2,2,4);fill(x,y,'y');%4 填充图
title('fill(x,y,''y'')');axis([0,7,-2,2]);

%隐函数绘图
clear;
subplot(2,2,1);
ezplot('x^2+y^2-9');axis equal
subplot(2,2,2);
ezplot('x^3+y^3-5*x*y+1/5');
subplot(2,2,3);
ezplot('cos(tan(pi*x))',[0,1])
subplot(2,2,4);
ezplot('8*cos(t)','4*sqrt(2)*sin(t)',[0,2*pi])

%% 三维图形
clear;
t = 0:pi/100:20*pi;
x = sin(t);
y = cos(t);
z = t.*sin(t).*cos(t);
plot3(x,y,z);
title('de');
xlabel('X');ylabel('Y');zlabel('Z');
grid on;

%绘制曲面函数图-网格曲面
[x,y] = meshgrid(0:0.25:4*pi); %meshgrid函数-产生平面区域内的网格坐标矩阵
%产生两个矩阵，x的每一行都是向量x，行数等于向量y的元素个数，矩阵y的每一列都是向量y，列数等于向量x的元素的个数
z = sin(x+sin(y))-x/10;
mesh(x,y,z);
axis([0 4*pi 0 4*pi -2.5 1]);

%在平面区域内绘制4种三维曲面
[x,y]=meshgrid(-8:0.5:8); %产生平面网格矩阵
%所有网格的x付给x,
z=sin(sqrt(x.^2+y.^2))./sqrt(x.^2+y.^2+eps);
%esp=esp(1),返回一个数的最小浮点数精度，一般用在分母上防止分母等于零
subplot(2,2,1);
mesh(x,y,z);
title('mesh(x,y,z)')
subplot(2,2,2);
meshc(x,y,z);
title('meshc(x,y,z)')
subplot(2,2,3);
meshz(x,y,z)
title('meshz(x,y,z)')
subplot(2,2,4);
surf(x,y,z);
title('surf(x,y,z)')

%% 三维曲面图形 sphere,cylinder,peaks
clear;
t=0:pi/20:2*pi;
[x,y,z]= cylinder(2+sin(t),30);
subplot(2,2,1);
surf(x,y,z);
subplot(2,2,2);
[x,y,z]=sphere;
surf(x,y,z);
subplot(2,1,2);
[x,y,z]=peaks(30); 
surf(x,y,z);

%$ 三维饼图...
clear;
subplot(2,2,1);
bar3(magic(4)) %三维条形图-有交互
subplot(2,2,2);
y=2*sin(0:pi/10:2*pi);
stem3(y); %三维杆图
subplot(2,2,3);
pie3([2347,1827,2043,3025]); %三维饼图-不带交互的
subplot(2,2,4);
fill3(rand(3,5),rand(3,5),rand(3,5), 'y' ) %三维填充图

%% 绘制多峰函数的瀑布图和等高线
clear;
subplot(1,2,1);
[X,Y,Z]=peaks(30);
waterfall(X,Y,Z) %瀑布图
xlabel('X-轴'),ylabel('Y-axis'),zlabel('Z-axis');
subplot(1,2,2);
contour3(X,Y,Z,12,'k');     %其中12代表高度的等级数，表示有12条等高线
xlabel('X-axis'),ylabel('Y-axis'),zlabel('Z-axis');

%% 图形修饰-试点处理view(az-方位角,el-仰角)-有默认值
%颜色处理
clear;
[x,y,z] = sphere(20);
colormap(copper);
subplot(1,3,1);
surf(x,y,z);
axis equal
subplot(1,3,2);
surf(x,y,z); shading flat;
axis equal
subpolt(1,3,3);
surf(x,y,z); shading interp; %表面光滑
axis equal

%光照处理后的球面
[x,y,z] = sphere(20);
subplot(1,2,1);
surf(x,y,z);axis equal;
light('Posi',[0,1,1]);
shading interp;
hold on;
plot3(0,1,1,'p');text(0,1,1,'light');
subplot(1,2,2);
surf(x,y,z);axis equal;
light('Posi',[1,0,1]);
shading interp;
hold on;
plot3(1,0,1,'p'); text(1,0,1,'light'); %在给的位置加一个标签

%% 图形的剪裁-剪掉x,y都小于0的部分
clear;
[x,y] = meshgrid(-5:0.1:5);
z = cos(x).*cos(y).*exp(-sqrt(x.^2+y.^2)/4);
surf(x,y,z); shading interp;
pause
i = find(x<=0 &y<=0); %找到x,y小于0的部分,i是一个列向量
z1 = z; z1(i) = NaN; %对应位置置空-not a number
surf(x,y,z1); shading interp;

%图片读入读出
[x,cmap] = imread('123.jpg'); %读取图像的数据阵和 色图阵
image(x); colormap(cmap);
axis image off %保持高度比并取消坐标轴

%动画图
[x,y,z] = peaks(30);
surf(x,y,z)
axis([-3,3,-3,3,-10,10]);
axis off;
shading interp;
colormap(hot);
m = moviein(20); %建立一个20列的大矩阵
for i = 1:20
    view(-37.5+24*(i-1),30) %改变试点
    m(:,i) = getframe; %将图片保存在m矩阵中
end
movie(m,2); %播放画面2次

%% 参数方程画图
clear;
t = 0:pi/50:10*pi;
x = sin(t);
y = cos(t);
z = t;
plot3(x,y,z)
grid on






























