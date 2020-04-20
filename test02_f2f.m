%这是一个函数文件,在命令行输入函数名调用
function c = test02_f2f(f)%此处为当前文件名，这一行是引导行
%function 输出形参表 = 函数名（输入形参表）
c = 5*(f-32)/9

%函数的调用，[输出实参表] = 函数名（输入实参表）


%递归求阶乘
function f = factor(n)
if n <= 1
    f = 1;
else
    f = factor(n-1)*n;
end




