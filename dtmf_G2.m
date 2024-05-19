function [FrHigh, FrLow, Espectro] = dtmf_G2(x, N,fs)
    f_dtmf = [697, 770, 852, 941, 1209, 1336, 1477, 1633]; % Utiliza ; para crear un vector columna

    % Calcular la FFT de la señal de entrada
    X = fft(x, N);
    f = (0:N-1)*(fs/N); % calcular el vector de frecuencias
    
    % Visualizar la magnitud de la FFT
    figure(3);
    plot(f, abs(X));
    title('Magnitud de la FFT');
    xlabel('Frecuencia (Hz)');
    ylabel('Magnitud');

    % Calcular la magnitud al cuadrado de la FFT
   Magnitud_FFT = abs(X(1:ceil(N/2)+1));
    % Calcular el espectro de frecuencia para depuración o análisis adicional
    Espectro = Magnitud_FFT;

    % Calcular las frecuencias correspondientes
    % Encontrar los picos en el espectro
    [pks, locs] = findpeaks(Magnitud_FFT, 'MinPeakHeight', max(Magnitud_FFT)*0);
    
    % Identificar las frecuencias dominantes
    [~, idx] = sort(pks, 'descend');
    FrHigh = -1;
    FrLow = -1;
    for i = 1:length(idx)
        Fr_PicoActual = locs(idx(i)) * fs / N;
        [~, Fr_minima] = min(abs(Fr_PicoActual - f_dtmf));
        if FrHigh == -1 && Fr_minima <= 4
            FrHigh = Fr_minima;
        elseif FrLow == -1 && Fr_minima > 4
            FrLow = Fr_minima - 4;
        end
        if FrHigh ~= -1 && FrLow ~= -1
            break;
        end
    end
    

end