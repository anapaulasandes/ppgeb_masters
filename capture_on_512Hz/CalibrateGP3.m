function CalibrateGP3(conexao_1, delay)
fprintf(conexao_1, '<SET ID="CALIBRATE_RESET"/>');
fprintf(conexao_1, '<SET ID="CALIBRATE_SHOW" STATE="1" />');
fprintf(conexao_1, '<SET ID="CALIBRATE_START" STATE="1" />');
pause(delay); %tempo do delay em segundos
fprintf(conexao_1,'<SET ID="CALIBRATE_START" STATE="0" />');
fprintf(conexao_1,'<SET ID="CALIBRATE_SHOW" STATE="0" />');

fprintf(conexao_1, '<GET ID="CALIBRATE_RESULT_SUMMARY" />');
while  conexao_1.BytesAvailable > 0
    dataReceived = fscanf(conexao_1);
    disp(dataReceived)
end
