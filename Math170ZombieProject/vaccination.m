% Zombie Apocalypse with Vaccination (Animated, Cure Highlighted)
close all
clear
clc

% Parameters
params.beta_before = 0.0002;  % Infection rate before cure
params.beta_after = 0.00001;  % Infection rate after cure
params.gamma = 0.02;         % Human birth rate
params.K = 1000;             % Carrying capacity
params.mu = 0.001;           % Natural death rate
params.c = 0.02;             % Human attack rate
params.epsilon = 0.01;       % Cure rate (zombies -> humans)
params.rho = 0.005;          % Vaccination rate (humans -> recovered)

cure_time = 100;             % Day when cure is discovered

% Initial conditions
S0 = 980; % humans
I0 = 50;   % zombies
R0 = 0;    % vaccinated humans
dt = 0.1;  
Tfinal = 500;
Nsteps = ceil(Tfinal/dt);
time = 0:dt:Tfinal;

% Pre-allocate memory
x = zeros(3, Nsteps+1);
x(:,1) = [S0; I0; R0];

% System of equations
f = @(S,I,R,p,beta_now,t) [
    -beta_now*S*I + p.gamma*S*(1 - (S+R)/p.K) - p.mu*S - (t >= cure_time)*p.rho*S + p.epsilon*I;  % dS/dt
     beta_now*S*I - p.gamma*I - p.c*S*(I/(p.K+I)) - p.epsilon*I;                                    % dI/dt
     (t >= cure_time)*p.rho*S                                                                        % dR/dt
];

% Create figure
figure;
hold on;
h1 = plot(time(1), x(1,1), 'b-', 'LineWidth', 2); % Humans
h2 = plot(time(1), x(2,1), 'r-', 'LineWidth', 2); % Zombies
h3 = plot(time(1), x(3,1), 'g-', 'LineWidth', 2); % Vaccinated
xline(cure_time, '--k', 'LineWidth', 2); % Vertical dashed line at cure time
text(cure_time+5, max(S0,I0)*0.8, 'Cure Discovered!', 'FontSize', 12, 'Color', 'k');

xlabel('Time (days)');
ylabel('Population');
legend('Humans (S)', 'Zombies (I)', 'Recovered Humans (R)', 'Location', 'best');
title('Zombie Apocalypse with Cure and Vaccination');
grid on;
ylim([0 params.K*1.2]);
xlim([0 Tfinal]);

% Animation loop
for i = 1:Nsteps
    t = time(i);
    
    % Update beta based on time
    if t < cure_time
        beta_now = params.beta_before;
    else
        beta_now = params.beta_after;
    end
    
    % Euler method
    x(:,i+1) = x(:,i) + dt * f(x(1,i), x(2,i), x(3,i), params, beta_now, t);
    
    % Prevent negatives
    x(x(:,i+1)<0,i+1) = 0;
    
    % Update plots
    set(h1, 'XData', time(1:i+1), 'YData', x(1,1:i+1));
    set(h2, 'XData', time(1:i+1), 'YData', x(2,1:i+1));
    set(h3, 'XData', time(1:i+1), 'YData', x(3,1:i+1));
    
    drawnow;
end
