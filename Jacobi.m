
%Jacobi��������MATLAB�����ļ�Jacobi.m���£�
function [y,n]=jacobi(A,b,x0,eps)
if nargin==3
    eps=1.0e-6;
elseif nargin<3
    error
    return
end      
D=diag(diag(A));    %��A�ĶԽǾ���
L=-tril(A,-1);       %��A����������
U=-triu(A,1);       %��A����������
B=D\(L+U);
f=D\b;
y=B*x0+f;
n=1;                  %��������
while norm(y-x0)>=eps
    x0=y;
    y=B*x0+f;
    n=n+1;
end
