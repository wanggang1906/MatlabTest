function [Portfolio]=or_model(temp_in_sample,temp_out_sample)
    Temp = temp_in_sample;  %initialize the worksapce(Insample) change the variable to calculate different cases
    M = 1e3;%M is an abitry large number
    alpha=[0,1.91371e-4,3.80892e-4,9.38713e-4,1.481116e-3,1.834569e-3,2.691345e-3];

    n = Temp(1,1);    %num of securities
    T = Temp(2,1);    %num of scenarios
    pt = Temp(3,1);   %prob of each scenarios

    % pt = 1/T;
    Temp(1:3,:) = [];   
    [Bench_Row,Column] = size(Temp);
    Benchmark = Temp(Bench_Row,:);   %the benchmark of each scenarios
    Temp(Bench_Row,:) = [];          %matrix change to n securities * T scenarios
    Mean_week_rate = mean(Temp');  %this is week_mean_rate of each security
    Portfolio = zeros(n,length(alpha));
    for i=1:length(alpha)
        Alpha =alpha(i);
    benchAlpha = Benchmark *+Alpha;

    %%generate the coefficent matrix of equality constaints
    % Aeq
    Aeq = zeros ( T + 3, n + 2*T + 2 );
    Aeq(1,1:n)=1;
    Aeq(1:2,n+1:n+2) = -eye(2,2);
    Aeq(2,1:n) = Mean_week_rate;
    Aeq(3:T+2,1:n) = Temp';
    Aeq(1:T+2,n+1:n+T+2) = -eye(T+2,T+2);
    Aeq(T+3,n+T+3:n+2*T+2) = pt*ones(1,T);

    % beq
    beq = zeros(T + 3,1);
    beq(T+3) = 1;

    %%generate the coefficient matrix of inequality constraints
    %A
    A = zeros(2*T+n+1, n+2*T+2);
    A(1,n+1) = 1;
    A(2:n+1,1:n) = -eye(n,n);
    A(n+2:n+T+1,n+1) = (mean(Benchmark)+Alpha)*ones(T,1);
    A(n+2:n+2*T+1,n+3:n+2+2*T) = -eye(2*T,2*T); 
    A(n+2:n+T+1,n+3+T:n+2+2*T) = -eye(T,T);

    %b
    b = zeros(2*T+n+1,1);
    b(1) = M;  %%M an abitry large number

    %f
    f = zeros(2*T + n + 2,1);
    f(n+1) =mean(Benchmark) + Alpha;
    f(n+2) = -1;

    %%%using cvx
    cvx_setup
    cvx_begin 
    variable X_cvx(n+2+2*T,1)
    minimize(f'*X_cvx)
    subject to 
      Aeq*X_cvx == beq 
      A*X_cvx <= b
    cvx_end 


    portfolio = X_cvx(1:n);
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
    %%out_of_sample test
%deal with materials
    Test = temp_out_sample;
    Test(1,:)=[];
    [Order,Test_T] = size(Test);
    Test_cur = Test(1:Order,1:Test_T-1);
    Test_next = Test(1:Order,2:Test_T);
    Test_rate = Test_next./Test_cur - ones(Order,Test_T-1);
    Bench_rate =Test_rate(Order,:);
    Test_rate(Order,:) = [];
    %%%hope to decide the color of each line Col = ['y','m','c','g','b','w','k'];
    for i=1:length(alpha)
        Opt_portfolio = Portfolio(:,i);
        Test_portfolio = Test_rate' * Opt_portfolio;
        Test_curve(1)=0;
        for j = 1:Test_T-1
            Test_curve(j+1) = Test_curve(j) + Test_portfolio(j);
        end
        plot(Test_curve,'--');
        hold on
    end
    Bench_curve(1)=0;
    for k=1:Test_T-1
        Bench_curve(k+1) = Bench_curve(k) + Bench_rate(k);
    end
    plot(Bench_curve,'r');
    set(gca,'xgrid','on'); %%绘制垂直X轴的网格
    set(gca,'ygrid','on'); %%绘制垂直X轴的网格
    xlabel('Time','FontSize',16);
    ylabel('Cumulative Return','FontSize',16);
    set(gca,'xtick',0:4:55) 
    y=zeros(1,Test_T);
    plot(y,'k');
end





