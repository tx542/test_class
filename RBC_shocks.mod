% PROJECT: EC704 Spring TA Dynare Session
% PURPOSE: RBC model with three shocks for Dynare
% AUTHOR : Code written by Shraddha Mandi

%----------------------------------------------------------------
% 1. Labeling block
%----------------------------------------------------------------

var y n c k i w rk r a nu; 
varexo e_a e_nu; 

parameters beta varphi gamma sigma delta alpha I_Y phi_a sigma_a phi_nu sigma_nu;


%----------------------------------------------------------------
% 2. Parameter values block
%----------------------------------------------------------------

% Preferences
    beta = 0.9875;      % Discount factor
    varphi = 1;         % Frisch elasticity
    gamma = 1;          % Inter-temporal elasticity of substitution
    sigma = 1/gamma;

% Technology
    delta = 0.069;      % Capital depreciation rate
    alpha = 1-0.58;     % Capital share

% Steady state values
    I_Y = alpha*beta*delta/ (1-beta*(1-delta)); % Steady state 
                                                % investment-output ratio

% Shocks
    phi_a = 0.8;        % Auto-correlation of productivity innovation
    sigma_a = 0.98;     % Std. dev. of productivity innovation
    phi_nu = 0.8;       % Auto-correlation of leisure innovation
    sigma_nu = 0.98;    % Std. dev. of leisure innovation


%----------------------------------------------------------------
% 3. Model block
%----------------------------------------------------------------

model(linear); 
    % Main model
    y = nu + (1+varphi) * n + gamma * c;                                    % Labor choice
    c = c(+1) - sigma*alpha*beta*delta*(1/I_Y)*(y(+1)-k);                   % Euler equation
    y = a + alpha * k(-1) + (1-alpha) * n;                                  % Production function
    y = (1-I_Y) * c + (I_Y/delta) * (k - (1-delta)*k(-1));                  % Resource constraint
    
    % Implicit variables
    k = delta * i + (1-delta) * k(-1);                                      % Investment definition
    w = y - n;                                                              % Wage definition
    rk = (1-beta*(1-delta))* (y(+1) - k);                                   % Expected return to capital
    r = gamma * (c(+1) - c);                                                % Risk-less interest rate (inverse of SDF)
    
    % Exogenous processes
    a = phi_a * a(-1) +  e_a;                                               % Productivity   
    nu = phi_nu * nu(-1) + e_nu;                                            % Leisure 

end;

%----------------------------------------------------------------
% 4. Initialization block
%----------------------------------------------------------------

steady;
check;

%----------------------------------------------------------------
% 5. Random shock block
%----------------------------------------------------------------

shocks;
var e_a; stderr sigma_a;
var e_nu; stderr sigma_nu;
end;

%----------------------------------------------------------------
% 4. Solution & Properties block
%----------------------------------------------------------------

stoch_simul(order = 1, irf=40, periods = 10000);
