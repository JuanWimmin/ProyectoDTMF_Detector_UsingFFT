function Digito = fk2dig(frHIGH, frLOW)
    % Mapeo de frecuencias a dígitos DTMF
    DTMF_table = ['1', '2', '3', ;...
                  '4', '5', '6';...
                  '7', '8', '9';...
                  '*', '0', '#'];
    
    % Verificar las frecuencias y devolver el dígito correspondiente
    if frHIGH >= 1 && frHIGH <= 4 && frLOW >= 1 && frLOW <= 4
        Digito = DTMF_table(frLOW, frHIGH); % El índice [row, column] se invierte para acceder a la tabla
    else
        Digito = 'No válido';
    end
end
