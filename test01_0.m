%% 凸优化工具包测试
m = 20; n = 10; p = 4;
A = randn(m,n); b = randn(m,1);%产生随机矩阵，一个参数为方阵
C = randn(p,n); d = randn(p,1); e = rand; %rand 0-1的均匀随机分布，即0-1的随机数
cvx_begin
    variable x(n) %变量
    minimize(norm(A * x -b,2))
    subject to
        C * x == d
        norm(x,Inf) <= e %粉色波浪线，是警告，不用处理
cvx_end

%% 托普利兹矩阵
T = toeplitz(1:6)
disp(T) %输出

%% 伴随矩阵
p = [1,0,-7,6];
B = compan(p) %结尾不加分号可以在命令行中显示，加了则不显示

%% (x+y)^5的展开式系数
Pa = pascal(6)

%产生5阶随机矩阵10-90之间的，并判断能否被3整除
Az = fix((90-10+1)*rand(5)+10);
Pz = rem(A,3) == 0%rem()矩阵A对3取余

%找到A中大于4元素的位置
AA = [4,-65,-54,0,6;56,0,67,-45,0];
find(AA>4)
clear %清除变量空间中的所有值

%% 求特征值法解方程
Pf = [3,-7,0,5,2,-18];
A = compan(Pf); %A的伴随矩阵
x1 = eig(A); %A的特征值
x2 = roots(Pf); %直接求多项式的零点
disp(A);
%clear

%% 字符串操作
ch = 'ADS2E3d8s0kJ8sEA';
subch = ch(1:5) %取出前5个元素
revch = ch(end:-1:1) %倒叙取出所有元素
k = find(ch >= 'a'& ch <= 'z'); %找出小写字母的位置
ch(k) = ch(k) - ('a' - 'A'); %将小写字母变成相应的大写字母
char(ch)
length(k) %统计小写字母的个数
clear %ans是默认保存结果的变量，运行会覆盖

%% 结构矩阵
a(1).x4 = '410075'; %其他的成员为空矩阵
a(3).x3 = '410057'; %括号中的为列数
%删除结构成员
a = rmfield(a,'x4');








