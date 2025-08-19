function p = dc_motor_params()
% DC motor varsayılan parametreleri (örnek değerler).
p.J = 3.228e-6;      % kg*m^2  (atalet)
p.b = 3.5077e-6;     % N*m*s   (sürtünme)
p.K = 0.0274;        % V*s/rad (EMF/torque sabiti)
p.R = 4.0;           % Ohm     (armatür direnci)
p.L = 2.75e-6;       % H       (armatür endüktansı)

% Tasarım ayarları
p.targetBW = 50;     % rad/s hedef kapalı-çevrim bant genişliği
p.ts_ref   = 0.02;   % grafikleri çizme süresi [s]
end
