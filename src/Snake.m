classdef Snake < handle
    %SNAKE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Access=public)
        points = SnakePoint.empty;
        elasticForceSum = [0, 0];
        curvatureForceSum = [0, 0];
        imageForceSum = [0, 0];
        center = [0, 0];
        
        scale = 5.0
        
        elasticity = 0.1;
        alpha = 0.1;   % elasticity
        
        curvature = 0.5;
        beta = 0.3;     % curvature
        
        imageforce = 0.1;
        gamma = 0.9;   % outer img force
    end
    
    methods(Access=public)
        function this = Snake()
            this.points = SnakePoint.empty;
            this.elasticForceSum = [0, 0];
            this.curvatureForceSum = [0, 0];
            this.imageForceSum = [0, 0];
            this.center = [0, 0];
            
            this.elasticity = 0.1;
            this.alpha = 0.1;
            
            this.curvature = 0.5;
            this.beta = 0.3;
            
            this.imageforce = 0.1;
            this.gamma = 0.9;
        end
        
        function addPoint(this, position)
            point = SnakePoint();
            point.position = position;
            this.points(end + 1) = point;
            this.center = [1, 2];
        end
        
        function deleteAllPoints(this)
            this.points = SnakePoint.empty;
            this.elasticForceSum = [0, 0];
            this.curvatureForceSum = [0, 0];
            this.imageForceSum = [0, 0];
            this.center = [0, 0];
        end   
        
        function hImg = draw(this, sourceImage, outputImage)
            fprintf('Values\n');
            fprintf('======\n');
            fprintf('Elasticity  %s\n', this.elasticity);
            fprintf('Alpha       %s\n', this.alpha);
            fprintf('\n');
            fprintf('Curvature   %s\n', this.curvature);
            fprintf('Beta        %s\n', this.beta);
            fprintf('\n');
            fprintf('Image force %s\n', this.imageforce);
            fprintf('Gamma       %s\n', this.gamma);
            
            points = size(this.points);
            nPoints = points(2);
            if (nPoints < 2)
                % helpdlg('No points given, exiting..');
                hImg = imshow(outputImage);
                return
            end
            
            this.calculateForces(sourceImage);
            
            pointCoords = [nPoints 3];
            lineCoords = [nPoints 4];
            efLineCoords = [nPoints 4];
            cfLineCoords = [nPoints 4];
            ifLineCoords = [nPoints 4];
            
            for n = 1 : nPoints
                currentPoint = this.points(1, n);
                nextPoint = SnakePoint();
                
                if (n < nPoints)
                    nextPoint = this.points(1, n + 1);
                else
                    nextPoint = this.points(1, 1);
                end
            
                pointCoords(n, 1) = currentPoint.position(1, 1) - 1.0;
                pointCoords(n, 2) = currentPoint.position(1, 2) - 1.0;
                pointCoords(n, 3) = 2.0;
                
                lineCoords(n, 1) = currentPoint.position(1, 1);
                lineCoords(n, 2) = currentPoint.position(1, 2);
                lineCoords(n, 3) = nextPoint.position(1, 1);
                lineCoords(n, 4) = nextPoint.position(1, 2);
                
                elasticityForce = currentPoint.position + currentPoint.elasticForce * this.scale;
                efLineCoords(n, 1) = currentPoint.position(1, 1);
                efLineCoords(n, 2) = currentPoint.position(1, 2);
                efLineCoords(n, 3) = elasticityForce(1, 1);
                efLineCoords(n, 4) = elasticityForce(1, 2);
                
                curvatureForce = currentPoint.position + currentPoint.curvatureForce * this.scale;
                cfLineCoords(n, 1) = currentPoint.position(1, 1);
                cfLineCoords(n, 2) = currentPoint.position(1, 2);
                cfLineCoords(n, 3) = curvatureForce(1, 1);
                cfLineCoords(n, 4) = curvatureForce(1, 2);
                
                imageForce = currentPoint.position + currentPoint.imageForce * this.scale;
                ifLineCoords(n, 1) = currentPoint.position(1, 1);
                ifLineCoords(n, 2) = currentPoint.position(1, 2);
                ifLineCoords(n, 3) = imageForce(1, 1);
                ifLineCoords(n, 4) = imageForce(1, 2);
            end
            
            circleInserter =  vision.ShapeInserter('Shape','Circles','BorderColor','Custom', 'CustomBorderColor', uint8([255 0 0]));
            lineInserter = vision.ShapeInserter('Shape', 'Lines', 'BorderColor', 'Custom', 'CustomBorderColor', uint8([255 0 0]));
            efLineInserter = vision.ShapeInserter('Shape', 'Lines', 'BorderColor', 'Custom', 'CustomBorderColor', uint8([0 0 255]));
            cfLineInserter = vision.ShapeInserter('Shape', 'Lines', 'BorderColor', 'Custom', 'CustomBorderColor', uint8([255 255 0]));
            ifLineInserter = vision.ShapeInserter('Shape', 'Lines', 'BorderColor', 'Custom', 'CustomBorderColor', uint8([0 255 0]));
            centerInserter = vision.ShapeInserter('Shape','Circles','BorderColor','Custom', 'CustomBorderColor', uint8([255 255 255]));
            
            if (islogical(outputImage))
                rawImg = double(cat(3, outputImage, outputImage, outputImage));
            else
                rawImg = repmat(outputImage, [1 1 3]);
            end
            
            
            J = step(circleInserter, rawImg, int32(pointCoords));
            K = step(lineInserter, J, int32(lineCoords));
            L = step(efLineInserter, K, int32(efLineCoords));
            M = step(cfLineInserter, L, int32(cfLineCoords));
            N = step(ifLineInserter, M, int32(ifLineCoords));
            
            centerX = this.center(1, 1);
            centerY = this.center(1, 2);
            O = step(centerInserter, N, int32([centerX - 1.0, centerY - 1.0, 2.0]));
            
            sumEF = this.center + this.elasticForceSum * this.scale;
            sumCF = this.center + this.curvatureForceSum * this.scale;
            sumIF = this.center + this.imageForceSum * this.scale;
            
            P = step(...
                efLineInserter, ...
                O, ...
                int32([ ...
                    centerX, centerY, ...
                    sumEF(1, 1), sumEF(1, 2) ...
                ]));
            Q = step(...
                cfLineInserter, ...
                P, ...
                int32([ ...
                    centerX, centerY, ...
                    sumCF(1, 1), sumCF(1, 2) ...
                ]));
            R = step(...
                ifLineInserter, ...
                Q, ...
                int32([ ...
                    centerX, centerY, ...
                    sumIF(1, 1), sumIF(1, 2) ...
                ]));            
            
            hImg = imshow(R);
        end
        
        function calculateForces(this, hImage)            
            this.center = zeros(1,2);
            
            points = size(this.points);
            nPoints = points(2);
            
            for n = 1 : nPoints
                currentPoint = this.points(1, n);
                this.center = this.center + currentPoint.position;
            end
            
            this.center = this.center / nPoints;
            
            this.elasticForceSum = [0 0];
            this.curvatureForceSum = [0 0];
            this.imageForceSum = [0 0];
            
            for n = 1 : nPoints
                currentPoint = this.points(1, n);
                
                % Get neighbours
                nextNeighbour = SnakePoint();
                prevNeighbour = SnakePoint();
                
                if (n == 1)
                    nextNeighbour = this.points(1, n + 1);
                    prevNeighbour = this.points(1, nPoints);
                elseif (n == nPoints)
                    nextNeighbour = this.points(1, 1);
                    prevNeighbour = this.points(1, n - 1);
                else
                    nextNeighbour = this.points(1, n);
                    prevNeighbour = this.points(1, n - 1);
                end
                
                % Calculate elasticity
                elastForceNext = nextNeighbour.position - currentPoint.position;
                elastForcePrev = prevNeighbour.position - currentPoint.position;
                currentPoint.elasticForce = elastForceNext + elastForcePrev;
                currentPoint.elasticForce = currentPoint.elasticForce * this.alpha * this.elasticity;
                this.elasticForceSum = this.elasticForceSum + currentPoint.elasticForce;
                
                % Calculate curvature force
                currentPoint.curvatureForce = (prevNeighbour.position + nextNeighbour.position - (2 * currentPoint.position));
                currentPoint.curvatureForce = currentPoint.curvatureForce * this.beta * this.curvature;
                this.curvatureForceSum = this.curvatureForceSum + currentPoint.curvatureForce;
                
                % Calculate image force
                x = currentPoint.position(1, 1);
                y = currentPoint.position(1, 2);
                [imgWidth, imgHeight] = size(hImage);
                x = min(x, imgWidth - 2);
                x = max(x, 1);
                y = min(y, imgHeight - 2);
                y = max(y, 1);
                
                xNextForce = impixel(hImage, x + 1, y);
                xNextForce = xNextForce(1);
                xPrevForce = impixel(hImage, x - 1, y);
                xPrevForce = xPrevForce(1);
                yNextForce = impixel(hImage, x, y + 1);
                yNextForce = yNextForce(1);
                yPrevForce = impixel(hImage, x, y - 1);
                yPrevForce = yPrevForce(1);
                
                currentPoint.imageForce(1, 1) = xNextForce - xPrevForce;
                currentPoint.imageForce(1, 2) = yNextForce - yPrevForce;
                currentPoint.imageForce = currentPoint.imageForce * this.gamma * this.imageforce;
                this.imageForceSum = this.imageForceSum + currentPoint.imageForce;
            end
        end
        
        function update(this)
            points = size(this.points);
            nPoints = points(2);
            
            if (nPoints < 3)
                return
            end
            
            for n = 1 : nPoints
                currentPoint = this.points(1, n);
                currentPoint.position = currentPoint.position + currentPoint.elasticForce + currentPoint.curvatureForce + currentPoint.imageForce;
            end
        end
        
        function doublePoints(this)
            points = this.points;
            this.points = SnakePoint.empty;
            
            pointsSize = size(points);
            nPoints = pointsSize(2);
            
            for n = 1 : nPoints
                currentPoint = points(1, n);
                nextPoint = SnakePoint();
                
                if (n < nPoints)
                    nextPoint = points(1, n + 1);
                else
                    nextPoint = points(1, 1);
                end
                
                this.addPoint(currentPoint.position);
                this.addPoint((currentPoint.position + nextPoint.position) * 0.5);
            end
        end
        
        function halfPoints(this);
            pointsSize = size(this.points);
            nPoints = pointsSize(2);
            
            if (nPoints > 4)
                points = this.points;
                this.points = SnakePoint.empty;
                
                for n = 1 : 2 : nPoints
                    this.addPoint(points(1, n).position);
                end
            else
                this.deleteAllPoints();
            end           
        end
    end
end