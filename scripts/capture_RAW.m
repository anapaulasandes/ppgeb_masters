%clear everything before loading
clc;
clear ALL;
pause on;

%re-read lib
unloadlibrary thinkgear
loadlibrary('thinkgear.dll');

%to save data from all columns
seg = 20
linhas = seg * 512
data = ones(linhas, 6);

%get information on device connection
portnum = 4;
comPortName = sprintf('\\\\.\\.COM%d', portnum);

%Baud rate
TG_BAUD_RATE = 115200;

%Define data format
TG_STREAM_PACKETS = 0;

%Data types
TG_DATA_POOR_SIGNAL =     1;
TG_DATA_ATTENTION =       2;
TG_DATA_MEDITATION =      3;
TG_DATA_RAW =             4;

%% Checar conexão

connect_id = callib('thinkgear', 'TG_GetNewConnectionId');
sprintf('resultado da conexão: %d. Esperado era 1.', connect_id)

%conectar na porta COM
errCode =  calllib('thinkgear', 'TG_Connect', connectionId,comPortName,TG_BAUD_115200,TG_STREAM_PACKETS );
if ( errCode < 0 )
    calllib('thinkgear', 'TG_FreeConnection', connectionId1 );
    sprintf('ERROR: TG_Connect() returned %d.\n' , errCode);
end

%% Record data

j = 0;
i = 0;

while (i < 51200)  %loop for 120 seconds
   if (calllib('thinkgear','TG_ReadPackets',connectionId1,1) == 1)   %if a   packet was read...
      for j=1:14         
        if(j == 1)
            data(i,j) = now;
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
    end
 end