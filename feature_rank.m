%   Function to compute Fisher-Score or Discriminating Coefficient
%   Inputs:             Input:          input data matrix where each row is a
%                                       feature and each column corresponds to an instance or example
%                       labels:         grouping variable that contains class
%                                       labels. It can be cell array of strings,
%                                       numerical array or logical array
%                       numIndices:     (optional) 
%                                       Number of significant features to be returned
%                       mehod:          (optional) 
%                                       Method for feature-ranking
%                                       'Fisher_Score'(default) or 
%                                       'Discriminating_Coefficient' 
%                                       
%   Outputs:            featureScore:   score of each feature according to
%                                       ranking criteria used
%                       index:          indices of features according to
%                                       the feature score
%   
%   References:                         Y. W. Chen and C. J. Lin,
%                                       ?Combining SVMs with various feature selection strategies?, Feature Extraction, Foundations and
%                                       Applications. New York, Springer-Verlag, 2006
%                                       T. Markiewicz  and S. Osowski1
%                                       "Data mining techniques for feature selection in blood cell recognition",
%                                       Proceedings of European Symposium on Artifical Neaural Networks, April 2006
% 
%   Author:                             Vishnu Muralidharan
%                                       Department of Electrical and
%                                       Computer Engineering
%                                       University of Alabama in Huntsville
function [featureScore] = feature_rank(Input) 
input=dataall;
        muA = mean(dataall);            % mean of given feature for class A
        muB = mean(vectorB);            % mean of given feature for class B
        sigmaA = std(vectorA);          % standard deviation of given feature for class A
        sigmaB = std(vectorB);          % standard deviation of given feature for class B
        scoreIndex(i,1) = (abs(muA - muB))/(sigmaA + sigmaB);   % compute Discriminating Coefficient
        scoreIndex(i,2) = i;                                    % store index of feature
    end
else 
    % compute Fisher Score between two classes for each feature
    for i=1:1:numFeat
        muFeat = mean(Input(i,:));      % extract mean of feature for both classes combined
        vectorA = Input(i,idxA);        
        vectorB = Input(i,idxB);        
        muA = mean(vectorA);            % mean of given feature for class A
        muB = mean(vectorB);            % mean of given feature for class B
        numer = ((muA - muFeat)^2) + ((muB - muFeat)^2);    % numerator of Fisher Score equation
        sumA = 0;
        sumB = 0;
        for k=1:1:numClassA
            sumA = sumA + (vectorA(k) - muA)^2;
        end
        term1 = sumA/(numClassA -1);
        for k=1:1:numClassB
            sumB = sumB + (vectorB(k) - muB)^2;
        end
        term2 = sumB/(numClassB -1);
        denom = term1 + term2;                              % denominator of Fisher Score equation
        scoreIndex(i,1) = numer/denom;                      % compute Fisher Score for the feature
        scoreIndex(i,2) = i;                                % store index of feature
    end
end
%% Rank features according to score
for i=1:1:numFeat - 1
    for j=1:1:numFeat - i
        % rank features and store their respective indices
        if scoreIndex(j,1) < scoreIndex(j+1,1)
            tempScore = scoreIndex(j,1);
            scoreIndex(j,1) = scoreIndex(j+1,1);
            scoreIndex(j+1,1) = tempScore;
            tempIdx = scoreIndex(j,2);
            scoreIndex(j,2) = scoreIndex(j+1,2);
            scoreIndex(j+1,2) = tempIdx;
        end
    end
end
%% Outputs
% Output scores of features
if isnan(numIndices)
    featureScore = scoreIndex(:,1);
    index = scoreIndex(:,2);
else
    featureScore = scoreIndex(1:numIndices,1);
    index = scoreIndex(1:numIndices,2);
end
 
