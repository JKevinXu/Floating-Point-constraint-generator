%Coded by Gene Der Su for ECS 260
%FP generator Project
%Tester
%counting the time and the satisfaction rate of our floating-point
%generator

clear
clc

%varibales determine the property of the constrants, can be changed
run=10000;  %number of run, run = [1,inf)
n=5;        %number of variables, n = [1,5]
m=2;        %max exponent, m = [1,5]

%initialize constants, do not change
count=0;
countsignf=[0 0 0 0 0];
unsatCount=0;
totalTime=0;

for i_run=1:run
    %create random constrant 
    c=zeros(5);
    c(1:n,1:m)=rand(n,m)*2-1;
    k=2*rand(1)-1;
    signf=mod(floor(rand(1)*10),5);

    %counting time for the algorithm to solve the constrant
    tstart = tic;
    [r x] = FPGenerator(n,m,c,k,signf);  
    telapsed = toc(tstart);
    totalTime=totalTime+telapsed;
    
    %counting number of unsatisfiable constraints
    if r==0
        unsatCount=unsatCount+1;
    end
    
    %checking if x satisfies
    tol=0;
    for i=1:length(x)
        if x(i)~=0
            tol=abs(x(i))*10^-3*5;
            break
        end
    end
    f = func(x,c);
    if signf==0&&f<k
        count=count+1;
    elseif signf==1&&f>k-tol&&f<k+tol
        count=count+1;
    elseif signf==2&&f>k
        count=count+1;
    elseif signf==3&&f<=k+tol
        count=count+1;
    elseif signf==4&&f>=k-tol
        count=count+1;
    end
        
end
unsatCount
count
pecentSAT=count/(run-unsatCount)
totalTime
timePerRun=totalTime/run