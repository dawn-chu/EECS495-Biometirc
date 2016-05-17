function [b] = totalpca(dir,num1,num2,num3,num4)

t = zeros(1200, num2-num1+1);
for q=num1:num2
    
    fn = strcat(dir,num2str(q));
    e = strcat(fn,'.png');
    Img = imread(e);
    I = rgb2gray(Img); 
    
    subplot((num2-num1+1)/4,4,q-num1+1);
    I = im2double(I);
    I = imresize(I,[40 30]);
    imshow(I);
    
    a = reshape(I, [1200,1]);
    t(:,q-num1+1) = a;
    
end


g = zeros(1200, num4-num3+1);
for q=num3:num4
    
    fn = strcat(dir,num2str(q));
    e = strcat(fn,'.png');
    Img = imread(e);
    I = rgb2gray(Img); 
    
    subplot((num4-num3+1)/4,4,q-num3+1);
    I = im2double(I);
    I = imresize(I,[40 30]);
    imshow(I);
    
    a = reshape(I, [1200,1]);
    g(:,q-num3+1) = a;
    
end

b = zeros(1200, num4-num1+1);
for q=num1:num4
    
    fn = strcat(dir,num2str(q));
    e = strcat(fn,'.png');
    Img = imread(e);
    I = rgb2gray(Img); 
    
    subplot((num4-num1+1)/4,4,q-num1+1);
    I = im2double(I);
    I = imresize(I,[40 30]);
    imshow(I);
    
    a = reshape(I, [1200,1]);
    b(:,q-num1+1) = a;
   
end

i = 1;
number = 32;
area = 1200;
h = 40;
w = 30;
%%calculate the mean
mean = zeros(area,1);
while i <= number
    mean = b(:,i) + mean;
    i = i + 1;
end
mean = mean/number;
imshow(reshape(mean(:,1),[h w]))
figure(1);
 
i = 1;

S = zeros(area,area);
%%find the scatter matrix
while i <= number;
    S = S + (b(:,i) - mean)*(b(:,i) - mean)';
    i = i + 1;
end
S = S/number;
%%find the eigenvector of Scatter Matrix
[W D] = eig(S);%W is the eigenvector and D is the corresponding eigen value
A = ones(area,1);
z = D*A;%% put all the eigen value in a vector

%%sort the eigen vector W in descend order.
n = [z W'];
n = sortrows(n,-1);
W = n(1:area,2:area+1)';
z = sort(z,'descend');
nonezeroW = W(1:area,1:number-1);%% select the nonezero eigen vector.

%%show the biggest nonezero eigenvectors

i = 1;
while i <= 3
    figure(2);
    subplot(2,3,i);
imshow(reshape(nonezeroW(:,i),[h w]), [ ])
i = i + 1;
end

%%show the least nonezero eigenvectors
i = number-3;
while i <= number-1;
    subplot(2,3,i-number+7);
    imshow(reshape(nonezeroW(:,i),[h w]), [ ])
    i = i + 1;
end

tnumber = 16;

%%project sample on the PCA subspace
result = zeros(tnumber,number);
i = 1;
accurate = zeros(number-1,1);
for n = 1:number-1
    A = nonezeroW(1:area,1:n)'*t;
    B = nonezeroW(1:area,1:n)'*g;
    for i = 1:tnumber
        marker = 99999999999999;
        label = 0;
        for j = 1:tnumber
            a = norm(A(:,i) - B(:,j));
            if(a < marker)
                marker = a;
                result(i,n) = j;
            end
        end
        if(mod(result(i,n), 2) == (mod(i,2)))
            accurate(n,1) = accurate(n,1) + 1;  
        end
    end
end
accurate = accurate./tnumber;
figure(3);
plot(accurate(:,1));

accuracy = 0;
%%calculate the accuracy without projection on PCA subspace
    for i = 1:tnumber
        marker = 99999999999999;
        label = 0;
        for j = 1:tnumber
            a = norm(t(:,i) - g(:,j));
            if(a < marker)
                marker = a;
                result(i,number) = j;
            end
        end
        if(mod(result(i,n), 2) == (mod(i,2)))
            accuracy = accuracy + 1;  
        end
    end
    
accuracy = accuracy/tnumber;
accuracy = accuracy * ones(1,number);
figure(4);
plot(accuracy);
