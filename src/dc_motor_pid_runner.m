function R = dc_motor_pid_runner(modelName, yname, t_dist, band)
% DC motor PID: simüle et, metrikleri yazdır ve grafiği üret.
% Kullanım:
%   R = dc_motor_pid_runner();                         % varsayılanlar
%   R = dc_motor_pid_runner("dc_motor_pid_manual");    % model adı
%   R = dc_motor_pid_runner("dc_motor_pid_manual","y",0.05,0.02);

    if nargin < 1 || isempty(modelName), modelName = "dc_motor_pid_manual"; end
    if nargin < 2 || isempty(yname),     yname     = "y";                  end
    if nargin < 3 || isempty(t_dist),    t_dist    = 0.05;                 end
    if nargin < 4 || isempty(band),      band      = 0.02;                 end

    addpath('src'); %#ok<*MCAP>  % varsa src'i ekler
    p = dc_motor_params(); %#ok<NASGU>

    % Simülasyon (Single Simulation Output açık olsa da olmasa da çalışır)
    out = sim(modelName, 'ReturnWorkspaceOutputs','on');

    % Metrikleri yazdır + döndür
    R = analyze_pid(out, struct('yname',yname, 't_dist',t_dist, 'band',band));

    % Çizim
    % y'yi çek (Structure With Time veya timeseries destekli)
    if isprop(out, yname)
        y = out.(yname);
    else
        y = out.get(string(yname));
    end

    if isstruct(y)
        t = y.time(:); z = y.signals.values(:);
    else
        t = y.Time(:); z = y.Data(:);
    end

    S = stepinfo(z, t);
    steady_val = z(end);

    figure; plot(t, z, 'LineWidth', 1.5); hold on; grid on;
    yline(steady_val, '--k', 'Steady State');

    % Kritik noktalar
    [zmax,imax] = max(z);
    plot(S.PeakTime, zmax, 'ro', 'MarkerFaceColor','r');           % Peak
    plot(S.SettlingTime, steady_val, 'go', 'MarkerFaceColor','g'); % Settling

    % Rise time işaretleyici (yaklaşık 90%)
    plot(S.RiseTime, steady_val*0.9, 'bo', 'MarkerFaceColor','b'); % Rise

    % Recovery (analyze_pid içinde hesaplanan)
    if isfield(R,'RecoveryTime') && ~isnan(R.RecoveryTime)
        plot(R.RecoveryTime + t_dist, steady_val, 'mo', 'MarkerFaceColor','m');
        leg = {'Step Response','Steady State','Peak','Settling','Rise','Recovery'};
    else
        leg = {'Step Response','Steady State','Peak','Settling','Rise'};
    end

    legend(leg,'Location','best');
    xlabel('Time (s)'); ylabel('Output');
    title('DC Motor Step Response — Metrics Overlay');
end


% Comman window'a R = dc_motor_pid_runner yazınca direkt çalışır.
% VEYA R = dc_motor_pid_runner("dc_motor_pid_manual","y",0.05,0.02);
