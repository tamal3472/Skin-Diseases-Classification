%This MATLAB program finds Average F-Measure for the feature set FS_i(2) with SVM classifier.
% 15 measurements have taken with this progam then averaged them manually.
% to find average F-Measure.

ComputeAll = 1;%To segment just one image (0) or all images (1) 
DirImages = 'E:\Data Thesis processing\lentigo simplex\segmented\'; %Directory including input image(s)
DirResults ='E:\Data Thesis processing\solar lentigo\jpg\renamed\'; %Directory including output mask(s)
NumImm=1; %The NumImm-th image in the directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Adjustable parameters:

MaxDim=1024; %Max width of input images (otherwise, they are scaled)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fmt='*.png'; %image format
if (ComputeAll)
    show       = 0; %Do not show results
    MustSave   = 1; %Save results on file
else
    show       = 1; %Show results
    MustSave   = 0; %Do not save results on file
end
%Creates the output directory, if necessary
if (MustSave && not(exist(DirResults,'dir')))
    mkdir(DirResults);
end

ImgName = strcat(DirImages,Fmt);
ImgList = dir(ImgName);
NumberOfImages = size(ImgList,1)
if (ComputeAll)
    ninit = 1; nend = NumberOfImages; 
else
    ninit = NumImm; nend = NumImm; 
end
datA=zeros(27,88);
tic
for number = ninit:nend
  ImgName = strcat(DirImages,cat(1,ImgList(number).name));
    fprintf('N. %d: %s\n',number,cat(1,ImgList(number).name));    
    I=imread(ImgName,'png');
    I=rgb2gray(I);
    GLCM2 = graycomatrix(I,'Offset',[0 2;-2 2;-2 0;-2 2],'Symmetric',true); 
    outt = GLCM_Features1(GLCM2,0);
    
    acor=outt.autoc;

    datA(number,1:22:88)=acor(:,:);
    
    % = zeros(1,size_glcm_3); % Autocorrelation 
    contra=outt.contr;
    %av_contra=sum(contra(:))/numel(contra);%= zeros(1,size_glcm_3); % Contrast
    datA(number,2:22:88)=contra(:,:);
    
    cor=outt.corrm; 
    %av_cor=sum(cor(:))/numel(cor);%= zeros(1,size_glcm_3); % Correlation
    datA(number,3:22:88)=cor(:,:);
     
    corrh=outt.corrp;
    %av_corrh=sum(corrh(:))/numel(corrh);% = zeros(1,size_glcm_3); % Correlation
    datA(number,4:22:88)=corrh(:,:);
    
    clp=outt.cprom; 
    %av_clp=sum(clp(:))/numel(clp);            %= zeros(1,size_glcm_3); % Cluster Prominence
    datA(number,5:22:88)=clp(:,:);
    
    clsh=outt.cshad; % = zeros(1,size_glcm_3); % Cluster Shade
    %av_clsh=sum(clsh(:))/numel(clsh);
    datA(number,6:22:88)=clsh(:,:);
    
    diss= outt.dissi; % = zeros(1,size_glcm_3); % Dissimilarity
    %av_diss=sum(diss(:))/numel(diss);
    datA(number,7:22:88)=diss(:,:);
    
    eng=outt.energ ;%= zeros(1,size_glcm_3); % Energy
    %av_eng=sum(eng(:))/numel(eng);
    datA(number,8:22:88)=eng(:,:);
    
    entro=outt.entro; % = zeros(1,size_glcm_3); % Entropy
    %av_entro=sum(entro(:))/numel(entro);
    datA(number,9:22:88)=entro(:,:);
    
    homm=outt.homom ;%= zeros(1,size_glcm_3); % Homogeneity: matlab
    %av_homm=sum(homm(:))/numel(homm);
    datA(number,10:22:88)=homm(:,:);
    
    hompp=outt.homop ;%= zeros(1,size_glcm_3); % Homogeneity
    %av_hompp=sum(hompp(:))/numel(hompp);
    datA(number,11:22:88)=hompp(:,:);
    
    maxpr=outt.maxpr; % = zeros(1,size_glcm_3); % Maximum probability
    %av_maxpr=sum(maxpr(:))/numel(maxpr);
    datA(number,12:22:88)=maxpr(:,:);
    
    var=outt.sosvh ;%= zeros(1,size_glcm_3); % Sum of sqaures
    %av_var=sum(var(:))/numel(var);
    datA(number,13:22:88)=var(:,:);
    
    sumav=outt.savgh ;%= zeros(1,size_glcm_3); % Sum average
    %av_sumav=sum(sumav(:))/numel(sumav);
    datA(number,14:22:88)=sumav(:,:);
    
    sumvar=outt.svarh ;%= zeros(1,size_glcm_3); % Sum variance
    %av_sumvar=sum(sumvar(:))/numel(sumvar);
    datA(number,15:22:88)=sumvar(:,:);
    
    sumentro=outt.senth ;%= zeros(1,size_glcm_3); % Sum entropy
    %av_sumentro=sum(sumentro(:))/numel(sumentro);
    datA(number,16:22:88)=sumentro(:,:);
    
    diffvar=outt.dvarh ;%= zeros(1,size_glcm_3); % Difference variance
    %av_diffvar=sum(diffvar(:))/numel(diffvar);
    datA(number,17:22:88)=diffvar(:,:);
    
    diffentro=outt.denth ;%= zeros(1,size_glcm_3); % Difference entropy
    %av_diffentro=sum(diffentro(:))/numel(diffentro);
    datA(number,18:22:88)=diffentro(:,:);
    
    infcor1=outt.inf1h ;%= zeros(1,size_glcm_3); % Information measure of correlation1
    %av_infcor1=sum(infcor1(:))/numel(infcor1);
    datA(number,19:22:88)=infcor1(:,:);
    
    infcor2=outt.inf2h ;%= zeros(1,size_glcm_3); % Informaiton measure of correlation2
    %av_infcor2=sum(infcor2(:))/numel(infcor2);
    datA(number,20:22:88)=infcor2(:,:);
    
    invdnor=outt.indnc ;%= zeros(1,size_glcm_3); % Inverse difference normalized (INN)
    %av_invdnor=sum(invdnor(:))/numel(invdnor);
    datA(number,21:22:88)=invdnor(:,:);
    
    invdmnor=outt.idmnc;
    %av_invdmnor=sum(invdmnor(:))/numel(invdmnor);
    datA(number,22:22:88)=invdmnor(:,:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %1) Reduces image size (-->I2)
   
end
toc


ComputeAll = 1;%To segment just one image (0) or all images (1) 
DirImages = 'E:\Data Thesis processing\solar lentigo\segmented\'; %Directory including input image(s)
DirResults ='E:\Data Thesis processing\solar lentigo\jpg\renamed\'; %Directory including output mask(s)
NumImm=1; %The NumImm-th image in the directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Adjustable parameters:

MaxDim=1024; %Max width of input images (otherwise, they are scaled)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fmt='*.png'; %image format
if (ComputeAll)
    show       = 0; %Do not show results
    MustSave   = 1; %Save results on file
else
    show       = 1; %Show results
    MustSave   = 0; %Do not save results on file
end
%Creates the output directory, if necessary
if (MustSave && not(exist(DirResults,'dir')))
    mkdir(DirResults);
end

ImgName = strcat(DirImages,Fmt);
ImgList = dir(ImgName);
NumberOfImages = size(ImgList,1)
if (ComputeAll)
    ninit = 1; nend = NumberOfImages; 
else
    ninit = NumImm; nend = NumImm; 
end
datB=zeros(56,22);
tic
for number = ninit:nend
  ImgName = strcat(DirImages,cat(1,ImgList(number).name));
    fprintf('N. %d: %s\n',number,cat(1,ImgList(number).name));    
    I=imread(ImgName,'png');
    I=rgb2gray(I);
    GLCM2 = graycomatrix(I,'Offset',[0 2;-2 2;-2 0;-2 2],'Symmetric',true); 
    outt = GLCM_Features1(GLCM2,0);
    
    acor=outt.autoc;

    datB(number,1:22:88)=acor(:,:);
    
    % = zeros(1,size_glcm_3); % Autocorrelation
    contra=outt.contr;
    %av_contra=sum(contra(:))/numel(contra);%= zeros(1,size_glcm_3); % Contrast
    datB(number,2:22:88)=contra(:,:);
    
    cor=outt.corrm; 
    %av_cor=sum(cor(:))/numel(cor);%= zeros(1,size_glcm_3); % Correlation
    datB(number,3:22:88)=cor(:,:);
     
    corrh=outt.corrp;
    %av_corrh=sum(corrh(:))/numel(corrh);% = zeros(1,size_glcm_3); % Correlation
    datB(number,4:22:88)=corrh(:,:);
    
    clp=outt.cprom; 
    %av_clp=sum(clp(:))/numel(clp);            %= zeros(1,size_glcm_3); % Cluster Prominence
    datB(number,5:22:88)=clp(:,:);
    
    clsh=outt.cshad; % = zeros(1,size_glcm_3); % Cluster Shade
    %av_clsh=sum(clsh(:))/numel(clsh);
    datB(number,6:22:88)=clsh(:,:);
    
    diss= outt.dissi; % = zeros(1,size_glcm_3); % Dissimilarity
    %av_diss=sum(diss(:))/numel(diss);
    datB(number,7:22:88)=diss(:,:);
    
    eng=outt.energ ;%= zeros(1,size_glcm_3); % Energy
    %av_eng=sum(eng(:))/numel(eng);
    datB(number,8:22:88)=eng(:,:);
    
    entro=outt.entro; % = zeros(1,size_glcm_3); % Entropy
    %av_entro=sum(entro(:))/numel(entro);
    datB(number,9:22:88)=entro(:,:);
    
    homm=outt.homom ;%= zeros(1,size_glcm_3); % Homogeneity
    %av_homm=sum(homm(:))/numel(homm);
    datB(number,10:22:88)=homm(:,:);
    
    hompp=outt.homop ;%= zeros(1,size_glcm_3); % Homogeneity
    %av_hompp=sum(hompp(:))/numel(hompp);
    datB(number,11:22:88)=hompp(:,:);
    
    maxpr=outt.maxpr; % = zeros(1,size_glcm_3); % Maximum probability
    %av_maxpr=sum(maxpr(:))/numel(maxpr);
    datB(number,12:22:88)=maxpr(:,:);
    
    var=outt.sosvh ;%= zeros(1,size_glcm_3); % Sum of sqaures
    %av_var=sum(var(:))/numel(var);
    datB(number,13:22:88)=var(:,:);
    
    sumav=outt.savgh ;%= zeros(1,size_glcm_3); % Sum average
    %av_sumav=sum(sumav(:))/numel(sumav);
    datB(number,14:22:88)=sumav(:,:);
    
    sumvar=outt.svarh ;%= zeros(1,size_glcm_3); % Sum variance
    %av_sumvar=sum(sumvar(:))/numel(sumvar);
    datB(number,15:22:88)=sumvar(:,:);
    
    sumentro=outt.senth ;%= zeros(1,size_glcm_3); % Sum entropy 
    %av_sumentro=sum(sumentro(:))/numel(sumentro);
    datB(number,16:22:88)=sumentro(:,:);
    
    diffvar=outt.dvarh ;%= zeros(1,size_glcm_3); % Difference variance
    %av_diffvar=sum(diffvar(:))/numel(diffvar);
    datB(number,17:22:88)=diffvar(:,:);
    
    diffentro=outt.denth ;%= zeros(1,size_glcm_3); % Difference entropy 
    %av_diffentro=sum(diffentro(:))/numel(diffentro);
    datB(number,18:22:88)=diffentro(:,:);
    
    infcor1=outt.inf1h ;%= zeros(1,size_glcm_3); % Information measure of correlation1
    %av_infcor1=sum(infcor1(:))/numel(infcor1);
    datB(number,19:22:88)=infcor1(:,:);
    
    infcor2=outt.inf2h ;%= zeros(1,size_glcm_3); % Informaiton measure of correlation2 
    %av_infcor2=sum(infcor2(:))/numel(infcor2);
    datB(number,20:22:88)=infcor2(:,:);
    
    invdnor=outt.indnc ;%= zeros(1,size_glcm_3); % Inverse difference normalized (INN)
    %av_invdnor=sum(invdnor(:))/numel(invdnor);
    datB(number,21:22:88)=invdnor(:,:);
    
    invdmnor=outt.idmnc;
    %av_invdmnor=sum(invdmnor(:))/numel(invdmnor);
    datB(number,22:22:88)=invdmnor(:,:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %1) Reduces image size (-->I2)
   
   
end
toc
%%
dataall=zeros(81,88);

class=zeros(81,1);
class1=zeros(27,1);
class1(:,:)=1;

dataall(1:27,:)=datA(: ,:);
dataall(28:81,:)=datB(1:54,:);
classall=zeros(81,1);
classall(1:27,1)=1;
classall(28:81,1)=2;
[Train, Test] = crossvalind('HoldOut', classall, 0.3);
datatrain = dataall(Train,:);
datatest=dataall(Test,:);
classtrain=classall(Train,:);
classtest=classall(Test,:);
min=0;
%imbalance class
SVMModels = fitcsvm(datatrain,classtrain,'KernelFunction','rbf','KernelScale','auto','Standardize', true,'BoxConstraint',1,'OutlierFraction',0.20);
CVSVMModel = crossval(SVMModels);
classLoss = kfoldLoss(CVSVMModel);
[label,score] = predict(SVMModels,datatest);
 EVAL = eevaluate(classtest,label);