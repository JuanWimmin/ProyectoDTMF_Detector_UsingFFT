function [keyH, keyL, G_spect] = dtmf_G2(x, fs)
    % Definir las frecuencias DTMF estándar
    f_dtmf = [697, 770, 852, 941, 1209, 1336, 1477, 1633];
    
    % Calcular la FFT de la señal de entrada
    N = length(x);
    X = fft(x);
    X_mag = abs(X(1:ceil(N/2)+1));

    
    % Encontrar los picos en el espectro
    [pks, locs] = findpeaks(X_mag, 'MinPeakHeight', max(X_mag)*0.6);
    
    % Identificar las frecuencias dominantes
    [~, idx] = sort(pks, 'descend');
    keyH = -1;
    keyL = -1;
    for i = 1:length(idx)
        f_idx = locs(idx(i)) * fs / N;
        [~, min_idx] = min(abs(f_idx - f_dtmf));
        if keyH == -1 && min_idx <= 4
            keyH = min_idx;
        elseif keyL == -1 && min_idx > 4
            keyL = min_idx - 4;
        end
        if keyH ~= -1 && keyL ~= -1
            break;
        end
    end
    
    % Calcular el espectro de frecuencia para depuración o análisis adicional
    G_spect = X_mag;
end