classdef SnakePoint < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Access=public)
        position = [0, 0];
        elasticForce = [0, 0];
        curvatureForce = [0, 0];
        imageForce = [0, 0];
    end
    
    methods(Access=public)
        function this = SnakePoint
        end
    end
end