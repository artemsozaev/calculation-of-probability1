clear all

%Константы
omega = 20*pi;
phi = 0;
%Переменные
delta_omega = 0;
a = [0 2 4 6 8 10];
a_0 = {'h1', 'h2', 'h3', 'h4', 'h5', 'h6'};
specification = {'M', 'delta_omega', 'gamma', '', '', ''};
k0 = {'k1', 'k2', 'k3', 'k4', 'k5', 'k6'};

varNames = {'eps = -4', 'eps = -3', 'eps = -2','eps = -1', 'eps = 0', 'eps = 1','eps = 2', 'eps = 3', 'eps = 4', 'eps = 5', 'eps = 6', 'eps = 7', 'eps = 8', 'eps = 9', 'eps = 10', 'eps = 11', 'eps = 12',  'h', ' ', 'specification', '-', 'k', 'W_cp','W_cp1'};
Table = table (a', a', a', a', a', a', a', a', a', a', a', a', a', a', a', a', a', a_0', a', specification', [0 0 0 0 0 0]', a', a', a', 'VariableNames', varNames, 'RowNames', {'P_1'; 'P_2'; 'P_3'; 'P_4'; 'P_5'; 'P_6'});
String = 'A1';
d = '1';
M = 2;
U = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%при delta_omega == 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gamma = 0;   
for j = 1 : 9
    %Вводим специальные поля
    Table (1, 21) = num2cell (M);
    Table (2, 21) = num2cell (delta_omega);
    Table (3, 21) = num2cell (gamma);

    for i = 0:5 %счетчик отвечает за параметр h          
        h = 0.2 * i;
        V = U*h;
        alpha =@(gamma)(gamma - phi);

        W_c = U^2;
        W_cp = @(gamma)(U^2 + V^2 + 2*U*V*cos(alpha(gamma)));
    

        k = @(gamma)(W_cp(gamma) / W_c);
        
        Table(i + 1, 21) = num2cell(k(gamma));
        Table(i + 1, 22) = num2cell(W_cp(gamma));
        
        %eps_db = [10.970 12.362 13.4646];
        eps_db = [-4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12];
        eps = 10.^(eps_db/10);

        for i_1 = 1:17
                    P =erfc(sqrt(eps.*k(gamma)))/2;

                Table (i + 1, i_1) = {P(i_1)};
        end
        Table (i + 1, 19) = num2cell(h);
    end

    %Записываем таблицу в файл
    writetable (Table, 'Таблица.xls', 'WriteRowNames', true, 'Range', String)
    Sub_string = String(2: my_function (str2num (d)) + 1);
    d = str2num (Sub_string) + 8;
    d = string (d);
    String = strrep (String, Sub_string, d);
    String = convertStringsToChars(String);
    gamma = gamma + pi/4;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%при delta_omega != 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

delta_omega = 0.02;

for j = 0:1 %счетчик отвечает за изменение угла
    gamma = -pi;
    for j = 1 : 9
        %Вводим специальные поля
        Table (1, 21) = num2cell (M);
        Table (2, 21) = num2cell (delta_omega);
        Table (3, 21) = num2cell (gamma);
        for i = 0:5 %счетчик отвечает за параметр h          
            h = 0.2 * i;
            V = U*h;
            alpha = @(gamma)(gamma - phi);
            beta = @(gamma)(delta_omega * omega + alpha(gamma));
                        
            const_1 = U^2 + V^2;
            const_2 = 2*U*V / (delta_omega * omega);

            
            W_cp1 = @(gamma)(const_1 + const_2 * (sin(beta(gamma)) - sin(alpha(gamma))));
            W_c = U^2;
            
            k = @(gamma)(W_cp1(gamma) / W_c);
        %eps_db = [10.970 12.362 13.4646];
        eps_db = [-4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10 11 12];
            eps = 10.^(eps_db/10);
            for i_1 = 1:3
                  P = erfc(sqrt(eps.*k(gamma)))/2;
                Table (i + 1, i_1) = {P(i_1)};
            end
            Table (i + 1, 19) = num2cell(h);
        end
        
        %Записываем таблицу в файл
        writetable (Table, 'Таблица.xls', 'WriteRowNames', true, 'Range', String)
        Sub_string = String(2: my_function (str2num (d)) + 1);
        d = str2num (Sub_string) + 8;
        d = string (d);
        String = strrep (String, Sub_string, d);
        String = convertStringsToChars(String);
        gamma = gamma + pi/4;
    end
    
    delta_omega = delta_omega + 0.02;
end 
