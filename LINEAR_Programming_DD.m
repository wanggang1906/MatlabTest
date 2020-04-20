%deal with
load('DD.mat')
Temp = ISGMSDD;  %initialize the worksapce(Insample) change the variable to calculate different cases
M = 1e9;%M is an abitry large number%这是10的9次方，前面的是一
alpha=[0,1.91371e-4,3.80892e-4,9.38713e-4,1.481116e-3,1.834569e-3,2.691345e-3];
%alpha参数的含义-迭代时的过程量

n = Temp(1,1);    %num of securities %取第1行，第1列元素
T = Temp(2,1);    %num of scenarios
pt = Temp(3,1);   %prob of each scenarios

% pt = 1/T;
Temp(1:3,:) = [];   %前三行所有列置空
[Bench_Row,Column] = size(Temp); %获取矩阵的行数和列数
Benchmark = Temp(Bench_Row,:);   %the benchmark of each scenarios
Temp(Bench_Row,:) = [];          %matrix change to n securities * T scenarios
Mean_security_rate = mean(Temp');  %this is week_mean_rate 
Portfolio = zeros(n,length(alpha));
x = 0;
for i=1:length(alpha)
    x = x+1;
    fprintf('迭代次数：%d',x);
    Alpha =alpha(i);
benchAlpha = Benchmark +Alpha;

%%generate the coefficent matrix of equality constaints
% Aeq
%Aeq等式约束的系数矩阵 
Aeq = zeros ( T + 3, n + 2*T + 2 );
Aeq(1,1:n)=1;
Aeq(1:2,n+1:n+2) = -eye(2,2);
Aeq(2,1:n) = Mean_security_rate;
Aeq(3:T+2,1:n) = Temp';
Aeq(1:T+2,n+1:n+T+2) = -eye(T+2,T+2);
Aeq(T+3,n+T+3:n+2*T+2) = pt*ones(1,T);

% beq
%beq等式约束的常向量
beq = zeros(T + 3,1);
beq(T+3) = 1;

%%generate the coefficient matrix of inequality constraints
%A
%A不等式约束的系数矩阵
A = zeros(2*T+n+1, n+2*T+2);
A(1,n+1) = 1;
A(2:n+1,1:n) = -eye(n,n);
A(n+2:n+T+1,n+1) = (mean(Benchmark)+Alpha)*ones(T,1);
A(n+2:n+2*T+1,n+3:n+2+2*T) = -eye(2*T,2*T); 
A(n+2:n+T+1,n+3+T:n+2+2*T) = -eye(T,T);

%b
%b不等式约束的常向量
b = zeros(2*T+n+1,1);
b(1) = M;  %%M an abitry large number

%f
%
f = zeros(2*T + n + 2,1);
f(n+1) =mean(Benchmark) + Alpha;
f(n+2) = -1;

%%FOR the scale of security we should use different methods
if n<=0
x_cplex = cplexlp(f,A,b,Aeq,beq);
portfolio = x_cplex(1:n);
%index = find(portfolio~=0);    %we need a n*1 vector next,so don't have to
%change the size of the vector
%portfolio = portfolio(find(portfolio~=0));
portfolio = portfolio/sum(portfolio);
Portfolio(:,i) = portfolio;
Num_security = n -length(find(portfolio==0));
Max_percent = max(portfolio);
Min_percent = min(portfolio(find(portfolio~=0)));
if abs(x_cplex(n+1)-M)<0.1
    fprintf('You must improve Alpha!');
end
else

%%%using cvx
%调用的求解器？？？默认求解器？
cvx_setup
cvx_begin 
variable X_cvx(n+2+2*T,1)
minimize(f'*X_cvx)
subject to 
  Aeq*X_cvx == beq 
  A*X_cvx <= b
cvx_end 


portfolio = X_cvx(1:n);
%index = find(portfolio~=0);    %we need a n*1 vector next,so don't have to
%change the size of the vector
%portfolio = portfolio(find(portfolio~=0))
per = portfolio/X_cvx(n+1);
%clear the security that we buy less than 0.1%
z=find((portfolio/X_cvx(n+1))<1e-4);
portfolio(z)=0;
Portfolio(:,i) = portfolio/sum(portfolio);
portfolio = portfolio/sum(portfolio);
Num_security = n -length(find(portfolio==0));
Max_percent = max(portfolio);
Min_percent = min(portfolio(find(portfolio~=0)));

if (abs(X_cvx(n+1)-M) <0.1)
    fprintf('You must improve Alpha!');
end
end
end


