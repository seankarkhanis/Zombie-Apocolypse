% Zombie Apocalypse Model
close all
clear
clc

% Parameters
beta = 0.0002;   % Infection rate
gamma = 0.01;   % Human birth rate (logistic growth)
K = 1000;       % Carrying capacity for humans
mu = 0.001;     % Natural human death rate
c = 0.05;       % Human attack rate on zombies

% Initial conditions
S0 = 990;  % Initial number of susceptible humans
I0 = 10;   % Initial number of zombies

% Simulation settings
dt = 0.1;      % Time step (days)
Tfinal = 730;  % Final time (days)
Nsteps = ceil(Tfinal/dt);

% Pre-allocate memory
x = zeros(2, Nsteps+1); % x(1,:) = S (humans), x(2,:) = I (zombies)
time = 0:dt:Tfinal;

% Set initial values
x(:,1) = [S0; I0];

% Define the system of equations
f = @(S,I) [
    -beta*S*I + gamma*S*(1 - S/K) - mu*S;                 % dS/dt
     beta*S*I - gamma*I - c*S*(I/(K+I))                    % dI/dt
];

% Solve using Euler's method
for i = 1:Nsteps
    x(:,i+1) = x(:,i) + dt * f(x(1,i), x(2,i));
    x(x(:,i+1)<0,i+1) = 0; % Ensure no negative populations
end

% Plot results
figure;
plot(time, x(1,:), 'b-', 'LineWidth', 2); hold on;
plot(time, x(2,:), 'r-', 'LineWidth', 2);
xlabel('Time (days)');
ylabel('Population');
legend('Humans (S)', 'Zombies (I)');
title('Zombie Apocalypse Simulation');
grid on;
