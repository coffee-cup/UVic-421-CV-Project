function [ moved_snakes ] = MoveSnakes( img, snakes )
%MOVESNAKE Moves snakes to minimize energy
%   Returns list of new snake 

    [num_points_snake, dim, num_snakes] = size(snakes);
    
    alpha = 0.001;
    beta = 0.4;
    gamma = 100;
    iterations = 50;
    
    % Loop through snakes to move each one
    for i=1:num_snakes
        snake = snakes(:,:,i);
        
        x = snake(:,1);
        y = snake(:,2);
        
        N = length(x);
        a = gamma*(2*alpha+6*beta)+1;
        b = gamma*(-alpha-4*beta);
        c = gamma*beta;
        P = diag(repmat(a,1,N));
        P = P + diag(repmat(b,1,N-1), 1) + diag(   b, -N+1);
        P = P + diag(repmat(b,1,N-1),-1) + diag(   b,  N-1);
        P = P + diag(repmat(c,1,N-2), 2) + diag([c,c],-N+2);
        P = P + diag(repmat(c,1,N-2),-2) + diag([c,c], N-2);
        P = inv(P);
        
%         f = gradient(gradmag(img,30));
        f = imgaussfilt(img, 30);
        [Gx, Gy] = imgradientxy(f);
        
        for ii = 1:iterations
            coords = [x, y];
            fex = Gx(uint8(x));
            fey = Gy(uint8(y));
            
            % Move snake points
            x = P*(x+gamma*fex);
            y = P*(y+gamma*fey);
            if mod(ii, 5) == 0
                scatter(x, y);
                line(x, y);
            end
        end
        x
        y
        plot(x, y, 'r')
        scatter(x, y);
        line(x, y);
    end

end

