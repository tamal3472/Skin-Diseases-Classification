TrainPath='orl_faces';
groups=[];
T=[];


for i = 1:40
    
        tempDir=strcat('s',int2str(i));
        tempTrainPath=strcat(TrainPath,'\', tempDir);
        TrainFiles=dir(tempTrainPath);
        fileNo=1;
        for  j=1:size(TrainFiles)
            if not(strcmp(TrainFiles(j).name,'.')|strcmp(TrainFiles(j).name,'..'))
                str = int2str(fileNo);
                str = strcat(tempTrainPath,'\',str,'.pgm');
                
                
                img = imread(str);
                
                
                
    
                [irow icol] = size(img);
   
                temp = reshape(img',1,irow*icol);   % Reshaping 2D images into 1D image vectors
                T = [T; temp]; % 'T' grows after each turn      
    
                fileNo=fileNo+1;
                groups=[groups; i];
            end
        
         
        end
           
     
end


[n,p] = size(T);
data= double(T) - repmat(mean(T,1),n,1);


features = data;
class = groups;

[train, test] = crossvalind('HoldOut', class, 0.1);

featuresTrain = features(train,:);
classTrain = class(train,:);
featuresTest = features(test,:);
classTest = class(test,:);

save faceDataBase.mat featuresTrain classTrain featuresTest classTest
