function choice = FYPGui
    SerialPort = 'COM9'; %serial port
    %% Set up the serial port object
    s = serial(SerialPort,'BaudRate',115200,'Terminator','CR');
    disp('Opening port...')
    fopen(s);
    disp('Done opening port...')
    d = dialog('Position', [850 600 250 150], 'Name', 'Position Control GUI');
    % Label
    txt = uicontrol('Parent', d, ...
        'Style', 'text', ...
        'Position', [20 100 210 40], ...
        'String', 'Input a position (mm)');
    % Textbox
    cmdInput = uicontrol('Parent', d, ...
        'Style', 'edit', ...
        'Position', [50 80 150 20]);
    
    % Start Button
    cmdBtn = uicontrol('Parent', d, ...
        'Position', [40 30 65 25], ...
        'String', 'Start', ...
        'Callback', @plotData);
    
    % Close Button
    closeBtn = uicontrol('Parent', d, ...
        'Position', [145 30 65 25], ...
        'String', 'Close', ...
        'Callback', 'delete(gcf)');
    
    %     Wait for d to close before running to completion
    uiwait(d);

    function plotData(cmdBtn, event)
        %% Send command value from the input to the RPI Pico
        cmd = cmdInput.String;
        if isempty(cmd)
            txt.String = 'Please input a value';
        else
            SerialPort = 'COM9'; %serial port
            MaxDeviation = 1; % Maximum Allowable from one value to next
            TimeInterval = 0.001; % time interval between each input
            loop = 1500; % count values
            time = 0;
            position = 0;
            %% Set up the figure
            disp('Setting up graph...')
            figureHandle = figure('NumberTitle','off',...
                'Name','Cylinder Position Response Time Graph',...
                'Color',[0 0 0],'Visible','off');

            % Set axes
            axesHandle = axes('Parent',figureHandle,...
                'YGrid','on',...
                'YColor',[0.9725 0.9725 0.9725],...
                'XGrid','on',...
                'XColor',[0.9725 0.9725 0.9725],...
                'Color',[0 0 0]);

            hold on;
            plotHandle = plot(axesHandle,time,position,'Marker','.','LineWidth',0.5,'Color',[0 1 0]);
            ylim(axesHandle,[0, 250]);
            xlim(axesHandle,[0, 1.5]);

            % Create xlabel
            xlabel('Time','FontWeight','bold','FontSize',14,'Color',[1 1 0]);

            % Create ylabel
            ylabel('Position in mm','FontWeight','bold','FontSize',14,'Color',[1 1 0]);

            % Create title
            title('Cylinder Position vs Time','FontSize',15,'Color',[1 1 0]);
            disp('Done setting graph...')
            %% Initializing variables

            position(1)=str2double(fscanf(s));
            if isnan(position(1))
               position(1) = 0 
            end
%             position(1) = 0;
            
            disp('Sending cmd to pico...')
            fprintf(s, '%s', cmd);
            disp('Done sending cmd...')
            
            time(1)=0;
            count=2;
            disp('Plotting...')
            while ~isequal(count,loop)
                %% Serial data acessing
                position(count) = str2double(fscanf(s));
                if isnan(position(count))
                    position(count) = position(count-1)
                end
                
                fprintf('%f\r\n', position(count));
                if (abs(position(count)-position(count-1))< MaxDeviation)
                    position(count)= position(count-1);
                elseif (abs(position(count)-position(count-1))>250)
                    position(count)=position(count-1)
                end
                time(count) = time(count-1) + TimeInterval;
                fprintf('time: %f\r\n', time(count));
                
                set(plotHandle,'YData',position,'XData',time);
                set(figureHandle,'Visible','on');
                
                pause(TimeInterval);
                count=count+1;
            end
            disp('Done plotting...')
            txt.String = 'You can now input a new value';
            [R,lt,ut,ll,ul] = risetime(position, time);
            [settling_time, slev, sinst] = settlingtime(position, time, 0.5);
            [oo,lv,nst] = overshoot(position);
            sse = abs(str2double(cmd) - position(end));
            disp(R)
            disp(sinst)
            disp(oo)
            disp(sse)
%             hold on
            plot([lt ut],[ll ul],"o", 'LineWidth', 1.5, 'Color', [1 0 0])
            plot(sinst, slev, 'x', 'LineWidth', 1.5, 'Color', [1 0 0])
%             hold off
            clear position;
            clear time;
        end
        
    end
    %% Clean up the serial port
    disp('Closing port...')
    fclose(s);
    delete(s);

    clear s;
    disp('Done closing port')
end