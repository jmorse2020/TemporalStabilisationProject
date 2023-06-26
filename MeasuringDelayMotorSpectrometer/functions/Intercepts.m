function intercepts = Intercepts(xData, yData, val)
    intercept = [];
    j = 1;
    for i = 2:length(yData)
        y1 = yData(i - 1);
        y2 = yData(i);
        if (y1 == val)
            intercept(j) = y1;
        elseif (y2 == val)
            intercept(j) = y2;
        elseif and(y1 > val, y2 < val)
            x1 = xData(i-1);
            x2 = xData(i);           
            m = (y2 - y1) / (x2 - x1);
            c = y1 - m*x1;
            x_intercept = (val - c) / m;
            intercept(j) = x_intercept;
%             disp('>')
        elseif and(y1 < val, y2 > val)
            x1 = xData(i-1);
            x2 = xData(i);        
            m = (y2 - y1) / (x2 - x1);
            c = y1 - m*x1;
            x_intercept = (val - c) / m;
            intercept(j) = x_intercept;
%             disp('<')
        else
            j = j - 1;
        end
        j = j + 1;
    end
    intercepts = intercept;
    return;
end