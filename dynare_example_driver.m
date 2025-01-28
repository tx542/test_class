% PROJECT: EC704 Spring TA Dynare Session
% PURPOSE: RBC model with three shocks for Dynare
% AUTHOR : Code written by Shraddha Mandi

clear all
close all

%% Run the .mod file

dynare RBC_shocks.mod

%% We can use the Dynare IRFs to plot the three shocks together
% setting dimensions of figure output
factor=1.5;
width=factor*560;
height=factor*420;

% setting the time periods simulated
T = 40;
Time = 1:T;

% plotting IRFs for our 9 variables
figure()
subplot(3,3,1)
plot(Time,oo_.irfs.y_e_a,'-b',Time,oo_.irfs.y_e_nu,'--g','LineWidth',2,'MarkerSize',2)
hold on
plot(Time,zeros(1,T),'-k','LineWidth',0.5)
hold off
title('Output')
ylabel('% deviation')

subplot(3,3,2)
plot(Time,oo_.irfs.c_e_a,'-b',Time,oo_.irfs.c_e_nu,'--g','LineWidth',2,'MarkerSize',2)
hold on
plot(Time,zeros(1,T),'-k','LineWidth',0.5)
hold off
title('Consumption')

subplot(3,3,3)
plot(Time,oo_.irfs.i_e_a,'-b',Time,oo_.irfs.i_e_nu,'--g','LineWidth',2,'MarkerSize',2)
hold on
plot(Time,zeros(1,T),'-k','LineWidth',0.5)
hold off
title('Investment')

subplot(3,3,4)
plot(Time,oo_.irfs.n_e_a,'-b',Time,oo_.irfs.n_e_nu,'--g','LineWidth',2,'MarkerSize',2)
hold on
plot(Time,zeros(1,T),'-k','LineWidth',0.5)
hold off
title('Employment')
ylabel('% deviation')

subplot(3,3,5)
plot(Time,oo_.irfs.k_e_a,'-b',Time,oo_.irfs.k_e_nu,'--g','LineWidth',2,'MarkerSize',2)
hold on
plot(Time,zeros(1,T),'-k','LineWidth',0.5)
hold off
title('Capital stock (Tomorrow)')

subplot(3,3,6)
plot(Time,oo_.irfs.w_e_a,'-b',Time,oo_.irfs.w_e_nu,'--g','LineWidth',2,'MarkerSize',2)
hold on
plot(Time,zeros(1,T),'-k','LineWidth',0.5)
hold off
title('Wages')

subplot(3,3,7)
plot(Time,oo_.irfs.rk_e_a,'-b',Time,oo_.irfs.rk_e_nu,'--g','LineWidth',2,'MarkerSize',2)
hold on
plot(Time,zeros(1,T),'-k','LineWidth',0.5)
hold off
title('Return to capital')
ylabel('% deviation')

subplot(3,3,8)
plot(Time,oo_.irfs.r_e_a,'-b',Time,oo_.irfs.r_e_nu,'--g','LineWidth',2,'MarkerSize',2)
hold on
plot(Time,zeros(1,T),'-k','LineWidth',0.5)
hold off
title('Risk-less rate')

subplot(3,3,9)
plot(Time,oo_.irfs.a_e_a,'-b',Time,oo_.irfs.nu_e_nu,'--g','LineWidth',2,'MarkerSize',2)
title('Driving process')
legend('Productivity','Labor disutil.','Discount factor')


set(gcf,'units','points','position',[10,10,width,height])
saveas(gcf,'shocks.eps','epsc')


%% Now run impulse responses after productivity shock with different values of parameter gamma

% Vector of different gammas
gamma_vec = [0.5,1,2];

% Create a T by 3 by 9 array to store the results since we have 3 parameter
% values and 9 variables (y,c,i,n,k,w,rk,r,a)
X = zeros(T,length(gamma_vec),9); 
vars = {'Output','Consumption','Investment','Employment','Capital stock (tomorrow)','Wages','Return to capital','Risk-less interest','Productivity'};

% Loop over parameter values
for j = 1:length(gamma_vec)
    % Update parameter value
    set_param_value('gamma',gamma_vec(j));
    set_param_value('sigma',1/gamma_vec(j)); % THIS IS IMPORTANT!
    % Set variables we want IRFs for 
    var_list_ = {'y', 'c', 'i', 'n', 'k', 'w', 'rk', 'r', 'a'};
    % Simulate model
    [info,oo_]=stoch_simul(M_, options_, oo_, var_list_);
    if info(1)~=0
        error('Simulation failed for parameter draw')
    end
    % Store results
    X(:,j,1) = oo_.irfs.y_e_a;
    X(:,j,2) = oo_.irfs.c_e_a;
    X(:,j,3) = oo_.irfs.i_e_a;
    X(:,j,4) = oo_.irfs.n_e_a;
    X(:,j,5) = oo_.irfs.k_e_a;
    X(:,j,6) = oo_.irfs.w_e_a;
    X(:,j,7) = oo_.irfs.rk_e_a;
    X(:,j,8) = oo_.irfs.r_e_a;
    X(:,j,9) = oo_.irfs.a_e_a;
end

%% Use results to create Figure of IRF

figure('Name','Gamma variation');
for i = 1:9
% Plot results
    subplot(3,3,i)
    plot(Time,X(:,1,i),'-b',Time,X(:,2,i),'--g',Time,X(:,3,i),'-.r','LineWidth',2,'MarkerSize',2)

    if i < 9
        hold on
        plot(Time,zeros(1,T),'-k','LineWidth',0.5)
        hold off
    else
        legend('\gamma = 0.5','\gamma = 1','\gamma = 2')
    end
    
    title(vars(i))
    if i == 1 || i==4 || i==7
       ylabel('% deviation')
    end
    
end

set(gcf,'units','points','position',[10,10,width,height])
saveas(gcf,'gammas.eps','epsc')