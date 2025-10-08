% --- Ініціалізація ---
clear
clc
close all

% Назва вашої моделі Simulink
model_name = 'ParallelServerModel'; 

% --- Налаштування параметрів симуляції ---
num_simulations = 30; % Кількість симуляцій

% Статичні параметри
mu = 1.0;      % Інтенсивність обслуговування
K = 5;         % Максимальний розмір черги
Tstop = 100;   % Час симуляції

% Змінний параметр: інтенсивність надходження заявок (lambda)
lambda_values = linspace(0.5, 2.0, num_simulations);

% --- Крок 3: Запуск симуляцій у циклі ---

% Створюємо масиви для зберігання результатів
results_avg_queue_len = zeros(1, num_simulations);
results_loss_prob = zeros(1, num_simulations);
results_utilization = zeros(1, num_simulations);

fprintf('Запуск %d симуляцій...\n', num_simulations);

for i = 1:num_simulations
    % Встановлюємо поточне значення lambda
    lambda = lambda_values(i);
    
    % Запускаємо симуляцію Simulink
    simOut = sim(model_name);
    
    results_avg_queue_len(i) = simOut.avg_queue_len.Data(end);
    results_loss_prob(i) = simOut.loss_prob.Data(end);
    results_utilization(i) = simOut.utilization.Data(end);
    
    fprintf('Симуляція %d/%d завершена (lambda = %.2f).\n', i, num_simulations, lambda);
end

fprintf('Усі симуляції завершено!\n');

% --- Побудова графіка ---
figure; 
plot(lambda_values, results_avg_queue_len, '-o', 'LineWidth', 2, 'DisplayName', 'Середня довжина черги');
hold on; 
plot(lambda_values, results_loss_prob, '-s', 'LineWidth', 2, 'DisplayName', 'Ймовірність втрати');
hold off; 

% Оформлення графіка
title('Залежність параметрів системи від інтенсивності потоку \lambda');
xlabel('Інтенсивність вхідного потоку, \lambda (заявок/сек)');
ylabel('Значення параметрів');
legend('show'); 
grid on;