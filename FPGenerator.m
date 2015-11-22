%Coded by Gene Der Su for ECS 260
%FP generator Project
%FPGenerator
%Input: number of variables n, max exponent m, coefficients c, constant k, 
%and equality of the constraint signf
%Output: the result whether the constraint is satisfiable r (1 as 
%satisfiable and 0 as unsatisfiable) and the generated FP values x

function [r x] = FPGenerator(n,m,c,k,signf)
    r=1;
    
    if mod(m,2)~=0
    %for odd exponents
        %concretize all the variables to 1 except for the first variable 
        x=[0 1 1 1 1]; 
        %collect all the constants to left side of the equation and call it z
        z=func(x,c)-k;
        %if we are trying to a less or less or equal, we are really solving
        %for a value that will be k-5 and vise versa 
        if signf==0||signf==3
            z=z+5;
        elseif signf==2||signf==4
            z=z-5;
        end
        %convert into polynormial that Matlab recognizes. 
        y=[c(1,5) c(1,4) c(1,3) c(1,2) c(1,1) z];
        %use Matlab's build in function to solve for roots
        rt=roots(y);
        %finding the first real roots and use it as the solution
        for i=1:length(rt)
            if isreal(rt(i))==1
                x(1)=rt(i);
            end
        end
    else      
    %for even exponents
        %check if the function is satisfiable
        %xm gives [x_i that gives min/max, y_i(x_i), min(1) or max(-1)]
        xm=zeros(n,3);
        %interval gives [global max, global min, number of max exist, number of min exist]  
        interval=[0 0 0 0];
        %construct xm
        for i=1:n
            %putting the derivative of x_i into a Matlab polynormial
            ym=[4*c(i,4) 3*c(i,3) 2*c(i,2) c(i,1)];
            %finding the max/min of x_i
            rt=roots(ym);
                for j=1:length(rt)
                    if isreal(rt(j))==1
                        a=rt(j);
                        b=c(i,4)*a^4+c(i,3)*a^3+c(i,2)*a^2+c(i,1)*a;
                        %checking if the value is a max/min
                        if xm(i,3)==0
                            xm(i,1)=a;
                            xm(i,2)=b;
                            xm(i,3)=sign(c(i,m)); %-1 means finding a max, 1 means finding a min
                        elseif (xm(i,3)==-1&&b>xm(i,2))||(xm(i,3)==1&&b<xm(i,2))
                            xm(i,1)=a;
                            xm(i,2)=b;
                        end
                    end
                end
            %calculate the global max/min and the number of max/min exist
            if xm(i,3)==-1
                interval(1)=interval(1)+xm(i,2);
                interval(3)=interval(3)+1;
            elseif xm(i,3)==1
                interval(2)=interval(2)+xm(i,2);
                interval(4)=interval(4)+1;
            end
        end
        
        %%count the number of unsatisfiable constraints
        if interval(3)~=0&&interval(4)~=0&&interval(1)>=interval(2)
            %%do nothing becasue the interval covers everything
        else
            %in any of the following case the constraint is unsatisfiable,
            %mark r=0
            if signf==0&&interval(3)==0&&k<interval(2)
                r=0;
            elseif signf==1
                if interval(3)==0&&k<interval(2)
                    r=0;
                elseif interval(4)==0&&k>interval(1)
                    r=0;
                elseif interval(3)~=0&&interval(4)~=0&&k<interval(2)&&k>interval(1)
                    r=0;
                end
            elseif signf==2&&interval(4)==0&&k>interval(1)
                r=0;
            elseif signf==3&&interval(3)==0&&k<=interval(2)
                r=0;
            elseif signf==4&&interval(4)==0&&k>=interval(1)
                r=0;
            end
        end
        
        x=[0 0 0 0 0];
        z=-k;
        index=1;
        %when possible, solve the constraint
        if r==1
            if signf==0||signf==3
                if sum(xm(:,3))==5
                    for i=1:n
                        if xm(i,2)<k
                            index=i;
                            break;
                        end
                    end
                else
                    for i=1:n
                        if xm(i,3)==-1&&xm(i,2)>k
                            index=i;
                            break;
                        end
                    end
                end
                z=z+abs(xm(index,2)-k)/2;
                y=[c(index,4) c(index,3) c(index,2) c(index,1) z];
                rt=roots(y);
                for i=1:length(rt)
                    if isreal(rt(i))==1
                        x(index)=rt(i);
                    end
                end
            elseif signf==2||signf==4
                if sum(xm(:,3))==-5
                    for i=1:n
                        if xm(i,2)>k
                            index=i;
                            break;
                        end
                    end
                else
                    for i=1:n
                        if xm(i,3)==1&&xm(i,2)<k
                            index=i;
                            break;
                        end
                    end
                end
                z=z-abs(xm(index,2)-k)/2;
                y=[c(index,4) c(index,3) c(index,2) c(index,1) z];
                rt=roots(y);
                for i=1:length(rt)
                    if isreal(rt(i))==1
                        x(index)=rt(i);
                    end
                end
            else
                if k>interval(1)
                    for i=1:n
                        if xm(i,3)==1&&xm(i,2)<k
                            index=i;
                            break;
                        end
                    end
                else
                    for i=1:n
                        if xm(i,3)==-1&&xm(i,2)>k
                            index=i;
                            break;
                        end
                    end
                end
                y=[c(index,4) c(index,3) c(index,2) c(index,1) z];
                rt=roots(y);
                for i=1:length(rt)
                    if isreal(rt(i))==1
                        x(index)=rt(i);
                    end
                end
            end
        end
    end
end