%% ��ⷽ����
clear
a = input('a=? ');
b = input('b=? ');
c = input('c=? ');
d = b^2 - 4*a*c; %���������
x = [(-b + sqrt(d))/(2*a),(-b-sqrt(d))/(2*a)];
disp(['x1= ',num2str(x(1)),' x2= ',num2str(x(2))]);

%% ��дתСд���ַ�ת����
clear
c = input('������һ���ַ���(�����ַ���)','s');
if c >= 'A'& c <='Z'
    disp(setstr(abs(c)+abs('a')-abs('A')));
elseif c >= 'a' & c <='z'
    disp(setstr(abs(c)-abs('a')+abs('A')));
elseif c >= '0' & c <= '9'
    disp(abs(c)-abs('0'));
else
    disp(c);
end

%switch���
price = input('����һ���۸񣬲鿴������Ϣ');
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
       
%�����ĳ˻�(ά����ͬʱ)��������������
A = [1,2,3;4,5,6];
B = [7,8,9;10,11,12];
try
    C = A*B;
catch
    C = A.*B;
end
C
lasterr %��ʾ������Ϣ

%���ˮ�ɻ��������ֵ�������==����
for m = 100:999
    m1 = fix(m/100); %��m�İ�λ��
    m2 = rem(fix(m/10),10); %��m��ʮλ��
    m3 = rem(m,10); %��M�ĸ�λ����
    if m == m1*m1*m1 + m2*m2*m2 + m3*m3
        disp(m)
    end
end

%�����Ԫ��֮��
s = 0;
a = [12,13,14;15,16,17;18,19,20;21,22,23];
for k = a %����ѭ��
    s = s +k; %s��һ��������
end
disp(s'); %��Ʋ�ű�ʾת��

%whileѭ��,�������ɸ�����0��������ƽ����
sum = 0;
cnt = 0;
val = input('����һ����������0������');
while (val ~= 0)
    sum = sum + val;
    cnt = cnt +1;
    val = input('����һ����');
end
if (cnt > 0)
    sum
    mean = sum/cnt
end
                
%ѭ��Ƕ��,��������
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






