function T2 = KnotInsert(e1,e2,T1,q)

%--This function performs knot insertion using Oslo's knot insertion
%algorithm

%--Input Variable:
%e1: coarse level knot vector
%e2: fine levle knot vector
%T1: initial coefficient matrix
%q: degree of B-spline

%--Output Variable:
%T2: coefficient matrix after knot insertion

T2 = zeros(length(e2)-q-1,length(e1)-q-1);
for i =1:length(e2)-q-1
    for j = 1:length(e1)-q-1
        if(e1(j+q)-e1(j)==0 && e1(j+1+q)-e1(j+1)~=0)
            T2(i,j) = (e1(j+q+1) - e2(i+q))/(e1(j+q+1)-e1(j+1))*T1(i,j+1);
        end
        if(e1(j+q)-e1(j)~=0 && e1(j+q+1)-e1(j+1)==0)
            T2(i,j) = (e2(i+q)-e1(j))/(e1(j+q)-e1(j))*T1(i,j);
        end
        if(e1(j+q)-e1(j)~=0 && e1(j+q+1)-e1(j+1)~=0)
            T2(i,j) = (e2(i+q)-e1(j))/(e1(j+q)-e1(j))*T1(i,j)+ (e1(j+q+1)-e2(i+q))/(e1(j+q+1)-e1(j+1))*T1(i,j+1);
        end
    end
end
end