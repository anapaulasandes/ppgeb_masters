clear all
close all
%% Generate path to GP3 subfolders
[mainDir,~,~] = fileparts(mfilename('fullpath'));
addpath(genpath(mainDir));

%% Set-up Matlab to GP3 session1 socket
session1_client = ConnectToGP3;

%% Calibration
StartCalibration(session1_client);
fprintf(session1_client, '<GET ID="CALIBRATE_RESULT_SUMMARY" />');
while  session1_client.BytesAvailable > 0
 dataReceived = fscanf(session1_client);
 disp(dataReceived)
end

%% connect to mindwave
portnum1 =      4;      %COM port#
comPortName1 =  sprintf('\\\\.\\COM%d', portnum1);

%TG_BAUD_57600 = 57600; 
%Um baud é uma medida de velocidade de sinalização 
%e representa o número de mudanças na linha de transmissão ou eventos por segundo.
TG_BAUD_115200 =      115200; %uma maior numero de mudancas na linha == poder detectar piscada
% velocidade piscada 1 decimo de segundo
TG_STREAM_PACKETS =       0;
TG_DATA_BLINK_STRENGTH = 37;

%data type that can be requested from TG_GetValue().
TG_DATA_RAW =             4;

%load thinkgear dll
loadlibrary('thinkgear.dll');
fprintf('thinkgear.dll loaded\n');
%% get erros for mindwave
%get a connection ID handle to thinkgear
connectionId1 = calllib('thinkgear', 'TG_GetNewConnectionId');
if ( connectionId1 < 0 )
    error ('ERROR: TG_GetNewConnectionId() returned %d.\n', connectionId1)
end

%set/open stream (raw bytes) log file for connection
errCode = calllib('thinkgear', 'TG_SetStreamLog', connectionId1, 'streamLog.txt' )
if( errCode < 0 )
    error( 'ERROR: TG_SetStreamLog() returned %d.\n', errCode )
end

%set/open data (thinkgear values) log file for connection
errCode = calllib('thinkgear', 'TG_SetDataLog', connectionId1, 'dataLog.txt' );
if( errCode < 0 )
    error( 'ERROR: TG_SetDataLog() returned %d.\n', errCode );
end


%errCode = calllib('thinkgear', 'TG_Connect',  connectionId1,comPortName1,TG_BAUD_57600,TG_STREAM_PACKETS);
errCode = calllib('thinkgear', 'TG_Connect',  connectionId1,comPortName1,TG_BAUD_115200,TG_STREAM_PACKETS);
if ( errCode < 0 )
    error( 'ERROR: TG_Connect() returned %d.\n', errCode);
end

fprintf( 'Connected.  Reading EEG Packets...\n' );


%% Spawn a second Matlab session2 that records GP3 data to output file
outputFileName = 'scary_video.txt';
ExecuteRecordGP3Data(session1_client,outputFileName);



%% Experiment (stimuli presentation) goes here

%%
%record data

j = 0;
i = 0;
while (i < 10240)   %loop for 20 seconds
    if (calllib('thinkgear','TG_ReadPackets',connectionId1,1) == 1)   %if a packet was read...
        
            if (calllib('thinkgear','TG_GetValueStatus',connectionId1,TG_DATA_RAW) ~= 0)   %if RAW has been updated 
                j = j + 1;
                i = i + 1;
                data(j) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_RAW);
                total(i) = calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_RAW);
                SendMsgToGP3(session1_client, num2str(calllib('thinkgear','TG_GetValue',connectionId1,TG_DATA_RAW)));
            end
    end
    
    
    if (j == 256)
        modPlotRAW(data);            %plot the data, update every .5 seconds (256 points)
        j = 0;
    end
    
end

raw = total; %return value of data


%% close mindwave connection

calllib('thinkgear', 'TG_FreeConnection', connectionId1 );


%% Stop collecting data in client2
fprintf('Stop recording\n')
SendMsgToGP3(session1_client,'STOP_EYETRACKER');


%% Clean-up socket
CleanUpSocket(session1_client);
