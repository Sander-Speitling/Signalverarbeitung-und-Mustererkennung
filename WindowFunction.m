classdef WindowFunction

    properties
        relAmpVec (1, :)
        relTimeVec (1, :)
    end

    methods
        function obj = WindowFunction(nRelAmpVec, nRelTimeVec)
            % Constructor sets the relative time and amp vectors to the
            % object´s properties
            arguments
                nRelAmpVec (1, :)
                nRelTimeVec (1, :)
            end
            obj.relAmpVec = nRelAmpVec;
            obj.relTimeVec = nRelTimeVec;  
        end
        
        %% Calc relative windowFunction in explicit
        function [xVec, yVec] = calcWindowFunction(self, count)
            % This function turns the relative Ampvec into an explicit
            % ampvec, containing as many values, as the input expresses.
            % The function than calculates the inner Gradelinefunctions
            % between each vertice and it´s verticies in between the values
            % of the relAmpVec(i)/relTimeVec(i) and the relAmpVec(i+1)/relTimeVec(i+1)
            % It than returns the y and xVectors
            arguments
                self
                count (1, :)
            end
            nCount = floor(count);
            nTVec = floor(self.relTimeVec * nCount) + 1;       % timevector
            segmentCount = max(size(self.relTimeVec));         % size return column and rowcount
            for k = 1 : segmentCount - 1 
                inc = (self.relAmpVec(k + 1) - self.relAmpVec(k)) / (nTVec(k + 1) - nTVec(k));
                indexVec = nTVec(k) : nTVec(k + 1) - 1;   
                if ( inc == 0 )
                    yVec(indexVec) = self.relAmpVec(k);
                else
                    yVec(indexVec) = self.relAmpVec(k) : inc : self.relAmpVec(k + 1) - inc;
                end
                stepPeriod = 1 / count;
                xVec = 0 : stepPeriod : 1 - stepPeriod;
            end
        end
    end
end