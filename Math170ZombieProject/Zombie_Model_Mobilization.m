% Zombie Apocalypse Model with Human Mobilization
close all
clear
clc

% Parameters
beta = 0.0002;   % Infection rate
gamma = 0.01;    % Human birth rate (logistic growth)
K = 1000;        % Carrying capacity for humans
mu = 0.001;      % Natural human death rate
c = 0.05;        % Initial human attack rate on zombies

% Mobilization settings
mobilization_time = 20;   % Day humans start fighting back harder
mobilization_factor = 5;  % How much stronger humans become

% Initial conditions
S0 = 990;  % Initial number of susceptible humans
I0 = 10;   % Initial number of zombies

% Simulation settings
dt = 0.1;      % Time step (days)
Tfinal = 730;  % Final time (days)
Nsteps = ceil(Tfinal/dt);
time = 0:dt:Tfinal;

% Pre-allocate memory
x = zeros(2, Nsteps+1); % x(1,:) = S (humans), x(2,:) = I (zombies)

% Set initial values
x(:,1) = [S0; I0];

% Define the system of equations
f = @(S,I,c_current) [
    -beta*S*I + gamma*S*(1 - S/K) - mu*S;                 % dS/dt
     beta*S*I - gamma*I - c_current*S*(I/(K+I))            % dI/dt
];

% Solve using Euler's method
for i = 1:Nsteps
    current_time = (i-1)*dt;
    
    % Check if mobilization has occurred
    if current_time >= mobilization_time
        c_current = mobilization_factor * c; % Humans get stronger
    else
        c_current = c; % Normal fight strength
    end
    
    % Update using current c
    x(:,i+1) = x(:,i) + dt * f(x(1,i), x(2,i), c_current);
    
    % Prevent negative populations
    x(x(:,i+1)<0,i+1) = 0;
end

% Plot results
figure;
plot(time, x(1,:), 'b-', 'LineWidth', 2); hold on;
plot(time, x(2,:), 'r-', 'LineWidth', 2);
xlabel('Time (days)');
ylabel('Population');
legend('Humans (S)', 'Zombies (I)');
title('Zombie Apocalypse Simulation with Mobilization at Day 20');
grid on;
