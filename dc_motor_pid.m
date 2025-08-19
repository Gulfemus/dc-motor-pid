% dc_motor_pid.m — Simülasyonu çalıştır ve metrikleri yazdır
addpath('src');           % varsa src klasörünü ekle
p = dc_motor_params();    % parametreleri yükle (opsiyonel)

out = sim("dc_motor_pid_manual");         % model adın buysa
R = analyze_pid(out, struct('yname',"y", 't_dist',0.05, 'band',0.02));
% Grafik çizimi
figure;
plot(out.tout, out.y.signals.values, 'LineWidth', 1.5); hold on; grid on;
yline(out.y.signals.values(end), '--k', 'Steady State');

S = stepinfo(out.y.signals.values, out.tout);

plot(S.PeakTime, max(out.y.signals.values), 'ro', 'MarkerFaceColor', 'r'); % Peak
plot(S.SettlingTime, out.y.signals.values(end), 'go', 'MarkerFaceColor', 'g'); % Settling
plot(S.RiseTime, out.y.signals.values(end)*0.9, 'bo', 'MarkerFaceColor', 'b'); % Rise
plot(R.RecoveryTime, out.y.signals.values(end), 'mo', 'MarkerFaceColor', 'm'); % Recovery

legend('Step Response','Steady State','Peak','Settling','Rise','Recovery');
xlabel('Time (s)');
ylabel('Output');
title('DC Motor Step Response with PID');
