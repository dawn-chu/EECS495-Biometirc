function [a2,b2,r2,r3] = final(dir,num1,num2,tor,tor1,tor2,tor3,step_r,step_angle,r_min,r_max)

for q=num1:num2
    fn = strcat(dir,num2str(q));
    e = (strcat(fn,'.tiff'));

image=imread(e);
xiao=rgb2gray(image);
sigma=9;
thresh=[0.07,0.15];
eye=edge(xiao,'canny',thresh,sigma);
%imshow(eye);


[m,n] = size(eye);
size_r = round((r_max-r_min)/step_r)+1;
size_angle = round(2*pi/step_angle);
hs = zeros(m,n,size_r);
[rows,cols] = find(eye);
ecount = size(rows);
for i = 1:ecount
    for r = 1:size_r
        for k = 1:size_angle
            a = round(rows(i)-(r_min+(r-1)*step_r)*cos(k*step_angle));
            b = round(cols(i)-(r_min+(r-1)*step_r)*sin(k*step_angle)); 
            if(a>0&&a<m&&b>0&&b<=n)
                hs(a,b,r) = hs(a,b,r)+1;
            end
        end
    end
end
maxp = max(max(max(hs)));

[a,b] = find(hs>=(maxp-tor));
k = length(a);

%g=0;
for i = 1:k
    for j = 1:n
        for t = 1:(round((r_max-r_min)/step_r)+1)
            if((hs(a(i),j,t))>=(maxp-tor))
                %g=g+1;
                a2=a(i);
                b2=j;
                r2=t;
                break
            end
        end
    end
end
%a2=round(mean(a1));
%b2=round(mean(b1));
%r2=round(mean(r1));


for i = (a2-tor1):(a2+tor1)
    for j = (b2-tor1):(b2+tor1)
        for t = 1:(round((r_max-r_min)/step_r)+1)
            if((r2>=tor3)&&(hs(i,j,t))>=(maxp*tor2))
                if(t<=0.5*tor3)
                r3=t;
                else
                r3=5;
                end
                break;
            else    
            if((r2<=0.5*tor3)&&(hs(i,j,t))>=(maxp*tor2))
                if(t>=tor3)
                r3=t;
                else
                r3=10;
                end
                break;
            end    
            end    
        end
    end
end

theta = 0:step_angle:2*pi+step_angle;
x1=a2+((r2-1)*step_r+30)*cos(theta);
y1=b2+((r2-1)*step_r+30)*sin(theta);
x2=a2+((r3-1)*step_r+30)*cos(theta);
y2=b2+((r3-1)*step_r+30)*sin(theta);
figure,imshow(image);
hold on;
plot(y1,x1);
hold on;
plot(y2,x2);

w = (strcat(fn,'out.tiff'));
saveas(gcf,w);

end
end