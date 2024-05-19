%% LEER EL AUDIO ELEGIDO
[x, fs] = audioread('AUDIOPRUEBA.wav'); 
x = x(:,1); % Solo necesitamos un canal de las pistas
x_size = size(x);
x_length = length(x);
duration = x_length/ fs;

fprintf('Frecuencia de muestreo: %d Hz\n', fs);
fprintf('Duración de la señal: %f segundos\n', duration);

%% DIAGRAMA Y REPRODUCCION DEL AUDIO FILTRADO
y = linspace(0, duration, x_length);
T = duration/x_length; %duration time between samples
for i=1:1:x_length
    y(i) = T*i;
end
x_int = round(x .* 1024 - 1); % Máximo 1024-1, 10 bits AD

figure(1);
plot(y, x_int);
title('Secuencia DTMF en el dominio del tiempo');
xlabel('Tiempo (s)');
axis([0 duration -2048 2048]);

soundsc(x_int, fs); % Reproducir los tonos DTMF

%% Framing utilizando la función 'enframe'
TamanoVentana = 500;
Incremento = 250;
tramo = enframe(x, TamanoVentana, Incremento)';
EnergiaTramo = sum(tramo .* tramo);

figure(2);
plot(EnergiaTramo);
title('Energía  de la secuencia DTMF');
EnergiaMaPorcionOriginalSenalramo = max(EnergiaTramo);      % Encontrar la máxima magnitud de energía
x = [x; 0];
UmbraEnergia = 0.5 * EnergiaMaPorcionOriginalSenalramo;    % Establecer umbral de energía para separar los dígitos
IndiceMayor = find(EnergiaTramo > UmbraEnergia);
BuscarIndice = findSegment(IndiceMayor);
CantidadDigitos = length(BuscarIndice);

phone_number = cell(1, CantidadDigitos); % Almacenar los números de teléfono detectados

%% Detectar los dígitos
for k = 1:CantidadDigitos
    IndiceInicial = BuscarIndice(k).begin;
    IndiceFinal = BuscarIndice(k).end;
    x1 = (IndiceInicial - 1) * Incremento + 1;
    x2 = (IndiceFinal - 1) * Incremento + 1;
    PorcionOriginalSenal = x(x1:x2);  % Puntos de datos en cada segmento
    N = length(PorcionOriginalSenal);
    [FrHigh, FrLow, Espectro] = dtmf_G2(PorcionOriginalSenal, N,fs); % Utilizar la función modificada para detectar los dígitos
    Digito = fk2dig(FrLow, FrHigh); % Índice de fila, índice de columna
    fprintf('%4d   %4d   %4d   %s\n', k, FrHigh, FrLow, Digito);
    phone_number{k} = Digito;
end

%% Mostrar resultados
disp('Números de teléfono detectados:');
disp(phone_number);