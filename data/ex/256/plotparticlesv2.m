for i=1:140; 
load parts.dat
t=i*0.05*100;
time=parts(:,1);
index=find(abs(time-t) < 0.01);
species=parts(index,2);
xpos=parts(index,3);
ypos=parts(index,4);
zpos=parts(index,5);
N=length(index);
count1=0;
count2=0;
for i=1:N;
if species(i)< 1.5;
count1=count1+1;
x1(count1)=xpos(count1);
y1(count1)=ypos(count1);
z1(count1)=zpos(count1);
else
count2=count2+1;
x2(count2)=xpos(count2);
y2(count2)=ypos(count2);
z2(count2)=zpos(count2);
end
end
r1=1.2*ones(length(x1),3);
r2=1.2*ones(length(x2),3);
m=1000;
bubbleplot3(x1,y1,z1,r1,[0 1 0],0.9);
camlight right; lighting phong; view(60,30);
hold on;
bubbleplot3(x2,y2,z2,r2,[1 0 0],0.9);
camlight right; lighting phong; view(60,30);
%axis off
title(t)
pause(0.01);
clear;close;
end;
