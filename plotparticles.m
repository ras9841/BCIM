load parts.dat
time=parts(:,1);
index=find(abs(time-9.9) < 0.01);
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
scatter3sph(x1,y1,z1,'size',1.2,'color',[1 0 0]);
hold on;
scatter3sph(x2,y2,z2,'size',1.2, 'color',[0 1 0]);
