%% 求解方程组
clear
a = input('a=? ');
b = input('b=? ');
c = input('c=? ');
d = b^2 - 4*a*c; %计算代尔塔
x = [(-b + sqrt(d))/(2*a),(-b-sqrt(d))/(2*a)];
disp(['x1= ',num2str(x(1)),' x2= ',num2str(x(2))]);

%% 大写转小写，字符转数字
clear
c = input('请输入一个字符：(不是字符串)','s');
if c >= 'A'& c <='Z'
    disp(setstr(abs(c)+abs('a')-abs('A')));
elseif c >= 'a' & c <='z'
    disp(setstr(abs(c)-abs('a')+abs('A')));
elseif c >= '0' & c <= '9'
    disp(abs(c)-abs('0'));
else
    disp(c);
end

%switch语句
price = input('输入一个价格，查看打折信息');
switch fix(price/100)
    case {0,1}
    rate = 0;
    case {2,3,4}
        rate = 3/100;
    case num2cell(5:9)
        rate = 5/100;
    case num2cell(10:24)
        rate = 8/100;
    case num2cell(25:49)
        rate = 10/100;
    otherwise
        rate = 14/100;
  end
       price = price*(1-rate)
       
%求矩阵的乘积(维数相同时)，若出错，则求点乘
A = [1,2,3;4,5,6];
B = [7,8,9;10,11,12];
try
    C = A*B;
catch
    C = A.*B;
end
C
lasterr %显示错误信息

%输出水仙花数，数字的立方和==本生
for m = 100:999
    m1 = fix(m/100); %求m的百位数
    m2 = rem(fix(m/10),10); %求m的十位数
    m3 = rem(m,10); %求M的个位数字
    if m == m1*m1*m1 + m2*m2*m2 + m3*m3
        disp(m)
    end
end

%求各行元素之和
s = 0;
a = [12,13,14;15,16,17;18,19,20;21,22,23];
for k = a %按行循环
    s = s +k; %s是一个列向量
end
disp(s'); %加撇号表示转置

%while循环,输入若干个数，0结束，求平均数
sum = 0;
cnt = 0;
val = input('输入一个数，（以0结束）');
while (val ~= 0)
    sum = sum + val;
    cnt = cnt +1;
    val = input('输入一个数');
end
if (cnt > 0)
    sum
    mean = sum/cnt
end
                
%循环嵌套,求完数，
for m = 1:500
    s = 0;
    for k = 1:m/2
        if rem(m,k) == 0
            s = s+k;
        end
    end
    if m == s
        disp(m);
    end
end






