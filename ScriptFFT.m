% Leer archivo de audio
[x, fs] = audioread('AUDIOPRUEBA.wav'); 
x = x(:,1); % solo un canal
x_length = length(x);
duration = x_length / fs;

% Mostrar información básica
fprintf('Frecuencia de muestreo: %d Hz\n', fs);
fprintf('Duración de la señal: %f segundos\n', duration);

% Graficar la señal en el dominio del tiempo
t = linspace(0, duration, x_length);
figure;
plot(t, x);
title('Señal de audio en el dominio del tiempo');
xlabel('Tiempo (s)');
ylabel('Amplitud');

% Parámetros de la ventana
wlen = 500; % Longitud de la ventana
inc = 250; % Incremento entre ventanas

% Dividir la señal en segmentos
x_frames = enframe(x, wlen, inc);
% Frecuencias DTMF
low_freqs = [697, 770, 852, 941];
high_freqs = [1209, 1336, 1477, 1633];
tolerance = 0.5; % Tolerancia en Hz para la detección de frecuencias

num_frames = size(x_frames, 1);
detected_digits = [];

for frame_idx = 1:num_frames
    frame = x_frames(frame_idx, :);
    
    % Calcular la FFT del segmento
    N = 2^nextpow2(length(frame)); % Asegurarse de que N es una potencia de 2
    X = fft(frame, N);
    f = (0:N-1)*(fs/N);
    X_magnitude = abs(X);

    % Identificar las componentes de frecuencia DTMF
    detected_low_freq = NaN;
    detected_high_freq = NaN;

    for i = 1:length(low_freqs)
        [~, idx] = min(abs(f - low_freqs(i)));
        if X_magnitude(idx) > mean(X_magnitude) + tolerance
            detected_low_freq = low_freqs(i);
            break;
        end
    end

    for i = 1:length(high_freqs)
        [~, idx] = min(abs(f - high_freqs(i)));
        if X_magnitude(idx) > mean(X_magnitude) + tolerance
            detected_high_freq = high_freqs(i);
            break;
        end
    end

    % Mapear las frecuencias detectadas a los dígitos DTMF
    if ~isnan(detected_low_freq) && ~isnan(detected_high_freq)
        if detected_low_freq == 697
            if detected_high_freq == 1209
                digit = '1';
            elseif detected_high_freq == 1336
                digit = '2';
            elseif detected_high_freq == 1477
                digit = '3';
            elseif detected_high_freq == 1633
                digit = 'A';
            end
        elseif detected_low_freq == 770
            if detected_high_freq == 1209
                digit = '4';
            elseif detected_high_freq == 1336
                digit = '5';
            elseif detected_high_freq == 1477
                digit = '6';
            elseif detected_high_freq == 1633
                digit = 'B';
            end
        elseif detected_low_freq == 852
            if detected_high_freq == 1209
                digit = '7';
            elseif detected_high_freq == 1336
                digit = '8';
            elseif detected_high_freq == 1477
                digit = '9';
            elseif detected_high_freq == 1633
                digit = 'C';
            end
        elseif detected_low_freq == 941
            if detected_high_freq == 1209
                digit = '*';
            elseif detected_high_freq == 1336
                digit = '0';
            elseif detected_high_freq == 1477
                digit = '#';
            elseif detected_high_freq == 1633
                digit = 'D';
            end
        else
            digit = 'Desconocido';
        end
        detected_digits = [detected_digits, digit];
    end
end

% Mostrar los dígitos detectados
fprintf('Dígitos DTMF detectados: %s\n', detected_digits);
