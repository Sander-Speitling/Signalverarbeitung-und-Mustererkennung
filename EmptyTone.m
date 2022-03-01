% An empty tone when created with the duration of 0, no data Vectors or
% signalprops
classdef EmptyTone < Tone 

    methods
        function obj = EmptyTone(sampleRate)
           obj = obj@Tone([], [], [], 0, sampleRate);
        end
    end

end