% This class implements the possibility to create an instrument (either a
% guitar or a piano. According to their variety of sounds, it has a list of
% it´s scale, tonenames and it´s (deepest basetone). 
% To keep it a bit more simple, we only used the empty strings of the guitar. 

classdef Instruments

    properties
        scale (1, :)
        baseTone Tone
        toneNames (1 , :)
    end

    methods
        function obj = Instruments(instrument)
            arguments
                instrument string
            end
            %% Guitarconstructor
            % Setting the basetone of this instrument´s instance to the
            % deepest e- String of the guitar with a frequency of 82Hz,
            % followed by an if-loop, filling it´s scale with the remaining
            % strings, based on the baseTone.
            if(instrument == "guitar")
                obj.baseTone = Tone(1, 82 * nthroot(2,12)^0, -pi/2, 1, 11025);
                obj.scale = [];
                for i = 1 : 6
                    obj.scale = [obj.scale Tone(1, 82 * nthroot(2,12)^((i - 1) * 5), -pi/2, 1, 11025)];
                end       
                obj.toneNames = ["E", "A", "D", "G", "B", "E"];

            %% Pianoconstructor
            % Setting the basetone of this instrument´s instance to the
            % deepest piano key "a" of the piano with a frequency of  27.5 Hz,
            % followed by an if-loop, filling it´s scale with the remaining
            % keys, based on the baseTone.
            else if(instrument == "piano")
                    obj.baseTone = Tone(1, 27.5 * nthroot(2,12)^0, -pi/2, 1, 11025);
                    obj.scale = [];
                    for i = 1 : 88
                        newTone = Tone(1, 27.5 * nthroot(2,12)^(i - 1), -pi/2, 1, 11025);
                        obj.scale = [obj.scale newTone];
                    end
                    % Since the piano has 88 keys for usual, the array
                    % toneNames will be filled up with the basic scale
                    % repeating itself.
                    allTones = ["A ", "A# ", "B ", "C ", "C# ", "D ", "D# ", "E ", "F ", "F# ", "G ", "G# "];
                    for i = 1 : 7
                        for j = 1 : 12
                        obj.toneNames = [obj.toneNames strcat(allTones(j), int2str(i))];
                        end
                    end
                    obj.toneNames = [obj.toneNames "A 8", 'A# 8', "B 8", "C 8"];
            %% Error
            % Incase the constructor is called with an incorrect output,
            % the programm will throw an exception
            else
                ME = MException('MyComponent:noSuchInstrument', ...
                    'Instrument %s not found', instrument);
                throw(ME)
            end
            end
        end
    end
end