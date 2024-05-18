%% Read WAV File and get its properties
[x, fs] = audioread('AUDIOPRUEBA3.wav'); 
x = x(:,1); % Solo necesitamos un canal de las pistas
x_size = size(x);
x_length = x_size(1);
duration = x_size(1) / fs;

fprintf('Valor de fs: %d\n', fs);

%% Plot and play the DTMF audio
T = duration / x_length; % Tiempo de duración entre muestras
y = linspace(0, duration, x_length);
x_int = round(x .* 1024 - 1); % Máximo 1024-1, 10 bits AD

figure(1);
plot(y, x_int);
title('Secuencia DTMF en el dominio del tiempo');
xlabel('Tiempo (s)');
axis([0 duration -2048 2048]);

soundsc(x_int, fs); % Reproducir los tonos DTMF

%% Framing utilizando la función 'enframe'
wlen = 500;
inc = 250;
x_frame = enframe(x, wlen, inc)';
x_energy = sum(x_frame .* x_frame);

figure(2);
plot(x_energy);
title('Energía en corto tiempo de la secuencia DTMF');

Emax = max(x_energy);      % Encontrar la máxima magnitud de energía
x = [x; 0];
threshold = 0.6 * Emax;    % Establecer umbral de energía para separar los dígitos
eindex = find(x_energy > threshold);
dseg = findSegment(eindex);
dl = length(dseg);

phone_number = cell(1, dl); % Almacenar los números de teléfono detectados

%% Detectar los dígitos
for k = 1:dl
    n1 = dseg(k).begin;
    n2 = dseg(k).end;
    x1 = (n1 - 1) * inc + 1;
    x2 = (n2 - 1) * inc + 1;
    h = x(x1:x2);  % Puntos de datos en cada segmento
    xl = length(h);
    [keyH, keyL, ~] = dtmf_G2(h, fs); % Utilizar la función modificada para detectar los dígitos
    keydig = fk2dig(keyH, keyL);
    fprintf('%4d   %4d   %4d   %s\n', k, keyH, keyL, keydig);
    phone_number{k} = keydig;
end

%% Mostrar resultados
disp('Números de teléfono detectados:');
disp(phone_number);
