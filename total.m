function [b] = total(dir,num1,num2,num3,num4)

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

number = 32;
tnumber = 16;
area = 1200
h = 40;
w = 30;

mean = zeros(area,1)
for i = 1: number;
    mean = b(:,i) + mean;
end
mean = mean/number;

SI = zeros(area,area);
for i = 1:number/2;
    SI = (b(:,(2*i-1)) - b(:,(2*i)))*(b(:,(2*i-1)) - b(:,(2*i)))' + SI;
end

[W D] = eig(SI);
account = zeros(area,1);
for i = area:1;
    account(i,1) = i;
end

A = ones(area,1);
z = D*A;
n = [z account W'];

n = sortrows(n,-1);
W = n(1:area,3:area+2)';
nonezeroW = W(1:area,1:number/2);%%non-zero eigenvectors
figure(1);

for i = 1:16;
    subplot(2,8,i);
    imshow(reshape(nonezeroW(:,i),[h w]),[]);
end


prj_T = nonezeroW'*t;
prj_G = nonezeroW'*g;

a = zeros(tnumber,number/2);

accuracy = zeros(number/2,1);
for N = 1: number/2;%for different number of eigenvectors
    for i = 1:tnumber; %for ith test sample.
        label = 99999999999;
        for k = 1:tnumber;%find the matched k
            DIFS = 0;
            for j = 1:N;
                DIFS = (prj_T(j,i) - prj_G(j,k))^2/n(j,1) + DIFS;
            end
            if(DIFS < label)
                label = DIFS;
                a(i,N) = k;
            end
        end
        if (mod(i,2) == mod(a(i,N),2))
            accuracy(N,1) = accuracy(N,1) + 1;
        end 
    end 
end 
figure(2);
a = accuracy/tnumber;
plot(a);

    