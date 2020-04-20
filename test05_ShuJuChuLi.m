% ���ݷ����Ͷ���ʽ����
%% ���Զ���ʵʱ�ű�
% �����������ѧ��ģʵ��
clear;
G = 6.67e-11; dt = 24*3600; N = 3;
% ����̫���͵����������Ա���
sun.mass = 100;
earth.mass = 20;
moon.mass = 5;
% ̫��������������λ��
sun.position = 1;
earth.position = 2;
moon.position = 3;
% ���ߵ��ٶ�
sun.velocity = 0; 
earth.velocity = 10; 
moon.velocity = 5;

M = [sun.mass; earth.mass; moon.mass]; %sun.massû���壬���ǽṹ�������͵�����
R = [sun.position; earth.position; moon.position];
V = [sun.velocity; earth.velocity; moon.velocity];
for t = 1:365
    F = zeros(N,3); % F��ʾ���������ܵ�������(x,y,z)��
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
disp('���н���');
%% dir(�ļ���)-���Ի�ȡ�ļ�����
%
clear;
y = imread('123.jpg');
disp('ͼ��Ĵ�С��')
size(y)
image(y)

%% ���ֵ����׼����ϵ������
clear;
x = randn(10000,5);
m = mean(x);
disp(m);
d = std(x);
disp(d);
r = corrcoef(x);
disp(r);
%% ������ֵ
clear;
h = 6:2:18;
t = [18,20,22,25,30,28,24;15,19,25,28,34,32,30]';
X1 = 6.5:2:17.5;
Y1 = interp1(h,t,X1,'spline'); %��3��������ֵ����
plot(Y1) %���л���

%% ��ά���Բ�ֵ
clear;
x = 0:2.5:10; %
h = (0:30:60)';
T = [95,14,0,0,0;
    88,48,32,12,6;
    67,64,54,48,41]; %����������¶�
xi = (0:10); % ÿ��1��
hi = (0:20:60)'; % ÿ��20��
T1 = interp2(x,h,T,xi,hi); % interp2�����Դ������ڲ�ֵ
disp(T1)

%% ��ɢ����Ҷ�任
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
xlabel('����Ҷ�任');
ylabel('|F(k)|')

%% ����ʽ�������������ʽ
P = [3,0,4,-5,-7.2,5];
X = roots(P); %�󷽳̸�
G = poly(X); %�����ʽ











