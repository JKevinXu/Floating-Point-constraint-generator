%Coded by Gene Der Su for ECS 260
%FP generator Project
%func
%input vector x and matrix c, output the answer k


function f = func(x,c)
    f=0;
    for i=5:-1:1
        for j=1:5
            f=f+c(i,j)*x(i)^j;
        end
    end
end