%============braess路网多主体交互===============
clc
clear
close all
OD=xlsread('braess.xlsx','sheet1');%OD需求矩阵
TT=xlsread('braess.xlsx','sheet2');%站点间运行时间矩阵
Dis=xlsread('braess.xlsx','sheet3');%站点间距离矩阵
t=1;
t_T=10;
interact_S=15;%交互范围
N_agent_length=100;%OD内元胞空间边长
M=5;%每天5个出发时刻
tte=20;%早到时间
tta=60;%上班时间
theita=0.7;%效用感知系数
kesei=0.2;%效用系数
theita_l=0.2;%后悔厌恶水平
capacity=100;%拥挤阈值
capacity_bus=100;%公交定员
%==============线路=============
route(1,:)=[1,2,3,6];
route(2,:)=[4,5,2,3];
route(3,:)=[1,4,5,6];
%==============一票制=============
% p_route(1,1)=0.5;p_route(1,2)=0.5;p_route(1,3)=0.5;p_route(1,4)=0.5;p_route(1,5)=0.5;
% p_route(2,1)=0.5;p_route(2,2)=0.5;p_route(2,3)=0.5;p_route(2,4)=0.5;p_route(2,5)=0.5;
% p_route(3,1)=0.5;p_route(3,2)=0.5;p_route(3,3)=0.5;p_route(3,4)=0.5;p_route(3,5)=0.5;
% p_park(1)=14.5485;p_park(2)=13.3904;p_park(3)=14.3227;p_park(4)=13.1489;p_park(5)=13.9455;%停车费
% %=============发车频率============
% f_route(1)=6.5;
% f_route(2)=6.5;
% f_route(3)=6.5;
% [num_station,~]=size(OD);%站点数量
%===================S1==================
% p_route(1,1)=0.8363;p_route(1,2)=0.6187;p_route(1,3)=0.9178;p_route(1,4)=0.5361;p_route(1,5)=0.8272;
% p_route(2,1)=0.6662;p_route(2,2)=0.5677;p_route(2,3)=0.5547;p_route(2,4)=0.7394;p_route(2,5)=0.6452;
% p_route(3,1)=0.8036;p_route(3,2)=0.7206;p_route(3,3)=0.7939;p_route(3,4)=0.9541;p_route(3,5)=0.6532;
% p_park(1)=14.5485;p_park(2)=13.3904;p_park(3)=14.3227;p_park(4)=13.1489;p_park(5)=13.9455;%停车费
% %=============发车频率============
% f_route(1)=8.1573;
% f_route(2)=4.2869;
% f_route(3)=4.3935;
% [num_station,~]=size(OD);%站点数量
%==============S3=============
p_route(1,1)=0.8206;p_route(1,2)=0.9855;p_route(1,3)=0.5739;p_route(1,4)=0.9172;p_route(1,5)=0.5673;
p_route(2,1)=0.8735;p_route(2,2)=0.8285;p_route(2,3)=0.8362;p_route(2,4)=0.9968;p_route(2,5)=0.9226;
p_route(3,1)=0.7126;p_route(3,2)=0.6834;p_route(3,3)=0.9142;p_route(3,4)=0.6178;p_route(3,5)=0.6532;
p_park(1)=14.8155;p_park(2)=13.4649;p_park(3)=13.3287;p_park(4)=13.2043;p_park(5)=13.4900;%停车费
%=============发车频率============
f_route(1)=4.1880;
f_route(2)=4.2008;
f_route(3)=4.3935;
[num_station,~]=size(OD);%站点数量
%==============S5=============
% p_route(1,1)=0.8112;p_route(1,2)=0.9855;p_route(1,3)=0.8397;p_route(1,4)=0.9470;p_route(1,5)=0.5673;
% p_route(2,1)=0.8735;p_route(2,2)=0.8285;p_route(2,3)=0.8362;p_route(2,4)=0.9968;p_route(2,5)=0.9226;
% p_route(3,1)=0.7126;p_route(3,2)=0.6867;p_route(3,3)=0.9142;p_route(3,4)=0.6178;p_route(3,5)=0.6498;
% p_park(1)=14.7777;p_park(2)=13.4731;p_park(3)=13.3287;p_park(4)=13.3319;p_park(5)=13.4900;%停车费
% %=============发车频率============
% f_route(1)=3.4910;
% f_route(2)=4.2008;
% f_route(3)=4.3437;
% [num_station,~]=size(OD);%站点数量
%===========================路网及线路初始化===============
for i=1:num_station
    for j=1:num_station
        cell{i,j}.route_num=0;%线路数量
        cell{i,j}.route=[];
        cell{i,j}.route_length=[];
        cell{i,j}.travel_time_0=[];
        cell{i,j}.travel_time=[];
        cell{i,j}.bus_wait_time=[];
        cell{i,j}.car_wait_time=[];
        cell{i,j}.bus_fare=[];
        cell{i,j}.car_fare=[];
        cell{i,j}.real_route=[];
        cell{i,j}.direction=[];
        cell{i,j}.bus_fee=[];
        cell{i,j}.bus_fee_b=[];
        cell{i,j}.car_fee=[];
        cell{i,j}.car_fee_b=[];
        cell{i,j}.car_regret=[];
        cell{i,j}.bus_regret=[];
        cell{i,j}.dis=[];
        cell{i,j}.departure_fee=[];
        cell{i,j}.wr=[];
        cell{i,j}.wd=[];
        cell{i,j}.friend=[];
        %=========确定每个OD间线路数量与名称============
        for k=1:3
            if ismember(i,route(k,:))&&ismember(j,route(k,:))&&(i~=j)
                cell{i,j}.route_num=cell{i,j}.route_num+1;
                cell{i,j}.route=[cell{i,j}.route,k];%添加线路名称
                cell{i,j}.i_locate(cell{i,j}.route_num,1)=find(ismember(route(k,:),i));%定位起点在线路中的位置
                cell{i,j}.j_locate(cell{i,j}.route_num,1)=find(ismember(route(k,:),j));%定位终点在线路中的位置
                if cell{i,j}.i_locate(cell{i,j}.route_num,1)<cell{i,j}.j_locate(cell{i,j}.route_num,1)%方向
                    cell{i,j}.direction(cell{i,j}.route_num,1)=1;%上行
                else
                    cell{i,j}.direction(cell{i,j}.route_num,1)=-1;%下行
                end
            end
        end
        %==============计算每个OD间的实际路径==============
        cell{i,j}.real_route=zeros(cell{i,j}.route_num,num_station);
        for k=1:cell{i,j}.route_num
            if cell{i,j}.direction(k)==1%上行实际的路径
                cell{i,j}.route_length(k)=size(route(cell{i,j}.route(k),cell{i,j}.i_locate(k,1):cell{i,j}.j_locate(k,1)),2);
                cell{i,j}.real_route(k,1:cell{i,j}.route_length(k))=route(cell{i,j}.route(k),cell{i,j}.i_locate(k,1):cell{i,j}.j_locate(k,1));
            elseif cell{i,j}.direction(k)==-1%下行实际的路径
                cell{i,j}.route_length(k)=size(route(cell{i,j}.route(k),cell{i,j}.j_locate(k,1):cell{i,j}.i_locate(k,1)),2);
                cell{i,j}.real_route(k,1:cell{i,j}.route_length(k))=route(cell{i,j}.route(k),cell{i,j}.j_locate(k,1):cell{i,j}.i_locate(k,1));
            end
        end
        if i~=j
            %===========初始化选择概率,交互范围=================
            cell=rand_r_d_agent(cell,i,j,M,N_agent_length,interact_S);
            %===========初始化出行方式、时间选择==========================
            cell=route_departure_choice(cell,i,j,M,N_agent_length,t);
        end
    end
end
%==========================开始演化=========================
while t<=t_T
    dt=1;
    q=zeros(num_station,num_station,3,M);%路段实时流量矩阵
    while dt<=M%每一时间段
        for i=1:num_station
            for j=1:num_station
                if i~=j
                    %=========选择私家车出行的人数====================
                    cell{i,j}.car_q(dt)=OD(i,j)*numel(find(cell{i,j}.route_choice(:,t)==cell{i,j}.route_num+1&cell{i,j}.depart_choice(:,t)==dt))/N_agent_length;
                    
                    %==========选择公交出行的人数=====================
                    for k=1:cell{i,j}.route_num
                        cell{i,j}.bus_q(k,dt)=OD(i,j)*numel(find(cell{i,j}.route_choice(:,t)==k&cell{i,j}.depart_choice(:,t)==dt))/N_agent_length;
                    end
                    bus_q(i,j)=mean(cell{i,j}.bus_q(:,dt));%检查收敛性
                    %===========广义费用：行程时间、等待时间、票价=================
                    for k=1:cell{i,j}.route_num
                        cell{i,j}.dis(k)=0;%距离
                        cell{i,j}.travel_time_0(k)=0;%零流时间
                        non_zero=cell{i,j}.real_route(k,(find(cell{i,j}.real_route(k,:)~=0)));%提取实际线路
                        for kk=1:length(non_zero)-1
                            cell{i,j}.dis(k)=cell{i,j}.dis(k)+Dis(non_zero(kk),non_zero(kk+1));%行程距离
                            cell{i,j}.travel_time_0(k)=cell{i,j}.travel_time_0(k)+TT(non_zero(kk),non_zero(kk+1));%零流时间
                        end
                        if t==1
                            cell{i,j}.travel_time(k,dt)=cell{i,j}.travel_time_0(k);
                        else
                            cell{i,j}.travel_time(k,dt)=cell{i,j}.travel_time_0(k)*(1+0.15*(cell{i,j}.bus_crowd(k,dt)/capacity)^4);%行程时间
                        end
                        cell{i,j}.bus_fare(k,dt)=p_route(k,dt)*cell{i,j}.dis(k);%公交分时票价
                        cell{i,j}.bus_wait_time(k)=1/f_route(cell{i,j}.route(k));%公交等待时间
                    end
                    dt_arr=dt+floor(min(cell{i,j}.travel_time(:,dt))/10);%到达后付停车费
                    if dt_arr>M
                        dt_arr=M;
                    end
                    cell{i,j}.car_fare(dt)=p_park(dt);%停车费
                    %=========私家车广义费用=================
                    cell{i,j}.car_fee(dt)=kesei*min(cell{i,j}.travel_time(:,dt))+kesei*cell{i,j}.car_fare(dt);
                    %========公交车广义费用==================
                    for k=1:cell{i,j}.route_num
                        if t==1
                            cell{i,j}.bus_fee(k,dt)=kesei*cell{i,j}.travel_time(k,dt)+kesei*cell{i,j}.bus_wait_time(k)+kesei*cell{i,j}.bus_fare(k,dt);
                        else
                            cell{i,j}.bus_fee(k,dt)=kesei*cell{i,j}.travel_time(k,dt)+kesei*cell{i,j}.bus_wait_time(k)+kesei*cell{i,j}.bus_fare(k,dt)+kesei*cell{i,j}.bus_crowd(k,dt)/(f_route(cell{i,j}.route(k))*capacity_bus);
                        end
                    end
                    %========出发时间效用===================
                    cell{i,j}.departure_fee(dt)=sue_fee_dd(cell,i,j,tte,tta,dt);
                    
                end
                
            end
        end
        %============检查收敛性==============
        if t==1
            q_var(t)=0;
        else
            bus_qq(t)=mean(mean(bus_q(:,:)));%检查收敛性
            q_var(t)=abs(bus_qq(t)-bus_qq(t-1))/max(bus_qq(1:t));%检查收敛性
        end
        %=============计算每条线路的使用情况(更新实时路段流量)===============
        q=zeros(num_station,num_station,3,M);%3条线路，5个出发时间
        for ii=1:num_station
            for jj=1:num_station
                for k=1:3
                    if ii==jj
                        q(ii,jj,k,dt)=0;
                    elseif t>1
                        if isempty(find(cell{ii,jj}.route==k))==1
                            q(ii,jj,k,dt)=0;
                        else
                            q(ii,jj,k,dt)=cell{ii,jj}.bus_q(find(cell{ii,jj}.route==k),dt);
                            %===========后续持续占用路径==============
                            travel_time_int=floor(cell{ii,jj}.travel_time(find(cell{ii,jj}.route==k),dt)/10);%行程时间取整
                            for iii=1:travel_time_int
                                if dt+iii<=M
                                    q(ii,jj,k,dt+iii)=cell{ii,jj}.bus_q(find(cell{ii,jj}.route==k),dt);
                                end
                            end
                        end
                    end
                end
            end
        end
        %===========计算每个路段的拥挤程度（上行）================
        for k=1:size(route,1)
            for ii=1:size(route,2)-1
                if route(k,ii)*route(k,ii+1)==0
                    crowd(k,ii,dt,1)=0;%上行
                else
                    if ii==1
                        crowd(k,ii,dt,1)=0;
                        for jj=ii+1:size(route,2)
                            if route(k,jj)~=0
                                crowd(k,ii,dt,1)=crowd(k,ii,dt,1)+q(route(k,ii),route(k,jj),k,dt);
                            end
                        end
                    else
                        q_hou=0;
                        q_qian=0;
                        for jj=ii+1:size(route,2)
                            if route(k,jj)~=0
                                q_hou=q_hou+q(route(k,ii),route(k,jj),k,dt);
                            end
                        end
                        for jj=1:ii
                            if route(k,jj)~=0
                                q_qian=q_qian+q(route(k,jj),route(k,ii),k,dt);
                            end
                        end
                        crowd(k,ii,dt,1)=crowd(k,ii-1,dt,1)+q_hou-q_qian;
                    end
                end
            end
        end
        %===========计算每个路段的拥挤程度（下行）================
        for k=1:size(route,1)
            for ii=size(route,2):-1:2
                if route(k,ii)*route(k,ii-1)==0
                    crowd(k,ii-1,dt,2)=0;%下行
                else
                    if ii==size(route,2)
                        crowd(k,ii-1,dt,2)=0;
                        for jj=ii-1:-1:1
                            if route(k,jj)~=0
                                crowd(k,ii-1,dt,2)=crowd(k,ii-1,dt,2)+q(route(k,ii),route(k,jj),k,dt);
                            else
                                crowd(k,ii-1,dt,2)=0;
                            end
                        end
                    else
                        q_hou=0;
                        q_qian=0;
                        for jj=1:ii-1
                            if route(k,jj)~=0
                                q_hou=q_hou+q(route(k,ii),route(k,jj),k,dt);
                            end
                        end
                        for jj=ii:size(route,2)
                            if route(k,jj)~=0
                                q_qian=q_qian+q(route(k,jj),route(k,ii),k,dt);
                            end
                        end
                        crowd(k,ii-1,dt,2)=crowd(k,ii,dt,2)+q_hou-q_qian;
                    end
                end
            end
        end
        %==================计算每个OD间的拥挤度===================
        for i=1:num_station
            for j=1:num_station
                for k=1:cell{i,j}.route_num
                    if cell{i,j}.direction(k)==1
                        cell{i,j}.bus_crowd(k,dt)=sum(crowd(cell{i,j}.route(k),cell{i,j}.i_locate(k):cell{i,j}.j_locate(k)-1,dt,1));
                    elseif cell{i,j}.direction(k)==-1
                        cell{i,j}.bus_crowd(k,dt)=sum(crowd(cell{i,j}.route(k),cell{i,j}.j_locate(k):cell{i,j}.i_locate(k)-1,dt,2));
                    end
                end
            end
        end
        
        dt=dt+1;
    end
    %=======================更新路径及出发时间选择概率================
    for i=1:num_station
        for j=1:num_station
            if i~=j
                cell=route_departure_update(cell,i,j,t,M,N_agent_length,interact_S);
                cell=route_departure_choice(cell,i,j,M,N_agent_length,t+1);
            end
        end
    end
    
    t=t+1;
end
% f(1)%目标函数1：票价、停车费收入最大化
% f(2)%目标函数2：出行广义费用最小化
for i=1:num_station
    for j=1:num_station
        if i~=j
            for dt=1:M
                for k=1:cell{i,j}.route_num
                    profit_bus(k,dt)=cell{i,j}.bus_fare(k,dt)*cell{i,j}.bus_q(k,dt)-f_route(cell{i,j}.route(k))*10;
                    g_fee_bus(k)=cell{i,j}.bus_fee(k,dt)*cell{i,j}.bus_q(k,dt);%出行方式效用
                    g_fee_bus(k)=(cell{i,j}.bus_fee(k,dt)+cell{i,j}.departure_fee(dt))*cell{i,j}.bus_q(k,dt);%出行方式效用+出发时间效用
                    g_travel_time(k)=cell{i,j}.travel_time(k,dt);
                end
                profit_car(dt)=cell{i,j}.car_fare(dt)*cell{i,j}.car_q(dt);
                g_fee_car(dt)=cell{i,j}.car_fee(dt)*cell{i,j}.car_q(dt);%出行方式效用
                g_fee_car(dt)=(cell{i,j}.car_fee(dt)+cell{i,j}.departure_fee(dt))*cell{i,j}.car_q(dt);%出行方式效用+出发时间效用
            end
            profit(i,j)=sum(sum(profit_bus(:,:)))+sum(profit_car(:));%票价、停车费收入
            g_fee(i,j)=sum(sum(g_fee_bus(:,:)))+sum(g_fee_car(:));%出行广义费用
            bus_travel_time(i,j)=mean(g_travel_time(:,:));
        else
            profit(i,j)=0;
            g_fee(i,j)=0;
            bus_travel_time(i,j)=0;
        end
    end
end
mean_bus_travel_time=mean(mean(bus_travel_time));
f(1)=-mean(mean(profit));%目标函数1：票价、停车费收入最大化
f(2)=mean(mean(g_fee));%目标函数2：出行广义费用最小化