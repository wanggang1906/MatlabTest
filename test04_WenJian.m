%% �ļ�����,�洢ħ������
clear;
fid = fopen('magic5.dat','W');
cnt = fwrite(fid,magic(5),'int32');
fclose(fid);

%% ����ͼ��-��������Ϊ��������
x = 0:pi/100:2*pi;
y = 2*exp(-0.5*x).*cos(4*pi*x);
plot(x,y) %ֻ��һ������ʱ�������±�Ϊ�����꣬Ԫ��ֵΪ�����������ͼ

% ���ƶ�������
x1 = linspace(0,2*pi,100);
x2 = linspace(0,3*pi,100);
x3 = linspace(0,4*pi,100);

y1 = sin(x1);
y2 = 1 + sin(x2);
y3 = 2 + sin(x3);
x = [x1;x2;x3]';
y = [y1;y2;y3]';
plot(x,y,x1,y1-1)

% ������������
x = 0:pi/100:2*pi;
y1 = 0.2*exp(-0.5*x).*cos(4*pi*x); %��˱�ʾ�������
y2 = 2*exp(-0.5).*cos(pi*x);
plotyy(x,y1,x,y2); %������������

%ͼ�α���(��ˢ��)
x = 0:pi/100:pi;
y1 = 0.2*exp(-0.5*x).*cos(4*pi*x);
plot(x,y1)
hold on %����ԭ��ͼ��
y2 = 2*exp(-0.5*x).*cos(pi*x);
plot(x,y2);
hold off %ˢ��ͼ��

%% �߱��
clear;
x = linspace(0,2*pi,1000);
y1 = 0.2*exp(-0.5*x).*cos(4*pi*x);
y2 = 2*exp(-0.5*x).*cos(pi*x);
k = find(abs(y1-y2) < le -2);%%%%%%%%%%%�д�
x1 = x(k); %y1��y2��ȵ��x����
y3 = 0.2*exp(-0.5*x1).*cos(4*pi*x1);
plot(x,y1,x,y2,'k:',x1,y3,'bp');

%% ͼ�α�ע
clear;
x = 0:pi/100:2*pi;
y1 = 2*exp(-0.5*x);
y2 = cos(4*pi*x);
plot(x,y1,x,y2)
title('x Ϊ0-2{\pi}');
xlabel('X����');
ylabel('Y����');
text(0.8,1.5,'����y1=2^e{-0.5x}');
text(2.5,1.1,'����y2=cos(4{\pi}x)');
legend('y1','y2')

%% �������
t = 0:0.01:2*pi;
x = exp(i*t);
y = [x;2*x;3*x]';
plot(y)
grid on; %��������
box on; %������߿�
axis equal %��������õȿ̶�

%�Ժ�������Ӧ�����Ļ�ͼ����
fplot('cos(tan(pi*x))',[0,1],le-4) %%%%%%%%%%����

%������ͼ
t = 0:pi/50:2*pi;
r = sin(t).*cos(t);
polar(t,r,'-*');

%% ͳ�Ʒ���ͼ
clear;
x = 0:pi/10:2*pi;
y = 2*sin(x);
subplot(2,2,1);bar(x,y,'g');%1 ����ͼ
title('bar(x,y,''g'')');axis([0,7,-2,2]);
subplot(2,2,2);stairs(x,y,'b');%2 ����ͼ
title('stairs(x,y,''b'')');axis([0,7,-2,2]);
subplot(2,2,3);stem(x,y,'k');%3 ��ͼ
title('stem(x,y,''k'')');axis([0,7,-2,2]);
subplot(2,2,4);fill(x,y,'y');%4 ���ͼ
title('fill(x,y,''y'')');axis([0,7,-2,2]);

%��������ͼ
clear;
subplot(2,2,1);
ezplot('x^2+y^2-9');axis equal
subplot(2,2,2);
ezplot('x^3+y^3-5*x*y+1/5');
subplot(2,2,3);
ezplot('cos(tan(pi*x))',[0,1])
subplot(2,2,4);
ezplot('8*cos(t)','4*sqrt(2)*sin(t)',[0,2*pi])

%% ��άͼ��
clear;
t = 0:pi/100:20*pi;
x = sin(t);
y = cos(t);
z = t.*sin(t).*cos(t);
plot3(x,y,z);
title('de');
xlabel('X');ylabel('Y');zlabel('Z');
grid on;

%�������溯��ͼ-��������
[x,y] = meshgrid(0:0.25:4*pi); %meshgrid����-����ƽ�������ڵ������������
%������������x��ÿһ�ж�������x��������������y��Ԫ�ظ���������y��ÿһ�ж�������y��������������x��Ԫ�صĸ���
z = sin(x+sin(y))-x/10;
mesh(x,y,z);
axis([0 4*pi 0 4*pi -2.5 1]);

%��ƽ�������ڻ���4����ά����
[x,y]=meshgrid(-8:0.5:8); %����ƽ���������
%���������x����x,
z=sin(sqrt(x.^2+y.^2))./sqrt(x.^2+y.^2+eps);
%esp=esp(1),����һ��������С���������ȣ�һ�����ڷ�ĸ�Ϸ�ֹ��ĸ������
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

%% ��ά����ͼ�� sphere,cylinder,peaks
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

%$ ��ά��ͼ...
clear;
subplot(2,2,1);
bar3(magic(4)) %��ά����ͼ-�н���
subplot(2,2,2);
y=2*sin(0:pi/10:2*pi);
stem3(y); %��ά��ͼ
subplot(2,2,3);
pie3([2347,1827,2043,3025]); %��ά��ͼ-����������
subplot(2,2,4);
fill3(rand(3,5),rand(3,5),rand(3,5), 'y' ) %��ά���ͼ

%% ���ƶ�庯�����ٲ�ͼ�͵ȸ���
clear;
subplot(1,2,1);
[X,Y,Z]=peaks(30);
waterfall(X,Y,Z) %�ٲ�ͼ
xlabel('X-��'),ylabel('Y-axis'),zlabel('Z-axis');
subplot(1,2,2);
contour3(X,Y,Z,12,'k');     %����12����߶ȵĵȼ�������ʾ��12���ȸ���
xlabel('X-axis'),ylabel('Y-axis'),zlabel('Z-axis');

%% ͼ������-�Ե㴦��view(az-��λ��,el-����)-��Ĭ��ֵ
%��ɫ����
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
surf(x,y,z); shading interp; %����⻬
axis equal

%���մ���������
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
plot3(1,0,1,'p'); text(1,0,1,'light'); %�ڸ���λ�ü�һ����ǩ

%% ͼ�εļ���-����x,y��С��0�Ĳ���
clear;
[x,y] = meshgrid(-5:0.1:5);
z = cos(x).*cos(y).*exp(-sqrt(x.^2+y.^2)/4);
surf(x,y,z); shading interp;
pause
i = find(x<=0 &y<=0); %�ҵ�x,yС��0�Ĳ���,i��һ��������
z1 = z; z1(i) = NaN; %��Ӧλ���ÿ�-not a number
surf(x,y,z1); shading interp;

%ͼƬ�������
[x,cmap] = imread('123.jpg'); %��ȡͼ���������� ɫͼ��
image(x); colormap(cmap);
axis image off %���ָ߶ȱȲ�ȡ��������

%����ͼ
[x,y,z] = peaks(30);
surf(x,y,z)
axis([-3,3,-3,3,-10,10]);
axis off;
shading interp;
colormap(hot);
m = moviein(20); %����һ��20�еĴ����
for i = 1:20
    view(-37.5+24*(i-1),30) %�ı��Ե�
    m(:,i) = getframe; %��ͼƬ������m������
end
movie(m,2); %���Ż���2��

%% �������̻�ͼ
clear;
t = 0:pi/50:10*pi;
x = sin(t);
y = cos(t);
z = t;
plot3(x,y,z)
grid on






























