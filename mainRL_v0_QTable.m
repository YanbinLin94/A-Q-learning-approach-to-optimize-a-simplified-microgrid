%%%% This code is written and maintained by Avijit Das %%%%%%%%%%%%%%%%%
%%%% For any questions, please contact adas2017@fau.edu %%%%%%%%%%%%%%%%

% Note 1: this code only provides a single Q learning agent to optimize a simplied microgrid (energy arbitrage) setup. The reference paper below described a recent work of aggregating multiple learning agents for microgrid energy optimization during the extreme weather events, which is more complicated than what you can observe from this code. 

% Note 2: this code is provided for the academic training, supported by NSF CyberTraining project. Algorithm explanation and simulation case studies are discussed in the lecture notes.

% If this code is used for any research purpose, please cite our PESGM’21 paper below.
% A. Das, Z. Ni, and X. Zhong, “Aggregating Learning Agents for Microgrid Energy Scheduling During Extreme Weather Events,” in Proc. of IEEE Power & Energy Society General Meeting (PESGM’21), pp.1-5, Washington, DC, USA, Jul. 25-29, 2021. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;

init %Initializing battery parameters

N=2000; %soc discrete/defining number of battery states
delta=(s_u-s_l)/N;
states=s_l:delta:s_u;% 11 kinds of battery states
%%%%%%%%%%%%%%%%%%%Defining Q-table%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Each_cell = zeros(1,size(states,2));
for tab_time = 1:K %K:max time step
    for tab_stat = 1:size(states,2)
        value_table{tab_stat,tab_time} = Each_cell;     
    end
end
%%%%%%%%%%%%%%%%%Defining Parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%
initial_pos = 5;% battery initial SOC position in the table
gamma = 1;%discount factor

Run = 50; %number of runs for calculating average
iter = 4000; %maximun iteration number
epsilon = 0.6;

lambda = -lambda; %grid price
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for rr = 1:Run 
    
%%%%%%%%%%%%%%%%%%%%%Redefining Q-table for starting from all zeros%%%%%%%    
    for tab_time = 1:K
        for tab_stat = 1:size(states,2)
            value_table{tab_stat,tab_time} = Each_cell;     
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    epsilon = 0.5;
    help_ep = 50; %It helps to decrease the probability of exploration
    tic % calculate time
for i = 1:iter %Iteration loop begins
    
    stateK0 = L0; %Defining initial state %initial SOC=0.5, so it should be changed
    %alpha = a/(a+i-1);
    alpha = 0.05; %learning rate
    %%%%%%%%%%%%After every 50 iterations exproration prob. decreases %%%%
    if i == help_ep
       epsilon =  epsilon/1.1;
       help_ep = help_ep+50;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    save_transition = initial_pos;
    for time = 1:K %%%%%Time loop begins
        
        power = [];
        status = ones(1,size(states,2));
        powerbatt=(states-stateK0)*Es; %energy change rate in batt
        index_ch=find(powerbatt>0); % charging power index
        index_dis=find(powerbatt<0); % discharing power index
        power=powerbatt;
        power(index_ch)=power(index_ch)/eta_ch; % charging power rate with efficiency 
        power(index_dis)=power(index_dis)*eta_dis; %discharing power rate with efficiency 
        index_inf=find(power>pmax_ch | power<-pmax_dis ); % infeasible solution
        status(index_inf) = 0;
        help_assign = find(status>0); % Finding feasible solution
        %value_determin = value_table(:,time); 
        
        if rand < epsilon %%%%%%%%%%%%%%%Random action%%%%%%%%%%%%%%%%%
        taking_action = help_assign(randi([1,size(help_assign,2)],1,1));% r = randi([-5,5],10,1),10,1 is the size; so 1,1 is size
        %taking_action = help_assign(randi([1,size(help_assign,2)]));% without 1,1 is ok
        h_pos = find(help_assign == taking_action);% find the action's index in help_assign
        cost_cal = power(help_assign(h_pos))*lambda(time); %lamda is price; h_pos is necessary
        %cost_cal = power(taking_action)*lambda(time); %cost= power_needed * price
        optimized_cost = cost_cal;
        else
        %%%%%%%%%%%%%%%Greedy action%%%%%%%%%%%%%%%%%    
        if time < K
        cost_cal = value_table{save_transition,time}(1,help_assign); % Exporting Q-values
        [opt_cost,pos] = max(cost_cal); % Finding max Q-values
        taking_action = help_assign(pos); % corresponding action
        optimized_cost = power(taking_action)*lambda(time); % corresponding cost
        else
        cost_cal = power(help_assign)*lambda(time);  % Calculating cost for all feasible actions 
        [optimized_cost,pos] = max(cost_cal); % Finding max revenue
        taking_action = help_assign(pos);    % Finding action that maximizes the revenue
        end   
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end

        pos_soc = states(taking_action); %Next-state information
        
        if time < K-1  
           max_q_val = max(value_table{taking_action,time+1}); %maximum Q-value
        end
       
        if time < K-1
           value_table{save_transition,time}(1,taking_action) = optimized_cost + max_q_val; %Q-value update
        else if time == K-1
           value_table{save_transition,time}(1,taking_action) = optimized_cost; %Q-value update
            end
        end
        save_transition = taking_action; %Updating state information position
        stateK0 = pos_soc;%Updating state information
        batt_pol(time) = pos_soc; %saving battery policy
        save_cost_t(time) = optimized_cost; %saving rewards
    end

save_cost_iter(i) = sum(save_cost_t); %Total obtained reward of that iteration     
save_timQ(i) = toc;    %Iteration Time   
end
toc
save_cost_run(rr,:) = save_cost_iter;  % Saving iterative reward curve for each run
save_time_run(rr,:) = save_timQ; 
save_battpol_run(rr,:) = batt_pol;
end
plot_avg_cost = sum(save_cost_run)/Run; % Average reward curve for all runs
Plot_avg_time = sum(save_time_run)/Run;
[fmx_run, fmx_run_pos] =  max(save_cost_run(:,end));
batt_pol = save_battpol_run(fmx_run_pos,:);
socBatt = [L0 batt_pol];
pkQ=zeros(1,K);
for jj=1:K
    pbatt=(socBatt(jj+1)-socBatt(jj))*Es;
    if pbatt>=0
        pkQ(jj)=pbatt/eta_ch;
    elseif pbatt<0
        pkQ(jj)=pbatt*eta_dis;
    end
    corrspd_cost(jj) = pkQ(jj)*lambda(jj);
end

% figure
% plot(plot_avg_cost)
% xlabel('Iteration')
% ylabel('Average Total Reward ($)')
SOC=batt_pol(6) 
fprintf('The SOC of time 6 is ',SOC,'\n') 
cost=corrspd_cost(6)
fprintf('Cooresponding cost of time 6 is ',cost,'\n')
% figure
% plot(batt_pol)
% xlabel('Time (hours)')
% ylabel('Battery SOC')
% figure
% bar(pkQ)
% xlabel('Time (hours)')
% ylabel('Battery Output (MW)')

