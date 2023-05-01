function cell=route_departure_update(cell,i,j,t,M,N_agent_length,interact_S)
lamada=0.1;
%==========更新路径选择概率===========
for ii=1:N_agent_length
    c_route=cell{i,j}.route_choice(ii,t);%自己选择的路径
    c_depart=cell{i,j}.depart_choice(ii,t);%自己选择的出发时间
    if c_route==cell{i,j}.route_num+1
        c_fee=cell{i,j}.car_fee(c_depart);%自己的费用
    else
        c_fee=cell{i,j}.bus_fee(c_route,c_depart);%自己的费用
    end
    c_depart_fee=-cell{i,j}.departure_fee(c_depart);%自己的出发时间费用
    for ss=1:interact_S
        friend_route(ss)=cell{i,j}.route_choice(cell{i,j}.friend(ii,ss),t);%朋友选择的路径
        friend_depart(ss)=cell{i,j}.depart_choice(cell{i,j}.friend(ii,ss),t);%朋友选择的出发时间
        if friend_route(ss)==cell{i,j}.route_num+1
            friend_fee(ss)=cell{i,j}.car_fee(friend_depart(ss));%朋友的费用
        else
            friend_fee(ss)=cell{i,j}.bus_fee(friend_route(ss),friend_depart(ss));%朋友的费用
        end
        friend_depart_fee(ss)=-cell{i,j}.departure_fee(friend_depart(ss));%朋友的出发时间费用
    end
    %========================路径选择============================
    for kk=1:cell{i,j}.route_num+1
        num_friend(kk)=numel(find(friend_route==kk));
        mean_fee(kk)=mean(friend_fee(friend_route==kk));  
    end
    for kk=1:cell{i,j}.route_num+1
        delta_c(kk)=(num_friend(kk)/interact_S)*(c_fee-mean_fee(kk))/num_friend(kk);
        if num_friend(kk)==0
            delta_c(kk)=0;
        end
    end
    xigema_delta_k=sum(delta_c(:))-delta_c(c_route);
    for kk=1:cell{i,j}.route_num+1
        if kk==c_route
            cell{i,j}.wr(ii,kk,t+1)=cell{i,j}.wr(ii,kk,t)+lamada*(delta_c(c_route)-xigema_delta_k);
        else
            cell{i,j}.wr(ii,kk,t+1)=cell{i,j}.wr(ii,kk,t)+lamada*(delta_c(kk)-delta_c(c_route)/cell{i,j}.route_num);
        end

    end

    %========================出发时间选择=========================
    for m=1:M
        num_depart_friend(m)=numel(find(friend_depart==m));
        mean_depart_fee(m)=mean(friend_depart_fee(friend_depart==m));
    end
    for m=1:M
        delta_d_c(m)=(num_depart_friend(m)/interact_S)*(c_depart_fee-mean_depart_fee(m))/num_depart_friend(m);
        if num_depart_friend(m)==0
            delta_d_c(m)=0;
        end
    end
    xigema_delta_d_k=sum(delta_d_c(:))-delta_d_c(c_depart);
    for m=1:M
        if m==c_depart
            cell{i,j}.wd(ii,m,t+1)=cell{i,j}.wd(ii,m,t)+lamada*(delta_d_c(c_depart)-xigema_delta_d_k);
        else
            cell{i,j}.wd(ii,m,t+1)=cell{i,j}.wd(ii,m,t)+lamada*(delta_d_c(kk)-delta_d_c(c_depart)/(M-1));
        end
    end
    
end
%=================标准化=======================
for ii=1:N_agent_length
    wrr(ii,:)=cell{i,j}.wr(ii,:,t+1);
    min_wr=min(wrr(:,:));
    wrr(ii,:)=wrr(ii,:)-min_wr;
    xigema_wr=sum(wrr(ii,:));
    wrr(ii,:)=wrr(ii,:)/xigema_wr;
    cell{i,j}.wr(ii,:,t+1)=wrr(ii,:);
    
    wdd(ii,:)=cell{i,j}.wd(ii,:,t+1);
    min_wd=min(wdd(:,:));
    wdd(ii,:)=wdd(ii,:)-min_wd;
    xigema_wd=sum(wdd(ii,:));
    wdd(ii,:)=wdd(ii,:)/xigema_wd;
    cell{i,j}.wd(ii,:,t+1)=wdd(ii,:);
    
end

return