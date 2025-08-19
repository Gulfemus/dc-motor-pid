function [P,s] = build_plant(p)
% P(s) = K / ((J*s + b)*(L*s + R) + K^2)
s = tf('s');
P = p.K / ( (p.J*s + p.b)*(p.L*s + p.R) + p.K^2 );
end
