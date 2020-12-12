function [vect_ord,link] = SortingAlgorithm(vect)
    % Sort vector 'vect' using a recursive sort algorithm consisting in  
    % a change of variable to distribute the values in different intervals
    % until there are one or two values in each interval.
    % vect_sort is a vector consisting of the sorted values of 'vect' 
    % in ascended order.
	% link is a vector consisting of the initial positions of 'vect'
    % This algorithm supports a set of Real numbers with repeated numbers.
    % Takes O(n*log(n))time.
    
    n = length(vect);
    % Search for the smallest and largest value
    max = vect(1,1);
    min = vect(1,1);
    for i = 2 : n
        if max < vect(1,i)
            max = vect(1,i);
        elseif min > vect(1,i)
            min = vect(1,i);
        end
    end
    
    if max == min
        % Stop the recursion, if all values are equal
        vect_ord(1,1:n) = max;
    else
        if log10(max-min) < 0
            fact = ceil(-log10(max-min));
            vectAux = 10^(fact)*vect;
            max = 10^(fact)*max;
            min = 10^(fact)*min;
        else
            vectAux = vect;
        end
        % Change of variable and distribute the values in different intervals
        Aux = zeros(n,n+1);
        Aux2 = zeros(n,n+1);
        link = zeros(1,n);
        for i = 1 : n
            if vectAux(1,i) == max
                pos = n;
            else
                pos = ceil(((vectAux(1,i)-min)+1)*n/((max-min)+1));
            end
            Aux(pos,n+1) = Aux(pos,n+1) + 1;
            Aux(pos,Aux(pos,n+1)) = vect(1,i);
            Aux2(pos,Aux(pos,n+1)) = i;
        end
		
        % Initialize starting indices
        vect_ord = zeros(1,n);
        j = 0;
        for i = 1 : n
            nreps = Aux(i,n+1);
            if nreps == 1
				% If there is one value in the evaluated interval is
                % solution directly
                j = j + 1;
                vect_ord(1,j) = Aux(i,1);
                link(1,j) = Aux2(i,1);
            elseif nreps == 2
				% If there are two value in the evaluated interval
                % sort both values
                if Aux(i,1) >= Aux(i,2)
                    j = j + 1;
                    vect_ord(1,j) = Aux(i,2);
                    link(1,j) = Aux2(i,2);
                    j = j + 1;
                    vect_ord(1,j) = Aux(i,1);
                    link(1,j) = Aux2(i,1);
                elseif Aux(i,1) < Aux(i,2)
                    j = j + 1;
                    vect_ord(1,j) = Aux(i,1);
                    link(1,j) = Aux2(i,1);
                    j = j + 1;
                    vect_ord(1,j) = Aux(i,2);
                    link(1,j) = Aux2(i,2);
                end
            elseif nreps > 2
				% If there are more than two value in the evaluated interval
                % sort the interval recursively
                vectAux = zeros(1,nreps);
                vectAux(1,1:nreps) = Aux(i,1:nreps);
                [vect_ord(1,j+1:j+nreps),linkAux] = alg_ord(vectAux);
                nlink = size(linkAux,2);
                for ilink = 1 : nlink
                    j = j + 1;
                    link(1,j) = Aux2(i,linkAux(1,ilink));
                end
            end
        end
    end
end