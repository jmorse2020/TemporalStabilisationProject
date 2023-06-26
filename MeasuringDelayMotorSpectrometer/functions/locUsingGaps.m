function loc = locUsingGaps(arr, tol) % tolerence as a decimal percentage  < 1
    gap = [];
    for i = 2 : length(arr)
        gap(i) = arr(i) - arr(i - 1);
    end
    [maxGaps, ind] = maxk(gap, 3);
%     disp("Length of ind is" + length(ind));
%     disp("Indices: " + ind(1) + " " + ind(2) + " " + ind(3))
    % Reorder:
    for j = 1:3
        for k = 1:2
            if ind(k) > ind(k + 1)
                ind_temp = ind(k);
                maxGap_temp = maxGaps(k);
                ind(k) = ind(k + 1);
                maxGaps(k) = maxGaps(k + 1);
                ind(k + 1) = ind_temp;
                maxGaps(k + 1) = maxGap_temp;            
            end
        end
    end
%     disp("Indices: " + ind(1) + " " + ind(2) + " " + ind(3))
    A = maxGaps(1);
    B = maxGaps(2);
    C = maxGaps(3);
%     disp("A = " + A);
%     disp("B = " + B);
%     disp("C = " + C);
    if and(A < C*(1  + tol), A > C*(1 - tol))        
%         disp("initial " + arr(ind(1) - 1))
%         disp("Final " + arr(ind(3)))
        loc = (arr(ind(1) - 1) + arr(ind(3)))/2;
    else
        if A > C
            tol = A/C - 1;
%             disp("(A > C) tol = " + tol)
        else
            tol = 1 - A/C;
%             disp("(A < C) tol = " + tol)
        end
    end
end