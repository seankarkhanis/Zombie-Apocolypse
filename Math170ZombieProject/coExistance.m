% Zombie Apocalypse: Permanent Coexistence
close all
clear
clc

% Parameters for Permanent Coexistence
params.beta = 0.0002;   % Infection rate
params.gamma = 0.02;   % Human birth rate (logistic growth)
params.K = 1000;       % Carrying capacity for humans
params.mu = 0.001;     % Natural human death rate
params.c = 0.05;       % Human attack rate on zombies

% Initial conditions
S0 = 1000; % humans
I0 = 50;   % zombies
dt = 0.1;       % time step (days)
Tfinal = 2500;  % final time (days)
Nsteps = ceil(Tfinal/dt);
time = 0:dt:Tfinal;

% Pre-allocate memory
x = zeros(2, Nsteps+1);
x(:,1) = [S0; I0];

% System of equations
f = @(S,I,p) [
    -p.beta*S*I + p.gamma*S*(1 - S/p.K) - p.mu*S;
     p.beta*S*I - p.gamma*I - p.c*S*(I/(p.K+I))
];

% Simulation
for i = 1:Nsteps
    x(:,i+1) = x(:,i) + dt * f(x(1,i), x(2,i), params);
    % Prevent negatives
    x(x(:,i+1)<0,i+1) = 0;
end

% Plot results
figure;
plot(time, x(1,:), 'b-', 'LineWidth', 2); hold on;
plot(time, x(2,:), 'r-', 'LineWidth', 2);
xlabel('Time (days)');
ylabel('Population');
legend('Humans (S)', 'Zombies (I)');
title('Coexistence: Humans vs Zombies');
grid on;
