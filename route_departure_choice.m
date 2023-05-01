function cell=route_departure_choice(cell,i,j,M,N_agent_length,t)
%==========选择路径===========
for ii=1:N_agent_length
    randroute=rand;
    for k=1:cell{i,j}.route_num+1
        cwpr(ii,k)=sum(cell{i,j}.wr(ii,1:k,t));
    end
    for k=1:cell{i,j}.route_num
        if randroute<=cwpr(ii,1)
            cell{i,j}.route_choice(ii,t)=1;
        elseif randroute>cwpr(ii,k)&&randroute<=cwpr(ii,k+1)
            cell{i,j}.route_choice(ii,t)=k+1;
        end
    end
end
%==========选择出发时间========
for ii=1:N_agent_length
    randdepart=rand;
    for k=1:M
        cwpd(ii,k)=sum(cell{i,j}.wd(ii,1:k,t));
    end
    for k=1:M-1
        if randdepart<=cwpd(ii,1)
            cell{i,j}.depart_choice(ii,t)=1;
        elseif randdepart>cwpd(ii,k)&&randdepart<=cwpd(ii,k+1)
            cell{i,j}.depart_choice(ii,t)=k+1;
        end
    end
end
%==================异常值处理=================
for ii=1:N_agent_length
    if cell{i,j}.route_choice(ii,t)==0
        cell{i,j}.route_choice(ii,t)=randi([1,cell{i,j}.route_num+1],1,1);
    end
    if cell{i,j}.depart_choice(ii,t)==0
        cell{i,j}.depart_choice(ii,t)=randi([1,M],1,1);
    end
end

return