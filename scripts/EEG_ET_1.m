%limpando caracters anteriores
close all;
clear all;

% adicionando path
addpath(genpath('/Users/anasouza/ppgeb_masters'))

%mudando o diretório para onde queremos salvar os arquivos
cd('/Users/anasouza/ppgeb_masters/data/tempo_piscada')

% criando arquivos de teste
for i = 1:4
      file_name = sprintf('trial_%d.txt',i);
      fid = fopen(file_name,'w+');   %you need a delimiter or the numbers will run together
      fprintf(fid, '\n');
      fclose(fid);
end

cd('/Users/anasouza/ppgeb_masters')

%% Conectando no Mindwave Mobile II

%Carregando Biblioteca

try
    if ~libisloaded('thinkgear')
        loadlibrary('thinkgear.dll');
    else
        unloadlibrary thinkgear
        loadlibrary('thinkgear.dll');
    end
    disp('Biblioteca carregada com sucesso.')

catch
    warning('Erro para carregar thinkgear')
end

%% Setando as variáveis no Mindwave

data = ones(61440,14);
portnum1 = 4;   %COM Port #
comPortName1 = sprintf('\\\\.\\COM%d', portnum1);
segundos = 20

% Baud rate for use with TG_Connect() and TG_SetBaudrate().
TG_BAUD_115200 =      115200;

% Data format for use with TG_Connect() and TG_SetDataFormat().
TG_STREAM_PACKETS =     0;

% Data type that can be requested from TG_GetValue().
TG_DATA_POOR_SIGNAL =     1;
TG_DATA_ATTENTION =       2;
TG_DATA_MEDITATION =      3;
TG_DATA_RAW =             4;
TG_DATA_DELTA =           5;
TG_DATA_THETA =           6;
TG_DATA_ALPHA1 =          7;
TG_DATA_ALPHA2 =          8;
TG_DATA_BETA1 =           9;
TG_DATA_BETA2 =          10;
TG_DATA_GAMMA1 =         11;
TG_DATA_GAMMA2 =         12;
TG_DATA_BLINK_STRENGTH = 37;

%% Conectando com Thinkgear

connectionId1 = calllib('thinkgear', 'TG_GetNewConnectionId');
if ( connectionId1 < 0 )
  calllib('thinkgear', 'TG_FreeConnection', connectionId1 );
  error(sprintf( 'ERROR: TG_GetNewConnectionId() returned %d.\n' , connectionId1 ));
end

% Attempt to connect the connection ID handle to serial port "COM8"
errCode = calllib('thinkgear', 'TG_Connect', connectionId1,comPortName1,TG_BAUD_115200,TG_STREAM_PACKETS );
if ( errCode < 0 )
    calllib('thinkgear', 'TG_FreeConnection', connectionId1 );
    error(sprintf('ERROR: TG_Connect() returned %d.\n' , errCode) );
end


%% Gravando data como variavel MAT

fprintf( 'Connected.  Reading Packets...\n' );
for i=1:(segundos * 512)   %loop for 120 seconds
  if (calllib('thinkgear','TG_ReadPackets',connectionId1,1) == 1)   %if a   packet was read...
      for j=1:14         
        if(j == 1)
            data(i,j) = datestr(now,'dd-mm-yyyy HH:MM:SS FFF');
        end
        if(j == 2)
            if (calllib('thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_POOR_SIGNAL) ~= 0)   %if RAW has been updated 
            data(i,j) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_POOR_SIGNAL);
            end
        end
        if(j == 3)
            if (calllib('thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_ATTENTION) ~= 0)
                data(i,j) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_ATTENTION);
            end
        end
        if(j == 4)
            if (calllib('thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_MEDITATION) ~= 0) 
                data(i,j) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_MEDITATION);
            end
        end
        if(j == 5)
            if (calllib('thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_RAW) ~= 0)
                data(i,j) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_RAW);
            end
        end
        if(j == 6)
            if (calllib('thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_DELTA) ~= 0)
                data(i,j) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_DELTA);
            end
        end
        if(j == 7)
            if (calllib('thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_THETA) ~= 0)
                data(i,j) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_THETA);
            end
        end
        if(j == 8)
            if (calllib('thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_ALPHA1) ~= 0)
                data(i,j) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_ALPHA1);
            end
        end
        if(j == 9)
            if (calllib('thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_ALPHA2) ~= 0)
                data(i,j) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_ALPHA2);
            end
        end
        if(j == 10)
            if (calllib('thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_BETA1) ~= 0)
                data(i,j) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_BETA1);
            end
        end
        if(j == 11)
            if (calllib('thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_BETA2) ~= 0)
                data(i,j) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_BETA2);
            end
        end
        if(j == 12)
            if (calllib('thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_GAMMA1) ~= 0)
                data(i,j) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_GAMMA1);
            end
        end
        if(j == 13)
            if (calllib('thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_GAMMA2) ~= 0)
                data(i,j) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_GAMMA2);
            end
        end
        if(j == 14)
            if (calllib('thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_BLINK_STRENGTH) ~= 0)
                data(i,j) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_BLINK_STRENGTH);
            end
        end
     end
  end
end
fprintf( 'Completed reading data.\n');

%% Desconectando 

calllib('thinkgear', 'TG_FreeConnection', connectionId1 );
