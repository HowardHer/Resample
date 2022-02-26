function y = resamp(x, r)
    % Get the upsampling factor U, and the downsampling factor D
    [U, D] = rat(r);
    % If U is 1, assign y equals to x, and check if downsampling is needed
    % later on
    if U == 1
        y = x;
    end
    
    if U ~= 1
        %% Upsampling
        % 1) Insert U - 1 zeros between each data point
        y(1:U:U*length(x)) = x;
        % 2) Create the Kaiser filter
        wc = pi/U;
        fn = wc/pi;
        N = round(1+20/fn);
        h = U*fir1(N-1,fn,kaiser(N, 5));
        % 3) Convolution
        y = conv(y,h);
        % 4) Get rid of the extra points so that the y sequence keeps the
        %    length of U*(length(x) - 1) + 1
        while length(y) ~= (U*(length(x) - 1) + 1)
            y(length(y)) = [];
            y(1) = [];
        end
    end
    
    if D ~= 1
        %% Downsampling
        % 1) Create the lowpass filter for downsampling
        wc = pi/D;
        fn = wc/pi;
        N = round(1+20/fn);
        h = fir1(N-1,fn,kaiser(N, 5));
        % 2) Convolution
        y = conv(y,h);
        % 3) Get rid of the extra points so that the y sequence keeps the
        %    length of U*(length(x) - 1) + 1
        while length(y) ~= (U*(length(x) - 1) + 1)
            y(length(y)) = [];
            y(1) = [];
        end
        % 4) Choose 1 data point per D points from y to form the new y
        for index = length(y):-1:1
            if mod((index-1),D) ~= 0
                y(index) = [];
            end
        end
    end
end