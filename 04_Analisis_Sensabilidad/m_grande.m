function  [ans,z,x,iteraciones,indB,precioSombra] = m_grande(A,b,c,typeProblem)
    % M_GRANDE Inicialziacion con la estrategia m_grande
    %
    % Sintaxis:
    %   resultado = m_grande(A,b,c, default typeProblem=min)
    %
    % Descripción:
    %   Esta funcion determina si el PL(Problema de Programacion Lineal) tiene:
    %       - Infactibilidad
    %       - Solucion Optima Finita
    %       - Solucion optima Ilimitada
    %
    % Parámetros:
    %   A mxn
    %   b mx1
    %   c nx1
    %   typeProblem {min,max}
    %
    % Output:
    %   ans:
    %   z:
    %   x:
    %   iteraciones:
    %   indB:
    % precioSombra:


    %if nargin < 4
    %    typeProblem = 'min';
    %endif
	if(typeProblem == 'max')
		for i = 1:length(c)
			c(i) = -c(i);
		endfor
	endif
	inf = 1e7;
	% verificar que b > 0
	b_size = length(b);
	%disp("before")
	%A
	%b
	[m,n] = size(A);
	for row=1:length(b)
		if( b(row) < 0)
			b(row) = -b(row);
			A(row, :) = -A(row, :);
		endif
	endfor

	A = [A eye(m)];
	c = [c; inf*ones(m,1)];
	%disp("after")

	indB = (n+1:n+m);
	%A
	%b
	%c
	%indB
	[z,x,iteraciones,indB,type,precioSombra] = simplex(A,b,c,indB);
    %disp("indB");
    %indB

	% Clasificando el problema grande
	%if(type == 'optima_finita')
	% Caso Optima finita
	if(length(z) != 0)
		allZeros = true;
		%for i=n+1:n+m
		%	if(x(i) != 0) allZeros = false;
		%	endif
		%endfor
		allZeros = min(x(n+1:n+m)) == 0;
		if(allZeros)
            ans = ('PL Tiene solucion optima finita');

		else ans = ('PL es infactible');
		endif
	else % valor optimo ilimitado
		%allZeros = true;
		%for i = 1:n
		%	if(x(i) != 0) allZeros = false;
		%	endif
		%endfor
		allZeros = min(x(n+1:n+m)) == 0;
		if(allZeros)
			if(typeProblem == 'max') ans = ("PL tiene solucion optima ilmitada superiorente");
			else ans = ("PL tiene solucion optima ilmitada inferiormente");
			endif
		else ans = ("PL es infactible");
		endif
	endif
	if typeProblem == 'max'
        z = -z;
        precioSombra = -precioSombra;
	endif
endfunction
