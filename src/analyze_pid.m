function R = analyze_pid(out, opts)
% ANALYZE_PID  Simulink SimulationOutput'tan metrikleri çıkarır + grafik çizer.
%   R = analyze_pid(out)
%   R = analyze_pid(out, struct('yname',"y",'t_dist',0.05,'band',0.02))
%
% opts:
%   yname  : To Workspace değişken adı (default "y")
%   t_dist : bozucunun uygulandığı an [s] (default 0.05)
%   band   : yerleşme bandı (±) 0–1 arası (default 0.02 -> ±%2)

% ---------- Parametreler ----------
if nargin < 2 || isempty(opts), opts = struct(); end
if ~isfield(opts,'yname'),  opts.yname  = "y";   end
if ~isfield(opts,'t_dist'), opts.t_dist = 0.05;  end
if ~isfield(opts,'band'),   opts.band   = 0.02;  end

% ---------- out içinden sinyali çek ----------
if ~isa(out, 'Simulink.SimulationOutput')
    error('First argument must be a SimulationOutput (out).');
end
if isprop(out, opts.yname)
    y = out.(opts.yname);
else
    y = out.get(string(opts.yname));  % alternatif erişim
end

% ---------- Zaman-serisini çıkar (Structure With Time veya timeseries) ----------
if isstruct(y) && isfield(y,'time') && isfield(y,'signals')
    t = y.time(:);
    z = y.signals.values(:);
elseif isa(y,'timeseries')
    t = y.Time(:);
    z = y.Data(:);
else
    error('Variable "%s" is not Structure With Time nor timeseries.', opts.yname);
end

% ---------- Step metrikleri ----------
S = stepinfo(z, t);
R = struct();
R.Overshoot     = S.Overshoot;
R.SettlingTime  = S.SettlingTime;
R.RiseTime      = S.RiseTime;
R.PeakTime      = S.PeakTime;

% ---------- Bozucu toparlama süresi (t_dist sonrası ±band) ----------
yss = z(end);                              % kararlı durum yaklaşık değeri
ix  = t >= opts.t_dist;
i2  = find(ix & abs(z - yss) < opts.band*abs(yss), 1, 'first');
if ~isempty(i2)
    R.RecoveryTime = t(i2) - opts.t_dist;
else
    R.RecoveryTime = NaN;
end

% ---------- Konsola yazdır ----------
fprintf('\n=== PID Step Response Analysis ===\n');
fprintf('Overshoot     : %.2f %%\n',  R.Overshoot);
fprintf('Settling Time : %.4f s\n',   R.SettlingTime);
fprintf('Rise Time     : %.4f s\n',   R.RiseTime);
fprintf('Peak Time     : %.4f s\n',   R.PeakTime);
fprintf('Recovery Time : %.4f s  (disturb @ %.3f s, band=±%.1f%%)\n', ...
        R.RecoveryTime, opts.t_dist, opts.band*100);

% ---------- Grafik (tolerans bandı ve işaretlemeler) ----------
% ---------- GRAFİK (temiz görünüm) ----------
fig = figure('Color','w'); hold on; grid on;

% Renk paleti
col_resp = [0 0.45 0.74];     % mavi
col_band = [0.85 0.33 0.10];  % turuncuya yakın (gölge rengi)
col_ss   = [0.35 0.35 0.35];  % gri

% ±band gölgesi
y_upper = yss * (1 + opts.band);
y_lower = yss * (1 - opts.band);
ph = patch([t(1) t(end) t(end) t(1)], [y_lower y_lower y_upper y_upper], ...
      [0.85 0.33 0.10], 'FaceAlpha',0.15, 'EdgeColor','none', ...
      'DisplayName',sprintf('±%.0f%% band',opts.band*100));

% Ortasına yazı koy
text(t(end)*0.7, (y_upper+y_lower)/2, ...
    sprintf('±%.0f%% band', opts.band*100), ...
    'Color',[0.85 0.33 0.10], 'FontSize',9, 'FontWeight','bold', ...
    'HorizontalAlignment','left','VerticalAlignment','middle');

% step cevabı
plot(t, z, 'Color', col_resp, 'LineWidth', 1.6, 'DisplayName','Step response');

% steady-state çizgisi (etiketsiz)
yline(yss, '--', 'Color', col_ss, 'LineWidth', 1);

% kritik noktalar (daha küçük işaretler)
ms = 7; me = 'none';
[zmax, ~] = max(z);
plot(R.PeakTime, zmax, 'o', 'MarkerFaceColor',[0.85 0.33 0.10], 'MarkerEdgeColor',me, 'MarkerSize',ms, 'DisplayName','Peak');
plot(R.SettlingTime, yss, 'o', 'MarkerFaceColor',[0.47 0.67 0.19], 'MarkerEdgeColor',me, 'MarkerSize',ms, 'DisplayName','Settling');
plot(R.RiseTime, 0.9*yss, 'o', 'MarkerFaceColor',[0.0 0.62 1.0], 'MarkerEdgeColor',me, 'MarkerSize',ms, 'DisplayName','Rise');
if ~isnan(R.RecoveryTime)
    plot(opts.t_dist + R.RecoveryTime, yss, 'o', 'MarkerFaceColor',[0.69 0.18 0.84], 'MarkerEdgeColor',me, 'MarkerSize',ms, 'DisplayName','Recovery');
end

% eksen/başlık/legend
xlim([t(1) t(end)]);
ylim([min(0,min(z))-0.05, max([zmax, y_upper])+0.05]);
xlabel('Time (s)'); ylabel('Output');
title('DC Motor Step Response — Metrics Overlay');
leg = legend('Location','southoutside','Orientation','horizontal');
set(leg,'Box','off');



% dc_motor_pid veya dc_motor_pid_runner çalıştırılınca; 
% konsolda metrikler, grafikte +- band ve değerler çıkar
% bant mevcut durumda +-%2 olup değiştirilmek istenirse: R = analyze_pid(out, struct('yname',"y",'t_dist',0.05,'band',0.05));  % ±%5 band
