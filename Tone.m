% The class tone is the heart of this program. Instances of it contain the
% data-/amplitude- vectors to be able to play, concat, repeat, normalize
% interfer them.

classdef Tone

    properties     
        sampleRate double
        samplePeriod double
        duration double
        frequencies (1,:)
        timeVector (1,:)
        ampVector (1,:)        
    end
    

    methods (Access = public)
        %% Constructor
        % Constructing an instance requires all the data to forge a signal
        % out of it.
        function obj = Tone(amplitudes, frequencies, phases, duration, sampleRate)
            arguments
                amplitudes (1,:)
                frequencies (1,:)
                phases (1,:)
                duration double
                sampleRate double = 11025
            end            
            % Sets given properties to object´s properties
            obj.duration = duration;
            obj.sampleRate = sampleRate;
            obj.samplePeriod = 1 / sampleRate;
            obj.frequencies = frequencies;
            % Generates the Signalvectors with given properties
            [timeVector, ampVector] = obj.generateSound(amplitudes, frequencies, phases, sampleRate, duration);
            obj.ampVector = ampVector;
            obj.timeVector = timeVector;
        end
        
        %% Generate Soundsignal
        function [timeVector, ampVector] = generateSound(self, amplitudes, frequencies, phases, sampleRate, duration)
          % This function generates a signal using the elements of the given
          % amplitude, frequency and phase vectors. 
          % It loop of each element in the amplitudes(-list), creates a
          % sinuswave out of it, and interfers it each iteration with the
          % existing ampVectors
          num_amps = length(amplitudes);
          sample_period = 1 / double(sampleRate);
          
          timeVector = 0 : sample_period : duration - sample_period;
          ampVector = zeros(1, length(timeVector));
        
          for i = 1 : num_amps
              A = amplitudes(i);
              f = frequencies(i);
              p = phases(i);
        
              ampVector = ampVector + A * cos(2 * pi * f * timeVector + p);
          end
        end
        
        %% Interfer Sounds
        function self = interferSounds(self, others)
            % Interfers the sound it self, with given other tones as props
            % for any wanted Duration
            arguments
                self
                others(1, :)
            end
            
            % After verifying, that all the samplerates are egual, the function loops over the given list and interfers their ampVectors with
            % each other by the '+'-Operator
            for i = 1 : length(others)
                if ~(self.sampleRate == others(i).sampleRate)
                    return;
                end
                self.ampVector = self.ampVector(1:length(self.ampVector)) + others(i).ampVector(1:length(self.ampVector));
                self.frequencies = [self.frequencies others(i).frequencies];
            end     
        end

        %% Concat Tones
        function self = concatTone(self, others)
            % After verifying, that all the samplerates are egual, the
            % function loops over the given list,
            % adds up their durations, frequencies and concats their
            % ampVectors
            arguments
                self
                others(1, :)
            end
            totalDuration = self.duration;
            for i = 1 : length(others)
                if ~(self.sampleRate == others(i).sampleRate)
                    return;
                end
                totalDuration = totalDuration + others(i).duration;
                self.ampVector = [self.ampVector others(i).ampVector];
                self.frequencies = [self.frequencies others(i).frequencies];
            end  
            self.duration = totalDuration;
            self.timeVector = 0 : self.samplePeriod : totalDuration - self.samplePeriod;
        end

        %% Repeat tone
        function self = repeat(self, N)
            % Calculates it´s new timevector and repeats it´s ampvector via
            % repmat(...)
            arguments
                self
                N int32
            end
            self.timeVector = 0 : self.samplePeriod : double(N) * self.duration - self.samplePeriod;
            self.ampVector = repmat(self.ampVector, 1, N);
        end

        %% Play tone
        function play(self)
            % Sends the time discrete signal to the speakers
            sound(self.ampVector, double(self.sampleRate));
        end

        %% Normalize ampvector
        function self = normalize(self)
            % To prevend it from oversteering when played
            self.ampVector = self.ampVector ./ max(self.ampVector);
        end
    end
end