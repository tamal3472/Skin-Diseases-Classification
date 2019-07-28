
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
datA=zeros(27,22);
tic
for number = ninit:nend
  ImgName = strcat(DirImages,cat(1,ImgList(number).name));
    fprintf('N. %d: %s\n',number,cat(1,ImgList(number).name));    
    I=imread(ImgName,'png');
    I=rgb2gray(I);
    GLCM2 = graycomatrix(I,'Offset',[0 2;-2 2;-2 0;-2 2],'Symmetric',true); 
    outt = GLCM_Features1(GLCM2,0);
    %1
    acor=outt.autoc;
    av_acor=sum(acor(:))/numel(acor);
    datA(number,1)=av_acor;
    
    %2 = zeros(1,size_glcm_3); % Autocorrelation: [2] 
    contra=outt.contr;
    av_contra=sum(contra(:))/numel(contra);%= zeros(1,size_glcm_3); % Contrast: matlab/[1,2]
    datA(number,2)=av_contra;
    %3
    cor=outt.corrm; 
    av_cor=sum(cor(:))/numel(cor);%= zeros(1,size_glcm_3); % Correlation: matlab
    datA(number,3)=av_cor;
     %4
    corrh=outt.corrp;
    av_corrh=sum(corrh(:))/numel(corrh);% = zeros(1,size_glcm_3); % Correlation: [1,2]
    datA(number,4)=av_corrh;
    %5
    clp=outt.cprom; 
    av_clp=sum(clp(:))/numel(clp);            %= zeros(1,size_glcm_3); % Cluster Prominence: [2]
    datA(number,5)=av_clp;
    %6
    clsh=outt.cshad; % = zeros(1,size_glcm_3); % Cluster Shade: [2
    av_clsh=sum(clsh(:))/numel(clsh);
    datA(number,6)=av_clsh;
    %7
    diss= outt.dissi; % = zeros(1,size_glcm_3); % Dissimilarity: [2]
    av_diss=sum(diss(:))/numel(diss);
    datA(number,7)=av_diss;
    %8
    eng=outt.energ ;%= zeros(1,size_glcm_3); % Energy: matlab / [1,2]
    av_eng=sum(eng(:))/numel(eng);
    datA(number,8)=av_eng;
    %9
    entro=outt.entro; % = zeros(1,size_glcm_3); % Entropy: [2]
    av_entro=sum(entro(:))/numel(entro);
    datA(number,9)=av_entro;
    %10
    homm=outt.homom ;%= zeros(1,size_glcm_3); % Homogeneity: matlab
    av_homm=sum(homm(:))/numel(homm);
    datA(number,10)=av_homm;
    %11
    hompp=outt.homop ;%= zeros(1,size_glcm_3); % Homogeneity
    av_hompp=sum(hompp(:))/numel(hompp);
    datA(number,11)=av_hompp;
    %12
    maxpr=outt.maxpr; % = zeros(1,size_glcm_3); % Maximum probability
    av_maxpr=sum(maxpr(:))/numel(maxpr);
    datA(number,12)=av_maxpr;
    %13
    vari=outt.sosvh ;%= zeros(1,size_glcm_3); % Sum of sqaures: Variance 
    av_var=sum(vari(:))/numel(vari);
    datA(number,13)=av_var;
    %14
    sumav=outt.savgh ;%= zeros(1,size_glcm_3); % Sum average 
    av_sumav=sum(sumav(:))/numel(sumav);
    datA(number,14)=av_sumav;
    %15
    sumvar=outt.svarh ;%= zeros(1,size_glcm_3); % Sum variance
    av_sumvar=sum(sumvar(:))/numel(sumvar);
    datA(number,15)=av_sumvar;
    %16
    sumentro=outt.senth ;%= zeros(1,size_glcm_3); % Sum entropy 
    av_sumentro=sum(sumentro(:))/numel(sumentro);
    datA(number,16)=av_sumentro;
    %17
    diffvar=outt.dvarh ;%= zeros(1,size_glcm_3); % Difference variance
    av_diffvar=sum(diffvar(:))/numel(diffvar);
    datA(number,17)=av_diffvar;
    %18
    diffentro=outt.denth ;%= zeros(1,size_glcm_3); % Difference entropy 
    av_diffentro=sum(diffentro(:))/numel(diffentro);
    datA(number,18)=av_diffentro;
    %19
    infcor1=outt.inf1h ;%= zeros(1,size_glcm_3); % Information measure of correlation1
    av_infcor1=sum(infcor1(:))/numel(infcor1);
    datA(number,19)=av_infcor1;
    %20
    infcor2=outt.inf2h ;%= zeros(1,size_glcm_3); % Informaiton measure of correlation2
    av_infcor2=sum(infcor2(:))/numel(infcor2);
    datA(number,20)=av_infcor2;
    %21
    invdnor=outt.indnc ;%= zeros(1,size_glcm_3); % Inverse difference normalized (INN) 
    av_invdnor=sum(invdnor(:))/numel(invdnor);
    datA(number,21)=av_invdnor;
    %22
    invdmnor=outt.idmnc;
    av_invdmnor=sum(invdmnor(:))/numel(invdmnor);
    datA(number,22)=av_invdmnor;
   
   
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
    av_acor=sum(acor(:))/numel(acor);
    datB(number,1)=av_acor;
    
    % = zeros(1,size_glcm_3); % Autocorrelation
    contra=outt.contr;
    av_contra=sum(contra(:))/numel(contra);%= zeros(1,size_glcm_3); % Contrast
    datB(number,2)=av_contra;
    
    cor=outt.corrm; 
    av_cor=sum(cor(:))/numel(cor);%= zeros(1,size_glcm_3); % Correlation: matlab
    datB(number,3)=av_cor;
     
    corrh=outt.corrp;
    av_corrh=sum(corrh(:))/numel(corrh);% = zeros(1,size_glcm_3); % Correlation
    datB(number,4)=av_corrh;
    
    clp=outt.cprom; 
    av_clp=sum(clp(:))/numel(clp);            %= zeros(1,size_glcm_3); % Cluster Prominence
    datB(number,5)=av_clp;
    
    clsh=outt.cshad; % = zeros(1,size_glcm_3); % Cluster Shade
    av_clsh=sum(clsh(:))/numel(clsh);
    datB(number,6)=av_clsh;
    
    diss= outt.dissi; % = zeros(1,size_glcm_3); % Dissimilarity
    av_diss=sum(diss(:))/numel(diss);
    datB(number,7)=av_diss;
    
    eng=outt.energ ;%= zeros(1,size_glcm_3); % Energy
    av_eng=sum(eng(:))/numel(eng);
    datB(number,8)=av_eng;
    
    entro=outt.entro; % = zeros(1,size_glcm_3); % Entropy
    av_entro=sum(entro(:))/numel(entro);
    datB(number,9)=av_entro;
    
    homm=outt.homom ;%= zeros(1,size_glcm_3); % Homogeneity: matlab
    av_homm=sum(homm(:))/numel(homm);
    datB(number,10)=av_homm;
    
    hompp=outt.homop ;%= zeros(1,size_glcm_3); % Homogeneity
    av_hompp=sum(hompp(:))/numel(hompp);
    datB(number,11)=av_hompp;
    
    maxpr=outt.maxpr; % = zeros(1,size_glcm_3); % Maximum probability
    av_maxpr=sum(maxpr(:))/numel(maxpr);
    datB(number,12)=av_maxpr;
    
    vari=outt.sosvh ;%= zeros(1,size_glcm_3); % Sum of sqaures
    av_var=sum(vari(:))/numel(vari);
    datB(number,13)=av_var;
    
    sumav=outt.savgh ;%= zeros(1,size_glcm_3); % Sum average
    av_sumav=sum(sumav(:))/numel(sumav);
    datB(number,14)=av_sumav;
    
    sumvar=outt.svarh ;%= zeros(1,size_glcm_3); % Sum variance
    av_sumvar=sum(sumvar(:))/numel(sumvar);
    datB(number,15)=av_sumvar;
    
    sumentro=outt.senth ;%= zeros(1,size_glcm_3); % Sum entropy
    av_sumentro=sum(sumentro(:))/numel(sumentro);
    datB(number,16)=av_sumentro;
    
    diffvar=outt.dvarh ;%= zeros(1,size_glcm_3); % Difference variance
    av_diffvar=sum(diffvar(:))/numel(diffvar);
    datB(number,17)=av_diffvar;
    
    diffentro=outt.denth ;%= zeros(1,size_glcm_3); % Difference entropy 
    av_diffentro=sum(diffentro(:))/numel(diffentro);
    datB(number,18)=av_diffentro;
    
    infcor1=outt.inf1h ;%= zeros(1,size_glcm_3); % Information measure of correlation1 
    av_infcor1=sum(infcor1(:))/numel(infcor1);
    datB(number,19)=av_infcor1;
    
    infcor2=outt.inf2h ;%= zeros(1,size_glcm_3); % Informaiton measure of correlation2 
    av_infcor2=sum(infcor2(:))/numel(infcor2);
    datB(number,20)=av_infcor2;
    
    invdnor=outt.indnc ;%= zeros(1,size_glcm_3); % Inverse difference normalized (INN) 
    av_invdnor=sum(invdnor(:))/numel(invdnor);
    datB(number,21)=av_invdnor;
    
    invdmnor=outt.idmnc;
    av_invdmnor=sum(invdmnor(:))/numel(invdmnor);
    datB(number,22)=av_invdmnor;
   
end
toc
%%
dataall=zeros(80,22);

class=zeros(81,1);
class1=zeros(27,1);
class1(:,:)=1;

%asd=zeros(54,22);
%[asd class]=SMOTE(datA,class1);
dataall(1:20,:)=datA(1:20 ,:);
dataall(21:40,:)=datA(1:20,:);
dataall(41:80,:)=datB(1:40,:);
datatestt=zeros(21,22);
datatestt(1:7,:)=datA(21:27,:);
datatestt(8:21,:)=datB(41:54,:);


classall=zeros(80,1);

classall(1:40,1)=1;
classall(41:80,1)=2;





%[Train, Test] = crossvalind('HoldOut', classall, 0.3);

classtestt=zeros(21,1);
classtestt(1:7,1)=1;
classtestt(8:21,1)=2;

SVMModels = fitcsvm(dataall,classall,'KernelFunction','rbf','KernelScale','auto', 'Standardize', true,'BoxConstraint',1,'OutlierFraction',0.20);
%SVMModels = fitcsvm(dattrain,classtrain);
%knn=fitcknn(dattrain_f, classtrain,'NumNeighbors',3);
CVSVMModel = crossval(SVMModels);
%classLoss = kfoldLoss(knn);
[label,score] = predict(SVMModels,datatestt);
[rr, cc]=size(label);
count=0;
conf=zeros(2,2);
for i=1:rr
    if(label(i,1)==classtestt(i,1))
        count=count+1;
       % conf
    end
end
 accu=count/numel(label)
EVAL = eevaluate(classtestt,label);