function [ans,z,x,iteraciones]=sensibilidad(A,b,c,typeProblem)
    [ans,z,x,iteraciones,indB, precioSombra] = m_grande(A,b,c,typeProblem);
    [m,n] = size(A);

    R=setdiff(1:n,indB);
    B=A(:,indB);
    N=A(:,R);
    cB=c(indB);
    cR = c(R);
    iB=inv(B);

    variacionC = zeros(1,n);
    variacionC_Limites = zeros(n,2);
    variacionB = zeros(m,2);

    %indB

    if(ans == 'PL Tiene solucion optima finita')
        %disp("log");
        %% C NO ES BASICA
        variacionC(R) = c(indB)'*inv(B)* A(:,R) - c(R)';
        %variacionC
        variacionC_Limites(R,1) =variacionC(R)';
        variacionC_Limites(R,2) = inf;
        %variacionC_Limites




        % C ES BASICA
        Y = iB*N;
        Z = cB'*Y;
        ci_zi = cR'-Z;
        [m_,n_] = size(Y);
        %for i=1:m_
        %    variacionC(indB(i)) = min(ci_zi./Y(i,:));
        %endfor
        for i=1:m_
            minimo = inf;
            maximo = -inf;
            for j =1:n_
                %if Y(i,j) == 0
                if Y(i,j) > 0
                    minimo = min(minimo, ci_zi(j)/Y(i,j));
                else
                    maximo = max(maximo, ci_zi(j)/Y(i,j));
                endif
            endfor
            variacionC_Limites(indB(i),1) = maximo;
            variacionC_Limites(indB(i),2) = minimo;
        endfor
        %variacionC_Limites


        % Cambios en las disponibilidades b
       Q=iB*-b;
       P=iB*eye(m);
       for i=1:m
           minimo = inf;
           maximo = -inf;
           for j=1:m
               if P(j,i) == 0
                    if Q(j) < 0 maximo = max(maximo,-inf);
                    else maximo = max(maximo, inf);
                    endif
               elseif P(j,i) > 0
                   maximo = max(maximo,Q(j)/P(j,i));
               else
                   minimo = min(minimo, Q(j)/P(j,i));
               endif
           endfor
           variacionB(i,1) = maximo;
           variacionB(i,2) = minimo;
       endfor

       disp("\tANALISIS DE SENSIBILIDAD\n");
       disp("\tPrecio Sombra\n");
       for i=1:m
           fprintf('b(%d) \t%.2f \t%.2f\n', i, b(i),precioSombra(i));
       endfor

       fprintf("\n\t Cambios en las disponibilidades b\n");
       %variacionB
       for i = 1:m
           fprintf('b(%d) \t%.2f  \t Δ in [%.2f, %.2f]\n', i, b(i),variacionB(i,1),variacionB(i,2));
       endfor
       %variacionC
       fprintf("\n\t Cambios en los costos c\n");
       for i=1:n
           fprintf('c(%d) \t%.2f \t Δ in [%.2f, %.2f]\n',i,c(i), variacionC_Limites(i,1), variacionC_Limites(i,2));
       endfor
       disp("\n");

    endif
endfunction
